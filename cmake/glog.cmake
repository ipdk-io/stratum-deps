# Downloads and builds glog
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadClause(_download_clause ${GLOG_GIT_URL} ${GLOG_GIT_TAG})

ExternalProject_Add(glog
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/glog
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DWITH_GTEST=OFF
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  DEPENDS
    gflags
)

if(ON_DEMAND)
  set_target_properties(glog PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
