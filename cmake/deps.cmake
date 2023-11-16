# URL and TAG definitions for dependencies
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

set(ABSEIL_GIT_URL      https://github.com/abseil/abseil-cpp.git)
set(CARES_GIT_URL       https://github.com/c-ares/c-ares.git)
set(GRPC_GIT_URL        https://github.com/google/grpc.git)
set(PROTOBUF_GIT_URL    https://github.com/google/protobuf.git)
set(ZLIB_GIT_URL        https://github.com/madler/zlib)

if(RECENT_PKGS)
  set(ABSEIL_GIT_TAG    29bf8085f3bf17b84d30e34b3d7ff8248fda404e) # 20230802.0
  set(CARES_GIT_TAG     6360e96b5cf8e5980c887ce58ef727e53d77243a) # v1.19.1
  set(GRPC_GIT_TAG      0df9accc5c3478d126742fb84dd7155786dc4f68) # v1.59.1
  set(GRPC_VERSION      1.59.1)
  set(PROTOBUF_GIT_TAG  b2b7a51158418f41cff0520894836c15b1738721) # v24.3
  set(ZLIB_GIT_TAG      04f42ceca40f73e2978b50e93806c2a18c1281fc) # v1.2.13
else()
  set(ABSEIL_GIT_TAG    29bf8085f3bf17b84d30e34b3d7ff8248fda404e) # 20230802.0
  set(CARES_GIT_TAG     6360e96b5cf8e5980c887ce58ef727e53d77243a) # v1.19.1
  if(NOT DEFINED GRPC_GIT_TAG)
    set(GRPC_GIT_TAG    883e5f76976b86afee87415dc67bde58d9b295a4) # v1.59.2
    set(GRPC_VERSION    1.59.2)
  endif()
  set(PROTOBUF_GIT_TAG  6b5d8db01fe47478e8d400f550e797e6230d464e) # v25.0
  set(ZLIB_GIT_TAG      09155eaa2f9270dc4ed1fa13e2b4b2613e6e4851) # v1.3
endif()

set(CCTZ_GIT_URL https://github.com/google/cctz.git)
set(CCTZ_GIT_TAG 02918d62329ef440935862719829d061a5f4beba) # master~25

set(GFLAGS_GIT_URL https://github.com/gflags/gflags.git)
set(GFLAGS_GIT_TAG 827c769e5fc98e0f2a34c47cef953cc6328abced) # master~5

set(GLOG_GIT_URL https://github.com/google/glog.git)
set(GLOG_GIT_TAG a8e0007e96ff96145022c488e367da10f835c75d) # v0.6.0-rc1

set(GTEST_GIT_URL https://github.com/google/googletest.git)
set(GTEST_GIT_TAG e2239ee6043f73722e7aa812a459f54a28552929) # v1.11.0

set(JSON_GIT_URL https://github.com/nlohmann/json.git)
set(JSON_GIT_TAG 760304635dc74a5bf77903ad92446a6febb85acf) # tags/v3.10.5^2~8
