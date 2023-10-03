# Downloads and builds gRPC
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

unset(_build_codegen_option)
unset(_depends_clause)
unset(_download_clause)
unset(_grpc_cxx_standard)
unset(_package_providers)
unset(_patch_clause)

if(PATCH)
  if(NOT DEFINED GRPC_VERSION OR GRPC_VERSION STREQUAL "")
    message(FATAL_ERROR "GRPC_VERSION undefined; cannot select patch file")
  endif()
  cmake_print_variables(GRPC_VERSION)
  set(_patchfile grpc-v${GRPC_VERSION}.patch.in)
  if(NOT EXISTS cmake/patches/${_patchfile})
    message(FATAL_ERROR "Patch file for gRPC version ${GRPC_VERSION} not found")
  endif()

  # Patch the gRPC build script to set the RUNPATH of the installed
  # Protobuf compiler plugins to the relative paths of the library
  # directories.
  set(GRPC_INSTALL_RPATH $ORIGIN/../lib64:$ORIGIN/../lib)
  configure_file(
    cmake/patches/${_patchfile}
    ${CMAKE_CURRENT_BINARY_DIR}/grpc.patch @ONLY
  )

  set(_patch_clause
    PATCH_COMMAND
      patch -i ${CMAKE_CURRENT_BINARY_DIR}/grpc.patch -p1 ${FORCE_OPTION}
  )
endif()

if(CMAKE_CROSSCOMPILING)
  # If we're cross-compiling for the target system, don't build the
  # gRPC code generation executables.
  set(_build_codegen_option -DgRPC_BUILD_CODEGEN=off)
endif()

if(DEFINED CURRENT_CXX_STANDARD AND NOT CURRENT_CXX_STANDARD STREQUAL "")
  set(_grpc_cxx_standard -DCMAKE_CXX_STANDARD=${CURRENT_CXX_STANDARD})
endif()

GetDownloadSpec(_download_clause ${GRPC_GIT_URL} ${GRPC_GIT_TAG})

if(OVERRIDE_PKGS)
  set(_package_providers
    -DgRPC_ABSL_PROVIDER=package
    -DgRPC_CARES_PROVIDER=package
    -DgRPC_PROTOBUF_PROVIDER=package
    -DgRPC_ZLIB_PROVIDER=package
  )
  set(_depends_clause
    DEPENDS
      abseil-cpp
      cares
      protobuf
      zlib
  )
endif()

ExternalProject_Add(grpc
  ${_download_clause}
  ${_patch_clause}

  SOURCE_DIR
    ${DEPS_SOURCE_DIR}/grpc
  CMAKE_ARGS
    ${deps_BUILD_TYPE}
    ${deps_TOOLCHAIN_FILE}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_INSTALL_RPATH=$ORIGIN
    -DCMAKE_POSITION_INDEPENDENT_CODE=on
    -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_FIND_ROOT_PATH=${CMAKE_FIND_ROOT_PATH}
    ${_grpc_cxx_standard}
    -DBUILD_SHARED_LIBS=on
    ${_package_providers}
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
    ${_build_codegen_option}
  INSTALL_COMMAND
    ${SUDO_CMD} ${CMAKE_MAKE_PROGRAM} install
    ${LDCONFIG_CMD}
  ${_depends_clause}
)

if(ON_DEMAND)
  set_target_properties(grpc PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()
