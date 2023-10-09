# Downloads and builds abseil-cpp
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

unset(_abseil_cxx_standard)

if(DEFINED CURRENT_CXX_STANDARD AND NOT CURRENT_CXX_STANDARD STREQUAL "")
  set(_abseil_cxx_standard
      -DABSL_CXX_STANDARD=${CURRENT_CXX_STANDARD}
      -DCMAKE_CXX_STANDARD=${CURRENT_CXX_STANDARD}
  )
endif()

GetDownloadClause(_download_clause ${ABSEIL_GIT_URL} ${ABSEIL_GIT_TAG})

ExternalProject_Add(abseil-cpp
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/abseil-cpp
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    ${_abseil_cxx_standard}
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DABSL_PROPAGATE_CXX_STD=on
    -DBUILD_SHARED_LIBS=on
    -DBUILD_TESTING=off
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
)

if(ON_DEMAND)
  set_target_properties(abseil-cpp PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
