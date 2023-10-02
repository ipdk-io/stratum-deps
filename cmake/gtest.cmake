# Downloads and builds gtest
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadSpec(DOWNLOAD_GTEST ${GTEST_GIT_URL} ${GTEST_GIT_TAG})

ExternalProject_Add(gtest
  ${DOWNLOAD_GTEST}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/gtest
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_RPATH=${ORIGIN_TOKEN}
    -DBUILD_SHARED_LIBS=on
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(gtest PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
