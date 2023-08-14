#!/bin/bash
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache 2.0
#
# Sample script to configure and build the dependency libraries
# on the development host when cross-compiling for the ES2K ACC.
#

# Sample script to configure and build the subset of the dependency
# libraries needed to compile the Protobuf files on the development
# host when cross-compiling for the ES2K ACC platform.

# The Protobuf compiler and grpc plugins run natively on the development
# host. They generate C++ source and header files that can be compiled
# to run natively on the host or cross-compiled to run on the target
# platform.

# Abort on error.
set -e

if [ -n "${SDKTARGETSYSROOT}" ]; then
    echo ""
    echo "-----------------------------------------------------"
    echo "Error: SDKTARGETSYSROOT is defined!"
    echo "The host dependencies must be built WITHOUT sourcing"
    echo "the cross-compile environment variables."
    echo "-----------------------------------------------------"
    echo ""
    exit 1
fi

##################
# Default values #
##################

_BLD_DIR=build
_CFG_ONLY=0
_DRY_RUN=
_PREFIX=hostdeps
_NJOBS=8
_SCOPE=minimal

##############
# print_help #
##############

print_help() {
    echo ""
    echo "Build host dependency libraries"
    echo ""
    echo "Paths:"
    echo "  --build=DIR     -B  Build directory path [${_BLD_DIR}]"
    echo "  --prefix=DIR    -P  Install directory prefix [${_PREFIX}]"
    echo ""
    echo "Options:"
    echo "  --config            Only perform configuration step"
    echo "  --cxx=VERSION       CXX_STANDARD to specify [${_CXX_STD}]"
    echo "  --dry-run       -n  Display cmake parameters and exit"
    echo "  --force         -f  Specify -f when patching"
    echo "  --full              Build all dependency libraries [${_SCOPE}]"
    echo "  --jobs=NJOBS    -j  Number of build threads [${_NJOBS}]"
    echo "  --minimal           Build required dependencies only [${_SCOPE}]"
    echo "  --no-download       Do not download repositories"
    echo "  --no-patch          Do not patch source after downloading"
    echo "  --sudo              Use sudo when installing"
    echo ""
}

######################
# print_cmake_params #
######################

print_cmake_params() {
    echo ""
    [ -n "${_GENERATOR}" ] && echo "${_GENERATOR}"
    echo "CMAKE_INSTALL_PREFIX=${_PREFIX}"
    [ -n "${_CXX_STD}" ] && echo "CXX_STANDARD=${_CXX_STD}"
    [ -n "${_ON_DEMAND}" ] && echo "${_ON_DEMAND:2}"
    [ -n "${_DOWNLOAD}" ] && echo "${_DOWNLOAD:2}"
    [ -n "${_PATCH}" ] && echo "${_PATCH:2}"
    [ -n "${_FORCE_PATCH}" ] && echo "${_FORCE_PATCH:2}"
    [ -n "${_USE_SUDO}" ] && echo "${_USE_SUDO:2}"
    if [ ${_CFG_ONLY} -ne 0 ]; then
        echo ""
        echo "Configure only (${_SCOPE} build)"
        return
    fi
    echo "-j${_NJOBS}"
    [ -n "${_TARGET}" ] && echo "${_TARGET}"
    echo ""
    echo "Will perform a ${_SCOPE} build"
}

######################
# Parse command line #
######################

SHORTOPTS=B:P:j:
SHORTOPTS=${SHORTOPTS}fhn

LONGOPTS=build:,cxx:,jobs:,prefix:
LONGOPTS=${LONGOPTS},config,dry-run,force,full,help,minimal,ninja
LONGOPTS=${LONGOPTS},no-download,no-patch,sudo

GETOPTS=$(getopt -o ${SHORTOPTS} --long ${LONGOPTS} -- "$@")
eval set -- "${GETOPTS}"

while true ; do
    case "$1" in
    # Paths
    -B|--build)
        _BLD_DIR=$2
        shift 2 ;;
    -P|--prefix)
        _PREFIX=$2
        shift 2 ;;
    # Options
    --config)
        _CFG_ONLY=1
        shift ;;
    --cxx)
        _CXX_STD=$2
         shift 2 ;;
    -n|--dry-run)
        _DRY_RUN=1
        shift ;;
    -f|--force)
        _FORCE_PATCH="-DFORCE_PATCH=TRUE"
        shift ;;
    --full)
        _SCOPE=full
        shift ;;
    -h|--help)
        print_help
        exit 99 ;;
    -j|--jobs)
        _JOBS=-j$2
        shift 2 ;;
    --minimal)
        _SCOPE=minimal
        shift ;;
    --ninja)
        _GENERATOR="-G Ninja"
        shift ;;
    --no-download)
        _DOWNLOAD="-DDOWNLOAD=FALSE"
        shift ;;
    --no-patch)
        _PATCH="-DPATCH=FALSE"
        shift ;;
    --sudo)
        _USE_SUDO="-DUSE_SUDO=TRUE"
        shift ;;
    --)
        shift
        break ;;
    *)
        echo "Invalid parameter: $1"
        exit 1 ;;
    esac
done

######################
# Process parameters #
######################

if [ "${_SCOPE}" = minimal ]; then
    _ON_DEMAND="-DON_DEMAND=TRUE"
    _TARGET="--target grpc"
fi

[ -n "${_CXX_STD}" ] && _CXX_STANDARD="${_CXX_STD}"

# Show parameters if this is a dry run
if [ ${_DRY_RUN} -ne 0 ]; then
    print_cmake_params
    echo ""
    exit 0
fi

######################
# Build dependencies #
######################

rm -fr "${_BLD_DIR}" "${_PREFIX}"

# shellcheck disable=SC2086
cmake -S . -B ${_BLD_DIR} \
    ${_GENERATOR} \
    -DCMAKE_INSTALL_PREFIX="${_PREFIX}" \
    ${_CXX_STANDARD} \
    ${_ON_DEMAND} \
    ${_DOWNLOAD} \
    ${_PATCH} \
    ${_FORCE_PATCH} \
    ${_USE_SUDO}

if [ ${_CFG_ONLY} -ne 0 ]; then
    # shellcheck disable=SC2086
    cmake --build "${_BLD_DIR}" -j${_NJOBS} ${_TARGET}
fi
