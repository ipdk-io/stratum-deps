# Downloads and builds protobuf
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

GetDownloadSpec(DOWNLOAD_PROTOBUF ${PROTOBUF_GIT_URL} ${PROTOBUF_GIT_TAG})

if(EXISTS ${CMAKE_SOURCE_DIR}/protobuf)
  set(_source_dir ${CMAKE_SOURCE_DIR}/protobuf)
else()
  set(_source_dir ${CMAKE_SOURCE_DIR})
endif()

ExternalProject_Add(protobuf
  ${DOWNLOAD_PROTOBUF}

  SOURCE_DIR
    ${_source_dir}
  CMAKE_ARGS
    ${cmake_BUILD_TYPE}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DBUILD_SHARED_LIBS=on
    -Dprotobuf_BUILD_TESTS=off
  SOURCE_SUBDIR
    cmake
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  DEPENDS
    zlib
)

if(ON_DEMAND)
  set_target_properties(protobuf PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
