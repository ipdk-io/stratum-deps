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

if(LATEST_GRPC)
  set(ABSEIL_GIT_TAG    c2435f8342c2d0ed8101cb43adfd605fdc52dca2) # 20230125.3
  set(CARES_GIT_TAG     6360e96b5cf8e5980c887ce58ef727e53d77243a) # v1.19.1
  set(GRPC_GIT_TAG      6e85620c7e258df79666a4743f862f2f82701c2d) # v1.56.0
  set(GRPC_VERSION      1.56.0)
  set(PROTOBUF_GIT_TAG  2dca62f7296e5b49d729f7384f975cecb38382a0) # v23.1
  set(ZLIB_GIT_TAG      04f42ceca40f73e2978b50e93806c2a18c1281fc) # v1.2.13
else()
  set(ABSEIL_GIT_TAG    273292d1cfc0a94a65082ee350509af1d113344d) # 20220623.0
  set(CARES_GIT_TAG     6360e96b5cf8e5980c887ce58ef727e53d77243a) # v1.19.1
  if(NOT DEFINED GRPC_GIT_TAG)
    set(GRPC_GIT_TAG    8871dab19b4ab5389e28474d25cfeea61283265c) # v1.54.2
    set(GRPC_VERSION    1.54.2)
  endif()
  set(PROTOBUF_GIT_TAG  fe271ab76f2ad2b2b28c10443865d2af21e27e0e) # v3.20.3
  set(ZLIB_GIT_TAG      04f42ceca40f73e2978b50e93806c2a18c1281fc) # v1.2.13
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
