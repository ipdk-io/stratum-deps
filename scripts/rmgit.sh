#!/bin/bash
#
# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache 2.0
#
# Removes git directories and files
#

SOURCE_DIR=source

find ${SOURCE_DIR} -name .git -exec rm -fr {} +
find ${SOURCE_DIR} -name .gitattributes -exec rm {} +
find ${SOURCE_DIR} -name .gitignore -exec rm {} +
find ${SOURCE_DIR} -name .gitmodules -exec rm {} +
