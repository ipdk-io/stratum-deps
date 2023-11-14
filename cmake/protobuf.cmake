# Downloads and builds protobuf
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

unset(_absl_provider)
unset(_build_shared_libs)
unset(_source_subdir)

# In older versions of protobuf, the primary CMakeLists.txt file
# is in the cmake subdirectory.
# Enabled by: { "SOURCE_SUBDIR": "cmake" }
if(DEFINED PROTOBUF_SOURCE_SUBDIR)
  set(_source_subdir SOURCE_SUBDIR ${PROTOBUF_SOURCE_SUBDIR})
endif()

# Protobuf v23.x generates unresolved external references to
# ThreadSafeArena::ThreadCache _thread_cache if BUILD_SHARED_LIBS=ON.
# Enabled by: { "BUILD_SHARED_LIBS": "OFF" }
if(DEFINED PROTOBUF_BUILD_SHARED_LIBS)
  set(_build_shared_libs ${PROTOBUF_BUILD_SHARED_LIBS})
else()
  set(_build_shared_libs ON)
endif()

# Protobuf v23.x bundles its own copy of Abseil.
# We suppress it in favor of our own version or the version bundled with gRPC.
# Enabled by: { "ABSL_PROVIDER": "package" }
if(DEFINED PROTOBUF_ABSL_PROVIDER)
  set(_absl_provider -Dprotobuf_ABSL_PROVIDER=${PROTOBUF_ABSL_PROVIDER})
endif()

GetDownloadClause(_download_clause ${PROTOBUF_GIT_URL} ${PROTOBUF_GIT_TAG})

ExternalProject_Add(protobuf
  ${_download_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/protobuf
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    -DBUILD_SHARED_LIBS=${_build_shared_libs}
    ${_absl_provider}
    -Dprotobuf_BUILD_TESTS=off
  ${_source_subdir}
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  DEPENDS
    abseil-cpp
    zlib
)

if(ON_DEMAND)
  set_target_properties(protobuf PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
