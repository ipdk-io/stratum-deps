# Downloads and builds gRPC
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

unset(_build_codegen_option)
unset(_depends_clause)
unset(_download_clause)
unset(_grpc_cxx_standard)
unset(_package_providers)
unset(_patch_clause)

#-----------------------------------------------------------------------
# define_grpc_patch_file()
# Returns the filename of the template patch file.
#
# Parameters:
#   PATCHDIR - directory containing patch files.
#   OUTVAR - name of output variable.
#
# Variables:
#   GRPC_PATCH - name of gRPC patch file.
#   GRPC_VERSION - version of gRPC being patched.
#
# Choices are, in descending order of precedence:
#  1. ${GRPC_PATCHFILE}
#  2. grpc-v$(GRPC_VERSION}.patch.in
#  3. grpc-current.patch.in
#
# Returns an empty string if we cannot determine a valid patch file name.
#-----------------------------------------------------------------------
function(define_grpc_patch_file PATCHDIR OUTVAR)
  # Specified patch file
  if(DEFINED GRPC_PATCHFILE AND NOT GRPC_PATCHFILE STREQUAL "")
    set(patchfile "${GRPC_PATCHFILE}")
    if(EXISTS ${PATCHDIR}/${patchfile})
      set(${OUTVAR} "${patchfile}" PARENT_SCOPE)
    else()
      message("----------------------------------------")
      message("Patch file '${patchfile}' does not exist.")
      message("Check definition of GRPC_PATCHFILE.")
      message("Its current value is '${GRPC_PATCHFILE}.'")
      message("----------------------------------------")
      message(WARNING "Skipping patch stage")
      set(${OUTVAR} "" PARENT_SCOPE)
    endif()
    return()
  endif()

  # Patch file for gRPC version
  if(DEFINED GRPC_VERSION)
    set(version_file "grpc-v${GRPC_VERSION}.patch.in")
    if(EXISTS ${PATCHDIR}/${version_file})
      set(${OUTVAR} "${version_file}" PARENT_SCOPE)
      return()
    endif()
  endif()

  # Current patch file
  set(patchfile "grpc-current.patch.in")
  if(EXISTS ${PATCHDIR}/${patchfile})
    set(${OUTVAR} "${patchfile}" PARENT_SCOPE)
    return()
  endif()

  # Patch file not found
  if(DEFINED version_file)
    message("----------------------------------------")
    message("Patch file '${version_file}' does not exist.")
    message("Check definition of GRPC_VERSION.")
    message("Its current value is '${GRPC_VERSION}'.")
    message("----------------------------------------")
    message(WARNING "Skipping patch stage")
  else()
    message(STATUS "Skipping patch stage")
  endif()
  set(${OUTVAR} "" PARENT_SCOPE)
endfunction(define_grpc_patch_file)

#-----------------------------------------------------------------------
# define_grpc_patch_clause()
# Generates the patch file from the template and returns a PATCH
# clause for the ExternalProject_Add() command. Returns an empty
# string if patching is suppressed.
#-----------------------------------------------------------------------
function(define_grpc_patch_clause OUTVAR)
  set(patch_dir ${CMAKE_SOURCE_DIR}/cmake/patches)

  define_grpc_patch_file("${patch_dir}" patch_file)
  if(patch_file STREQUAL "")
    return()
  endif()

  message(STATUS "Generating grpc.patch from ${patch_file}")

  set(configured_patch ${CMAKE_CURRENT_BINARY_DIR}/grpc.patch)

  # Substitution variable
  set(GRPC_INSTALL_RPATH $ORIGIN/../lib64:$ORIGIN/../lib)

  configure_file(
    ${patch_dir}/${patch_file}
    ${configured_patch}
    @ONLY
  )

  set(patch_clause
    PATCH_COMMAND
      patch -i ${configured_patch} -p1 ${FORCE_OPTION}
  )
  set(${OUTVAR} "${patch_clause}" PARENT_SCOPE)
endfunction(define_grpc_patch_clause)

#-----------------------------------------------------------------------
# Define build options
#-----------------------------------------------------------------------
if(PATCH)
  # Patch the gRPC build script to set the RUNPATH of the installed
  # Protobuf compiler plugins to the relative paths of the library
  # directories, and return a patch clause for ExternalProject_Add().
  define_grpc_patch_clause(_patch_clause)
endif()

if(CMAKE_CROSSCOMPILING)
  # If we're cross-compiling for the target system, don't build the
  # gRPC code generation executables.
  set(_build_codegen_option -DgRPC_BUILD_CODEGEN=off)
endif()

if(DEFINED CURRENT_CXX_STANDARD AND NOT CURRENT_CXX_STANDARD STREQUAL "")
  set(_grpc_cxx_standard -DCMAKE_CXX_STANDARD=${CURRENT_CXX_STANDARD})
endif()

if(OVERRIDE_PKGS)
  set(_package_providers
    -DgRPC_ABSL_PROVIDER=package
    -DgRPC_CARES_PROVIDER=package
    -DgRPC_PROTOBUF_PROVIDER=package
    -DgRPC_ZLIB_PROVIDER=package
  )
  set(_depends_clause
    DEPENDS
      abseil-cpp
      cares
      protobuf
      zlib
  )
endif()

GetDownloadClause(_download_clause ${GRPC_GIT_URL} ${GRPC_GIT_TAG})

#-----------------------------------------------------------------------
# Build gRPC
#-----------------------------------------------------------------------
ExternalProject_Add(grpc
  ${_download_clause}
  ${_patch_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/grpc
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    ${_grpc_cxx_standard}
    -DBUILD_SHARED_LIBS=on
    ${_package_providers}
    # gRPC normally builds BoringSSL, which is incompatible with libpython.
    # We use whatever version of OpenSSL is installed instead.
    -DgRPC_SSL_PROVIDER=package
    -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=off
    -DgRPC_BUILD_GRPC_NODE_PLUGIN=off
    -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=off
    -DgRPC_BUILD_GRPC_PHP_PLUGIN=off
    -DgRPC_BUILD_GRPC_RUBY_PLUGIN=off
    -DgRPC_BUILD_TESTS=off
    -DgRPC_INSTALL=on
    ${_build_codegen_option}
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  ${_depends_clause}
)

if(ON_DEMAND)
  set_target_properties(grpc PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
