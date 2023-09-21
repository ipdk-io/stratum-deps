#!/bin/bash
#
# Copyright 2022-2023 Intel Corporation
# SPDX-License-Identifier: Apache 2.0
#
# Sample script to configure and build the dependency libraries
# on the development host when cross-compiling for the ES2K ACC.
#

# Abort on error.
set -e

#################
# Check sysroot #
#################

if [ -z "${SDKTARGETSYSROOT}" ]; then
    echo ""
    echo "-----------------------------------------------------"
    echo "Error: SDKTARGETSYSROOT is not defined!"
    echo "Did you forget to source the environment variables?"
    echo "-----------------------------------------------------"
    echo ""
    exit 1
fi

_SYSROOT=${SDKTARGETSYSROOT}

##################
# Default values #
##################

_BLD_DIR=build
_DO_BUILD=1
_DRY_RUN=0
_HOST_DIR=${HOST_INSTALL}
_NJOBS=8
_PREFIX=//opt/deps
_TOOLFILE=${CMAKE_TOOLCHAIN_FILE}

##############
# print_help #
##############

print_help() {
    echo ""
    echo "Build dependency libraries for ACC"
    echo ""
    echo "General:"
    echo "  --dry-run        -n  Display cmake parameters and exit"
    echo "  --help           -h  Display help text and exit"
    echo ""
    echo "Host paths:"
    echo "  --build=DIR      -B  Build directory path [${_BLD_DIR}]"
    echo "  --host=DIR       -H  Host dependencies directory [${_HOST_DIR}]"
    echo "  --toolchain=FILE -T  CMake toolchain file"
    echo ""
    echo "Target paths:"
    echo "  --prefix=DIR*    -P  Install directory prefix [${_PREFIX}]"
    echo ""
    echo "* '//' at the beginning of the directory path will be replaced"
    echo "  with the sysroot directory path."
    echo ""
    echo "Options:"
    echo "  --cxx=STD            C++ standard to be used [${_CXX_STD}]"
    echo "  --force          -f  Specify -f when patching (deprecated)"
    echo "  --jobs=NJOBS     -j  Number of build threads [${_NJOBS}]"
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
    echo "Environment variables:"
    echo "  CMAKE_TOOLCHAIN_FILE - Default toolchain file"
    echo "  HOST_INSTALL - Default host dependencies directory"
    echo "  SDKTARGETSYSROOT - Sysroot directory"
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
    echo "CMAKE_TOOLCHAIN_FILE=${_TOOLFILE}"
    [ -n "${_CXX_STD}" ] && echo "CXX_STANDARD=${_CXX_STD}"
    [ -n "${_HOST_DEPEND_DIR}" ] && echo "${_HOST_DEPEND_DIR:2}"
    [ -n "${_DOWNLOAD}" ] && echo "${_DOWNLOAD:2}"
    [ -n "${_PATCH}" ] && echo "${_PATCH:2}"
    [ -n "${_FORCE_PATCH}" ] && echo "${_FORCE_PATCH:2}"
    [ -n "${_USE_SUDO}" ] && echo "${_USE_SUDO:2}"
    echo "-B ${_BLD_DIR}"
    if [ ${_DO_BUILD} -eq 0 ]; then
        echo ""
        echo "Configure without building"
        return
    fi
    echo "-j${_NJOBS}"
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
        -DCMAKE_TOOLCHAIN_FILE="${_TOOLFILE}" \
        ${_CXX_STANDARD} \
        ${_HOST_DEPEND_DIR} \
        ${_DOWNLOAD} \
        ${_PATCH} \
        ${_FORCE_PATCH} \
        ${_USE_SUDO}
}

######################
# Parse command line #
######################

SHORTOPTS=B:H:P:T:j:
SHORTOPTS=${SHORTOPTS}hn

LONGOPTS=build:,hostdeps:,prefix:,toolchain:
LONGOPTS=${LONGOPTS},cxx-std:,jobs:
LONGOPTS=${LONGOPTS},debug,release,reldeb
LONGOPTS=${LONGOPTS},dry-run,force,help,ninja
LONGOPTS=${LONGOPTS},no-build,no-download,no-patch,sudo

GETOPTS=$(getopt -o ${SHORTOPTS} --long ${LONGOPTS} -- "$@")
eval set -- "${GETOPTS}"

while true ; do
    case "$1" in
    # Paths
    --build|-B)
        _BLD_DIR=$2
        shift 2 ;;
    --hostdeps|-H)
        _HOST_DIR=$2
        shift 2 ;;
    --prefix|-P)
        _PREFIX=$2
        shift 2 ;;
    --toolchain|-T)
        _TOOLFILE=$2
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
    --help|-h)
        print_help
        exit 99 ;;
    --jobs|-j)
        _NJOBS=$2
        shift 2 ;;
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

# Replace "//"" prefix with "${_SYSROOT}/""
[ "${_PREFIX:0:2}" = "//" ] && _PREFIX="${_SYSROOT}/${_PREFIX:2}"

[ -n "${_CXX_STD}" ] && _CXX_STANDARD="-DCXX_STANDARD=${_CXX_STD}"
[ -n "${_HOST_DIR}" ] && _HOST_DEPEND_DIR="-DHOST_DEPEND_DIR=${_HOST_DIR}"

# Show parameters if this is a dry run
if [ ${_DRY_RUN} -ne 0 ]; then
    print_cmake_params
    echo ""
    exit 0
fi

######################
# Build dependencies #
######################

rm -fr "${_BLD_DIR}"

config_build

if [ ${_DO_BUILD} -ne 0 ]; then
    # shellcheck disable=SC2086
    cmake --build "${_BLD_DIR}" -j${_NJOBS}
fi
