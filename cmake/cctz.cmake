# Downloads and builds cctz
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadSpec(DOWNLOAD_CCTZ ${CCTZ_GIT_URL} ${CCTZ_GIT_TAG})

ExternalProject_Add(cctz
  ${DOWNLOAD_CCTZ}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/cctz
  CMAKE_ARGS
    ${cmake_BUILD_TYPE}
    ${cmake_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DBUILD_TESTING=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(cctz PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
