# Downloads and builds json
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadClause(_download_clause ${JSON_GIT_URL} ${JSON_GIT_TAG})

ExternalProject_Add(json
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/json
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DJSON_BuildTests=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(json PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
