# Downloads and builds abseil-cpp
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

# Recommended for CMake 3.8 and up
# TODO(dfoster): who acts on this?
set(ABSL_CXX_PROPAGATE_CXX_STD ON)

GetDownloadSpec(DOWNLOAD_ABSL ${ABSEIL_GIT_URL} ${ABSEIL_GIT_TAG})

ExternalProject_Add(abseil-cpp
  ${DOWNLOAD_ABSL}

  SOURCE_DIR
    ${CMAKE_SOURCE_DIR}/abseil-cpp
  CMAKE_ARGS
    ${cmake_BUILD_TYPE}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    ${stratum_ABSL_CXX_STANDARD}
    ${stratum_CMAKE_CXX_STANDARD}
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DBUILD_SHARED_LIBS=on
    -DBUILD_TESTING=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(abseil-cpp PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
