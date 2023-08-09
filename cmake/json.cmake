# Downloads and builds json
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadSpec(DOWNLOAD_JSON ${JSON_GIT_URL} ${JSON_GIT_TAG})

ExternalProject_Add(json
  ${DOWNLOAD_JSON}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/json
  CMAKE_ARGS
    ${cmake_BUILD_TYPE}
    ${cmake_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DJSON_BuildTests=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(json PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
