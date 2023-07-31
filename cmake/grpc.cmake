# Downloads and builds gRPC
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

# Patch the gRPC build script to set the RUNPATH of the installed
# Protobuf compiler plugins to the relative paths of the library
# directories.
set(GRPC_INSTALL_RPATH $ORIGIN/../lib64:$ORIGIN/../lib)
configure_file(cmake/grpc.patch.in ${CMAKE_SOURCE_DIR}/grpc.patch @ONLY)

set(PATCH_GRPC
  PATCH_COMMAND
    patch -i ${CMAKE_SOURCE_DIR}/grpc.patch -p1 ${FORCE_OPTION}
)

if(CMAKE_CROSSCOMPILING)
  # If we're cross-compiling for the target system, don't build the
  # gRPC code generation executables.
  set(gRPC_BUILD_CODEGEN_OPTION -DgRPC_BUILD_CODEGEN=off)
endif()

GetDownloadSpec(DOWNLOAD_GRPC ${GRPC_GIT_URL} ${GRPC_GIT_TAG})

if(OWN_PACKAGES)
  set(own_packages
    -DgRPC_ABSL_PROVIDER=package
    -DgRPC_CARES_PROVIDER=package
    -DgRPC_PROTOBUF_PROVIDER=package
    -DgRPC_ZLIB_PROVIDER=package
  )
  set(own_dependencies
    DEPENDS
      abseil-cpp
      cares
      protobuf
      zlib
  )
endif()

ExternalProject_Add(grpc
  ${DOWNLOAD_GRPC}
  ${PATCH_GRPC}

  SOURCE_DIR
    ${CMAKE_SOURCE_DIR}/grpc
  CMAKE_ARGS
    ${cmake_BUILD_TYPE}
    -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    ${stratum_CMAKE_CXX_STANDARD}
    -DBUILD_SHARED_LIBS=on
    ${own_packages}
    # gRPC builds BoringSSL, which is incompatible with libpython.
    # We use whatever version of OpenSSL is installed instead.
    -DgRPC_SSL_PROVIDER=package
    -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=off
    -DgRPC_BUILD_GRPC_NODE_PLUGIN=off
    -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=off
    -DgRPC_BUILD_GRPC_PHP_PLUGIN=off
    -DgRPC_BUILD_GRPC_RUBY_PLUGIN=off
    -DgRPC_BUILD_TESTS=off
    -DgRPC_INSTALL=on
    ${gRPC_BUILD_CODEGEN_OPTION}
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  ${own_dependencies}
)

if(ON_DEMAND)
  set_target_properties(grpc PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
