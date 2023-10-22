# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Creates a cmake include file (source/presets.cmake) that disables the
# DOWNLOAD and PATCH options by default. Used when generating a distribution
# that includes the downloaded source files.
#

if [ ! -e source/ ]; then
  echo "No 'source' directory to update"
  exit 1
fi

cat >> source/presets.cmake << EOF
set(DOWNLOAD FALSE CACHE BOOL "presets: Download repositories")
set(PATCH FALSE CACHE BOOL "presets: Patch source after downloading")
EOF

