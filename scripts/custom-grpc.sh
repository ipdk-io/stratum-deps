# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

cmake -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=custom-deps \
  -DOVERRIDE_PKGS=no \
  -DGRPC_GIT_TAG=6e85620c7e258df79666a4743f862f2f82701c2d \
  -DGRPC_VERSION=1.56.0
