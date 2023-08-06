# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

cmake -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=hostdeps \
  -DLATEST_GRPC=YES
