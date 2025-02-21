#!/usr/bin/env python3
#
# Copyright 2023 Intel Corporation.
# SPDX-License-Identifier: Apache-2.0
#
# Generates cmake definitions from manifest file.
# Can be extended to generate other outputs.
#

import argparse
import json
import logging
import os
from pprint import pprint
import sys

MANIFEST_FILE = "components.json"

CMAKE_HEADER = \
"""# URL and TAG definitions for dependencies
#
# Copyright 2022-2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#
# Generated by components.py.
#
"""

logger = logging.getLogger('manifest')

errcount = 0

#-----------------------------------------------------------------------
# error()
#-----------------------------------------------------------------------
def error(msg, *args, **kwargs):
    """Logs an error and increments the error count."""
    global errcount
    logger.error(msg, *args, **kwargs)
    errcount += 1
    return

#-----------------------------------------------------------------------
# read_manifest()
#-----------------------------------------------------------------------
def read_manifest(fname):
    """Read json file and return manifest"""
    try:
        with open(fname, 'r') as f:
            return json.load(f)
    except IOError as ex:
        logger.error("Error opening manifest file: %s", ex)
        exit(2)
    return

#-----------------------------------------------------------------------
# write_cmake_file()
#-----------------------------------------------------------------------
def write_cmake_file(manifest, out):
    write_cmake_header(out)
    for name in sorted(manifest.keys()):
        write_cmake_package(manifest[name], name.upper(), out)
    return

def write_cmake_header(out):
    out.write(CMAKE_HEADER)
    return

def write_cmake_package(pkg, name, out):
    out.write('\n')
    write_cmake_url(name, pkg, out)
    write_cmake_tag(name, pkg, out)
    write_cmake_version(name, pkg, out)
    write_cmake_defines(name, pkg, out)
    return

def write_cmake_url(name, pkg, out):
    value = required(pkg, 'url')
    out.write('set({}_GIT_URL "{}")\n'.format(name, value))
    return

def write_cmake_tag(name, pkg, out):
    sha = optional(pkg, 'sha')
    tag = optional(pkg, 'tag')
    label = optional(pkg, 'label')

    if sha is not None:
        value = sha
        if label is not None:
            suffix = " # {}".format(label)
        elif tag is not None:
            suffix = " # {}".format(tag)
        else:
            suffix = ""
    elif tag is not None:
        value = tag
        suffix = ""
    else:
        log.error("No 'sha' or 'tag' defined for %s", pkg['name'])
        exit(1)

    out.write('set({}_GIT_TAG "{}"){}\n'.format(name, value, suffix))
    return

def write_cmake_version(name, pkg, out):
    version = optional(pkg, 'version')
    if version is not None:
        out.write('set({}_VERSION "{}")\n'.format(name, version))
    return

def write_cmake_defines(name, pkg, out):
    defines = optional(pkg, 'defines')
    if defines is None:
        return
    for key in sorted(defines.keys()):
        out.write('set({}_{} "{}")\n'.format(name, key, defines[key]))
    return

def required(pkg, item):
    if item not in pkg:
        log.error("'%s' not defined for %s", item, pkg['name'])
        exit(1)
    return pkg[item]

def optional(pkg, item):
    return pkg[item] if item in pkg else None

#-----------------------------------------------------------------------
# process_args()
#
# Processes command-line parameters after they have been parsed.
#-----------------------------------------------------------------------
def process_args(args):
    process_manifest_param(args)
    process_output_param(args)
    return

def process_manifest_param(args):
    if args.manifest is None:
        args.manifest = os.path.join(os.path.dirname(__file__), MANIFEST_FILE)
    return

def process_output_param(args):
    if args.outfile is None:
        args.outfile = '/dev/stdout'
    return

#-----------------------------------------------------------------------
# create_parser() - Creates the command-line parser.
#-----------------------------------------------------------------------
def create_parser():
    parser = argparse.ArgumentParser(
        prog='components.py',
        description='Generates files from components.json.')

    parser.add_argument('--manifest', '-m', type=str,
                        default=MANIFEST_FILE,
                        help='manifest file to load')

    parser.add_argument('--output', '-o', dest='outfile',
                        help='output file path')

    return parser

#-----------------------------------------------------------------------
# main
#-----------------------------------------------------------------------
if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)

    parser = create_parser()
    args = parser.parse_args()
    process_args(args)

    if errcount != 0:
        exit(1)

    manifest = read_manifest(args.manifest)

    with open(args.outfile, 'w') as outfile:
        write_cmake_file(manifest, outfile)

# end __main__
