# Downloads and builds gflags
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadSpec(DOWNLOAD_GFLAGS ${GFLAGS_GIT_URL} ${GFLAGS_GIT_TAG})

ExternalProject_Add(gflags
  ${DOWNLOAD_GFLAGS}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/gflags
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DBUILD_SHARED_LIBS=on
    -DBUILD_TESTING=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(gflags PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
