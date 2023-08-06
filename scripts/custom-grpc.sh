# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
# This script configures CMake to build the Stratum dependencies
# using the selected version of gRPC, instead of the version
# specified in deps.cmake.
#
# It also configures CMake to use the versions of abseil, c-ares,
# protobuf, and zlib that are bundled with the selected version of
# gRPC, instead of the versions specified in deps.cmake.

cmake -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=hostdeps \
  -DOVERRIDE_GRPC=NO \
  -DGRPC_GIT_TAG=12161ee3aa7c216741cd7c406573abc0df1d0926 # v1.55.1
