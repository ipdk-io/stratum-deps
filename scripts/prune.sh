#!/bin/bash
#
# Copyright 2023-2024 Intel Corporation
# SPDX-License-Identifier: Apache 2.0
#
# Removes unnecessary third-party packages.
#

SOURCE_DIR=source

rm -fr ${SOURCE_DIR}/grpc/third_party/abseil-cpp
rm -fr ${SOURCE_DIR}/grpc/third_party/benchmark
rm -fr ${SOURCE_DIR}/grpc/third_party/bloaty
rm -fr ${SOURCE_DIR}/grpc/third_party/boringssl-with-bazel
rm -fr ${SOURCE_DIR}/grpc/third_party/cares
rm -fr ${SOURCE_DIR}/grpc/third_party/libuv
rm -fr ${SOURCE_DIR}/grpc/third_party/protobuf
rm -fr ${SOURCE_DIR}/grpc/third_party/re2
rm -fr ${SOURCE_DIR}/grpc/third_party/zlib
rm -fr ${SOURCE_DIR}/protobuf/third_party/abseil-cpp
rm -fr ${SOURCE_DIR}/protobuf/third_party/benchmark
rm -fr ${SOURCE_DIR}/protobuf/third_party/zlib
