#
# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Patches RUNPATH in gRPC plugins
# Creates preconfig.cmake
#

cmake_minimum_required(VERSION 3.15)
project(postinstall)

include(CMakePrintHelpers)

set(PATCH_PLUGINS ON CACHE BOOL "Patch gRPC plugins")
set(CREATE_PRECONFIG ON CACHE BOOL "Create preconfig.cmake file")

#-----------------------------------------------------------------------
# find_patchelf_command()
#-----------------------------------------------------------------------
function(find_patchelf_command)
  find_program(PATCHELF_COMMAND "patchelf" NO_CMAKE_FIND_ROOT_PATH)
  if(PATCHELF_COMMAND)
    execute_process(
      COMMAND ${PATCHELF_COMMAND} --version
      OUTPUT_VARIABLE version_message
    )
    string(STRIP "${version_message}" version_message)
    message(STATUS "Found ${version_message}: ${PATCHELF_COMMAND}")
  else()
    message(STATUS "patchelf not found")
  endif()
  mark_as_advanced(PATCHELF_COMMAND)
endfunction()

#-----------------------------------------------------------------------
# patch_grpc_plugin()
#-----------------------------------------------------------------------
function(patch_grpc_plugin PLUGIN RPATH)
  string(TOLOWER ${PLUGIN} plugin_name)
  string(TOUPPER ${PLUGIN} plugin_var)

  find_program(${plugin_var} "${plugin_name}" NO_CMAKE_FIND_ROOT_PATH)
  if(${plugin_var})
    set(executable ${${plugin_var}})

    message(STATUS "Found ${plugin_name}: ${executable}")

    execute_process(
      COMMAND ${PATCHELF_COMMAND} --print-rpath ${executable}
      OUTPUT_VARIABLE output_var
      RESULT_VARIABLE error_var
      RESULT_VARIABLE result_var
    )
    string(STRIP "${output_var}" output_var)
    string(STRIP "${error_var}" error_var)
    string(STRIP "${result_var}" result_var)

    if(NOT result_var EQUAL 0)
      message("Error reading RPATH: ${error_var}")
      return()
    endif()

    if(output_var STREQUAL "${RPATH}")
      message(STATUS "${plugin_name} already patched")
      return()
    endif()

    message(STATUS "Patching ${plugin_name}")
    execute_process(
      COMMAND ${PATCHELF_COMMAND} --set-rpath "${RPATH}" ${executable}
      OUTPUT_VARIABLE output_var
      ERROR_VARIABLE error_var
      RESULT_VARIABLE result_var
    )
    string(STRIP "${result_var}" result_var)
    string(STRIP "${error_var}" error_var)
    string(STRIP "${result_var}" result_var)

    if(result_var EQUAL 0)
      message(STATUS "${plugin_name} patch succeeded")
    else()
      message(ERROR "${plugin_name} patch failed: ${error_var}")
    endif()
  else()
    message("${plugin_name} not found")
  endif()
endfunction(patch_grpc_plugin)

#-----------------------------------------------------------------------
# patch_plugins()
#-----------------------------------------------------------------------
function(patch_plugins)
  find_patchelf_command()

  if(PATCHELF_COMMAND)
    set(runpath "$ORIGIN/../lib")
    patch_grpc_plugin(grpc_cpp_plugin "${runpath}")
    patch_grpc_plugin(grpc_python_plugin "${runpath}")
  else()
    message(WARNING "Cannot patch plugins without patchelf")
  endif()
endfunction()

#-----------------------------------------------------------------------
# create_preconfig_file()
#-----------------------------------------------------------------------
function(create_preconfig_file)
  if(NOT DEFINED DEPS_SOURCE_DIR)
    message(
      WARNING "DEPS_SOURCE_DIR not defined; cannot create preconfig.cmake")
    return()
  endif()

  set(preconfig_file ${DEPS_SOURCE_DIR}/preconfig.cmake)

  if(NOT EXISTS ${preconfig_file})
    message(STATUS "Creating preconfig.cmake")
    file(WRITE ${preconfig_file}
      "# Override default values\n"
      "set(DOWNLOAD OFF CACHE BOOL \"preconfig: Download repositories\")\n"
      "set(PATCH OFF CACHE BOOL \"preconfig: patch source after downloading\")\n"
    )
  else()
    message(STATUS "preconfig.cmake already exists")
  endif()
endfunction()

#-----------------------------------------------------------------------
# Post-install actions
#-----------------------------------------------------------------------
if(PATCH_PLUGINS)
  patch_plugins()
endif()

if(CREATE_PRECONFIG)
  create_preconfig_file()
endif()
