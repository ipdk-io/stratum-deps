# Downloads and builds c-ares
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadClause(_download_clause ${CARES_GIT_URL} ${CARES_GIT_TAG})

ExternalProject_Add(cares
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/c-ares
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(cares PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
