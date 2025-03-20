# Downloads and builds dependencies
#
# Copyright 2022-2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

# CMake version 3.16 is the baseline for P4 Control Plane.
cmake_minimum_required(VERSION 3.16)

project(stratum-deps VERSION 1.4.0 LANGUAGES C CXX)

include(ExternalProject)
include(CMakePrintHelpers)
include(GNUInstallDirs)

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL 3.24 AND
    ${CMAKE_VERSION} VERSION_LESS 3.26)
  message(STATUS "CMake version is ${CMAKE_VERSION}")
  message(STATUS "Protobuf build is broken in CMake 3.24 and 3.25")
  message(STATUS "Versions 3.16...3.22 and 3.26+ are recommended")
  message(FATAL_ERROR "Invalid CMake version")
endif()

cmake_print_variables(CMAKE_PROJECT_VERSION)

# Include preconfig if file exists.
if(EXISTS source/preconfig.cmake)
  include(source/preconfig.cmake)
endif()

#-----------------------------------------------------------------------
# Options
#-----------------------------------------------------------------------

option(DOWNLOAD     "Download repositories" TRUE)
option(FORCE_PATCH  "Specify -f when patching (deprecated)" FALSE)
option(GIT_PROGRESS "Show Git progress" TRUE)
option(ON_DEMAND    "Build targets on demand" FALSE)
option(OVERRIDE_PKGS "Use own versions of subpackages" TRUE)
option(PATCH        "Patch source after downloading" TRUE)
option(USE_LDCONFIG "Use ldconfig when installing" FALSE)
option(BUILD_PYTHON_BINDINGS "Build Python bindings" ON)

# Note: USE_SUDO should be DISABLED by default.
# This is in keeping with the following security principles:
# - Principle of Least Privilege
# - Secure By Default
option(USE_SUDO     "Use sudo when installing" FALSE)

if(USE_SUDO)
  set(SUDO_CMD "sudo" "-E")
  if(USE_LDCONFIG)
    set(LDCONFIG_CMD COMMAND sudo ldconfig)
  endif()
endif()

if(FORCE_PATCH)
  set(FORCE_OPTION "-f")
endif()

if(NOT DOWNLOAD)
  message(STATUS "Source will not be downloaded")
endif()

if(NOT PATCH)
  message(STATUS "Source will not be patched")
endif()

#-----------------------------------------------------------------------
# Search paths
#-----------------------------------------------------------------------

if(CMAKE_CROSSCOMPILING)
  list(APPEND CMAKE_FIND_ROOT_PATH ${CMAKE_INSTALL_PREFIX})
  if(NOT HOST_DEPEND_DIR STREQUAL "")
    list(APPEND CMAKE_PREFIX_PATH ${HOST_DEPEND_DIR})
  endif()
else()
  list(APPEND CMAKE_PREFIX_PATH ${CMAKE_INSTALL_PREFIX})
endif()

# Set CMAKE_MODULE_PATH to include the directory
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

#-----------------------------------------------------------------------
# CMAKE_BUILD_TYPE
#-----------------------------------------------------------------------

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the build type." FORCE)
endif()

set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug;Release;RelWithDebInfo")

#-----------------------------------------------------------------------
# Variables that affect all subbuilds
#-----------------------------------------------------------------------

if(NOT CMAKE_BUILD_TYPE STREQUAL "")
  set(deps_BUILD_TYPE "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
endif()

if(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE STREQUAL "")
  set(deps_TOOLCHAIN_FILE "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
endif()

cmake_print_variables(CMAKE_BUILD_TYPE)
cmake_print_variables(CMAKE_TOOLCHAIN_FILE)
cmake_print_variables(CMAKE_INSTALL_PREFIX)
cmake_print_variables(CMAKE_PREFIX_PATH)
cmake_print_variables(CMAKE_FIND_ROOT_PATH)

#-----------------------------------------------------------------------
# Set CURRENT_CXX_STANDARD to:
#
# 1) The value of the CXX_STANDARD script option, if set.
# 2) The value of the CMAKE_CXX_STANDARD variable, if set.
# 3) The default standard used by the C++ compiler, if this is a
#    host build.
#
# We will pass the value to the Abseil and gRPC subbuilds.
#
# This is a fix for a Fedora 37 build issue.
#-----------------------------------------------------------------------

if(CXX_STANDARD)
  set(CURRENT_CXX_STANDARD ${CXX_STANDARD})
elseif(CMAKE_CXX_STANDARD)
  set(CURRENT_CXX_STANDARD ${CMAKE_CXX_STANDARD})
elseif(NOT CMAKE_CROSSCOMPILING)
  include(cmake/cxx_standard.cmake)
  get_cplusplus_standard(CURRENT_CXX_STANDARD)
endif()

#-----------------------------------------------------------------------
# GetDownloadClause
#
# Generates the ExternalProject_Add() parameters needed to download
# a git repository and returns them in the VAR parameter. Returns an
# empty string if the DOWNLOAD option is false.
#-----------------------------------------------------------------------

function(GetDownloadClause VAR _url _tag)
  if(DOWNLOAD)
    set(_clause
      GIT_REPOSITORY  ${_url}
      GIT_TAG         ${_tag}
    )
    if(GIT_PROGRESS)
      list(APPEND _clause GIT_PROGRESS ON)
    endif()
  else()
    set(_clause "")
  endif()
  set(${VAR} ${_clause} PARENT_SCOPE)
endfunction(GetDownloadClause)

#-----------------------------------------------------------------------
# Dependencies
#-----------------------------------------------------------------------

# Define git repository tags and urls.
include(cmake/deps.cmake)

set(DEPS_SOURCE_DIR ${CMAKE_SOURCE_DIR}/source)

if(OVERRIDE_PKGS)
  include(cmake/abseil-cpp.cmake)
  include(cmake/zlib.cmake)
  include(cmake/c-ares.cmake)
  include(cmake/protobuf.cmake)
  include(cmake/re2.cmake)
endif()

include(cmake/grpc.cmake)
include(cmake/cctz.cmake)
include(cmake/gflags.cmake)
include(cmake/glog.cmake)
include(cmake/gtest.cmake)
include(cmake/json.cmake)

#-----------------------------------------------------------------------
# Find required packages
#-----------------------------------------------------------------------
find_package(Threads REQUIRED)
find_package(OpenSSL REQUIRED)

# Print configuration summary
include(FeatureSummary)
feature_summary(WHAT ALL)

#-----------------------------------------------------------------------
# Python bindings
#-----------------------------------------------------------------------

# Choose ONE approach: either ExternalProject_Add or add_subdirectory
if(BUILD_PYTHON_BINDINGS)
    # Use ExternalProject_Add approach
    include(cmake/python-bindings.cmake)
    
    # OR use add_subdirectory approach (not both)
    # add_subdirectory(python)
endif()
