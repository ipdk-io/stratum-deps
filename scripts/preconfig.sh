# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Creates a cmake include file (source/preconfig.cmake) that disables the
# DOWNLOAD and PATCH options by default. Used when generating a distribution
# that includes the downloaded source files.
#

# Abort on error
set -e

##################
# Default values #
##################

_DOWNLOAD=FALSE
_PATCH=FALSE

######################
# Parse command line #
######################

SHORTOPTS=P:
LONGOPTS=download,no-download,patch,no-patch

GETOPTS=$(getopt -o ${SHORTOPTS} --long ${LONGOPTS} -- "$@")
eval set -- "${GETOPTS}"

while true ; do
  case "$1" in
  --download)
    _DOWNLOAD=TRUE
    shift ;;
  --no-download)
    _DOWNLOAD=FALSE
    shift ;;
  --patch)
    _PATCH=TRUE
    shift ;;
  --no-patch)
    _PATCH=FALSE
    shift ;;
  --)
    shift
    break ;;
  *)
    echo "Invalid parameter: $1"
    exit 1 ;;
  esac
done

#########################
# Create preconfig file #
#########################

if [ ! -e source/ ]; then
  echo "No 'source' directory to update!"
  exit 1
fi

if [ -e source/preconfig.cmake ]; then
  echo "Removing existing preconfig.cmake file"
  rm source/preconfig.cmake
fi

cat >> source/preconfig.cmake << EOF
# Override default values
set(DOWNLOAD ${_DOWNLOAD} CACHE BOOL "preconfig: Download repositories")
set(PATCH ${_PATCH} CACHE BOOL "preconfig: Patch source after downloading")
EOF
