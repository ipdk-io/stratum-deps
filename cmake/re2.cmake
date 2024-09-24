# Downloads and builds re2
#
# Copyright 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadClause(_download_clause ${RE2_GIT_URL} ${RE2_GIT_TAG})

ExternalProject_Add(re2
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/re2
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DBUILD_SHARED_LIBS=ON
    -DRE2_BUILD_TESTING=OFF
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(re2 PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
