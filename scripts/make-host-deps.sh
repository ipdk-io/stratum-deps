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

#################
# Check sysroot #
#################

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
_DO_BUILD=1
_DRY_RUN=0
_NJOBS=8
_PREFIX=hostdeps
_SCOPE=full

##############
# print_help #
##############

print_help() {
    echo ""
    echo "Build host dependency libraries"
    echo ""
    echo "General:"
    echo "  --dry-run        -n  Display cmake parameters and exit"
    echo "  --help           -h  Display help text and exit"
    echo ""
    echo "Paths:"
    echo "  --build=DIR      -B  Build directory path [${_BLD_DIR}]"
    echo "  --prefix=DIR     -P  Install directory prefix [${_PREFIX}]"
    echo ""
    echo "Options:"
    echo "  --cxx=STD            C++ standard to be used [${_CXX_STD}]"
    echo "  --force          -f  Specify -f when patching (deprecated)"
    echo "  --full               Build all dependency libraries [${_SCOPE}]"
    echo "  --jobs=NJOBS     -j  Number of build threads [${_NJOBS}]"
    echo "  --minimal            Build only required dependencies [${_SCOPE}]"
    echo "  --no-build           Configure without building"
    echo "  --no-download        Do not download repositories"
    echo "  --no-patch           Do not patch source after downloading"
    echo "  --sudo               Use sudo when installing"
    echo ""
    echo "Configurations:"
    echo "  --debug              Debug configuration"
    echo "  --reldeb             RelWithDebInfo configuration"
    echo "  --release            Release configuration"
    echo ""
}

######################
# print_cmake_params #
######################

print_cmake_params() {
    echo ""
    [ -n "${_GENERATOR}" ] && echo "${_GENERATOR}"
    [ -n "${_BUILD_TYPE}" ] && echo "${_BUILD_TYPE:2}"
    echo "CMAKE_INSTALL_PREFIX=${_PREFIX}"
    [ -n "${_CXX_STD}" ] && echo "CXX_STANDARD=${_CXX_STD}"
    [ -n "${_ON_DEMAND}" ] && echo "${_ON_DEMAND:2}"
    [ -n "${_DOWNLOAD}" ] && echo "${_DOWNLOAD:2}"
    [ -n "${_PATCH}" ] && echo "${_PATCH:2}"
    [ -n "${_FORCE_PATCH}" ] && echo "${_FORCE_PATCH:2}"
    [ -n "${_USE_SUDO}" ] && echo "${_USE_SUDO:2}"
    echo "-B ${_BLD_DIR}"
    if [ ${_DO_BUILD} -eq 0 ]; then
        echo ""
        echo "Configure without building (${_SCOPE} build)"
        return
    fi
    echo "-j${_NJOBS}"
    [ -n "${_TARGET}" ] && echo "${_TARGET}"
    echo ""
    echo "Will perform a ${_SCOPE} build"
}

################
# config_build #
################

config_build() {
    # shellcheck disable=SC2086
    cmake -S . -B "${_BLD_DIR}" \
        ${_GENERATOR} \
        ${_BUILD_TYPE} \
        -DCMAKE_INSTALL_PREFIX="${_PREFIX}" \
        ${_CXX_STANDARD} \
        ${_ON_DEMAND} \
        ${_DOWNLOAD} \
        ${_PATCH} \
        ${_FORCE_PATCH} \
        ${_USE_SUDO}
}
######################
# Parse command line #
######################

SHORTOPTS=B:P:j:
SHORTOPTS=${SHORTOPTS}fhn

LONGOPTS=build:,cxx-std:,jobs:,prefix:
LONGOPTS=${LONGOPTS},debug,release,reldeb
LONGOPTS=${LONGOPTS},dry-run,force,full,help,minimal,ninja
LONGOPTS=${LONGOPTS},no-build,no-download,no-patch,sudo

GETOPTS=$(getopt -o ${SHORTOPTS} --long ${LONGOPTS} -- "$@")
eval set -- "${GETOPTS}"

while true ; do
    case "$1" in
    # Paths
    --build|-B)
        _BLD_DIR=$2
        shift 2 ;;
    --prefix|-P)
        _PREFIX=$2
        shift 2 ;;
    # Configurations
    --debug)
        _BUILD_TYPE="-DCMAKE_BUILD_TYPE=Debug"
        shift ;;
    --reldeb)
        _BUILD_TYPE="-DCMAKE_BUILD_TYPE=RelWithDebInfo"
        shift ;;
    --release)
        _BUILD_TYPE="-DCMAKE_BUILD_TYPE=Release"
        shift ;;
    # Options
    --cxx-std)
        _CXX_STD=$2
         shift 2 ;;
    --dry-run|-n)
        _DRY_RUN=1
        shift ;;
    --force|-f)
        _FORCE_PATCH="-DFORCE_PATCH=TRUE"
        shift ;;
    --full)
        _SCOPE=full
        shift ;;
    --help|-h)
        print_help
        exit 99 ;;
    --jobs|-j)
        _NJOBS=$2
        shift 2 ;;
    --minimal)
        _SCOPE=minimal
        shift ;;
    --ninja)
        _GENERATOR="-G Ninja"
        shift ;;
    --no-build)
        _DO_BUILD=0
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

[ -n "${_CXX_STD}" ] && _CXX_STANDARD="-DCXX_STANDARD=${_CXX_STD}"

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

config_build

if [ ${_DO_BUILD} -ne 0 ]; then
    # shellcheck disable=SC2086
    cmake --build "${_BLD_DIR}" -j${_NJOBS} ${_TARGET}
fi
