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
_CFG_ONLY=false
_DRY_RUN=false
_NJOBS=8
_PREFIX=//opt/deps
_TOOLFILE=${CMAKE_TOOLCHAIN_FILE}

##############
# print_help #
##############

print_help() {
    echo ""
    echo "Build target dependency libraries"
    echo ""
    echo "Paths:"
    echo "  --build=DIR      -B  Build directory path [${_BLD_DIR}]"
    echo "  --host=DIR       -H  Host dependencies directory [${_HOST_DIR}]"
    echo "  --prefix=DIR*    -P  Install directory prefix [${_PREFIX}]"
    echo "  --toolchain=FILE -T  CMake toolchain file"
    echo ""
    echo "Options:"
    echo "  --config             Only perform configuration step"
    echo "  --cxx=VERSION        CXX_STANDARD to specify [${CXX_STD}]"
    echo "  --dry-run        -n  Display cmake parameters and exit"
    echo "  --force          -f  Specify -f when patching"
    echo "  --jobs=NJOBS     -j  Number of build threads [${_NJOBS}]"
    echo "  --no-download        Do not download repositories"
    echo "  --sudo               Use sudo when installing"
    echo ""
    echo "* '//' at the beginning of the directory path will be replaced"
    echo "  with the sysroot directory path."
    echo ""
    echo "Environment variables:"
    echo "  CMAKE_TOOLCHAIN_FILE - Default toolchain file"
    echo "  SDKTARGETSYSROOT - sysroot directory"
    echo ""
}

######################
# print_cmake_params #
######################

print_cmake_params() {
    echo ""
    [ -n "${_GENERATOR}" ] && echo "${_GENERATOR}"
    echo "CMAKE_INSTALL_PREFIX=${_PREFIX}"
    echo "CMAKE_TOOLCHAIN_FILE=${_TOOLFILE}"
    echo "JOBS=${_NJOBS}"
    [ -n "${_CXX_STANDARD_OPTION}" ] && echo "${_CXX_STANDARD_OPTION:2}"
    [ -n "${_DOWNLOAD}" ] && echo "${_DOWNLOAD:2}"
    [ -n "${_HOST_DEPEND_DIR}" ] && echo "${_HOST_DEPEND_DIR:2}"
    [ -n "${_FORCE_PATCH}" ] && echo "${_FORCE_PATCH:2}"
    [ -n "${_USE_SUDO}" ] && echo "${_USE_SUDO:2}"
    echo ""
}

######################
# Parse command line #
######################

SHORTOPTS=B:H:P:T:j:
SHORTOPTS=${SHORTOPTS}hn

LONGOPTS=build:,cxx:,hostdeps:,jobs:,prefix:,toolchain:
LONGOPTS=${LONGOPTS},config,dry-run,force,help,ninja,no-download,sudo

GETOPTS=$(getopt -o ${SHORTOPTS} --long ${LONGOPTS} -- "$@")
eval set -- "${GETOPTS}"

while true ; do
    case "$1" in
    # Paths
    -B|--build)
        _BLD_DIR=$2
        shift 2 ;;
    -H|--hostdeps)
        _HOST_DIR=$2
        shift 2 ;;
    -P|--prefix)
        _PREFIX=$2
        shift 2 ;;
    -T|--toolchain)
        _TOOLFILE=$2
        shift 2 ;;
    # Options
    --config)
        _CFG_ONLY=true
        shift ;;
    --cxx)
        _CXX_STANDARD_OPTION="-DCXX_STANDARD=$2"
        shift 2 ;;
    --dry-run|-n)
        _DRY_RUN=true
        shift ;;
    -f|--force)
        _FORCE_PATCH="-DFORCE_PATCH=TRUE"
        shift ;;
    -h|--help)
        print_help
        exit 99 ;;
    -j|--jobs)
        _NJOBS=$2
        shift 2 ;;
    --ninja)
        _GENERATOR="-G Ninja"
        shift ;;
    --no-download)
        _DOWNLOAD="-DDOWNLOAD=FALSE"
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

if [ -n "${_HOST_DIR}" ]; then
    _HOST_DEPEND_DIR="-DHOST_DEPEND_DIR=${_HOST_DIR}"
fi

# Show parameters if this is a dry run
if [ "${_DRY_RUN}" = "true" ]; then
    print_cmake_params
    exit 0
fi

######################
# Build dependencies #
######################

rm -fr ${_BLD_DIR}

cmake -S . -B ${_BLD_DIR} \
    "${_GENERATOR}" \
    -DCMAKE_INSTALL_PREFIX=${_PREFIX} \
    -DCMAKE_TOOLCHAIN_FILE=${_TOOLFILE} \
    ${_HOST_DEPEND_DIR} \
    ${_CXX_STANDARD_OPTION} \
    ${_DOWNLOAD} ${_FORCE_PATCH} ${_USE_SUDO}

if [ "${_CFG_ONLY}" = "false" ]; then
    cmake --build ${_BLD_DIR} -j${_NJOBS}
fi
