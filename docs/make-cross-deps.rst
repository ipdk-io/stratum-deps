.. Copyright 2023 Intel Corporation
   SPDX-License-Identifier: Apache 2.0

==================
make-cross-deps.sh
==================

Helper script to build and install the Stratum dependencies for the
Arm Compute Complex (ACC).

Syntax
======

.. code-block:: text

  ./scripts/make-cross-deps.sh \
      [--help | -h]  [--dry-run -n] \
      [--config]  [--cxx=STD] [--sudo] \
      [--no-download]  [--no-patch] \
      [--build=BLDDIR | -B BLDDIR] \
      [--host=HOSTDEPS | -H HOSTDEPS] \
      [--prefix=PREFIX | -P PREFIX] \
      [--toolchain=TOOLFILE | -T TOOLFILE ] \
      [--jobs=NJOBS | -j NJOBS]

Command-line parameters
=======================

General
-------

``--dry-run``, ``-n``
  Displays the parameters that will be passed to CMake, and exits.

``--help``, ``-h``
  Displays usage information and exits.

Paths
-----

``--build=BLDDIR``, ``-B BLDDIR``
  Directory that CMake will use to perform the build.
  Will be created if it does not exist.
  Specifies the value of the ``-B`` CMake option.
  Can be used to create separate build directories for host and
  target dependencies.
  Defaults to ``build``.

``--host=HOST``, ``-H HOST``
  Directory in which the native (nost system) dependencies were installed.
  Used to run the Protobuf compiler during the build.
  Specifies the value of the ``HOST_DEPEND_DIR`` listfile variable.
  Defaults to the value of the ``HOST_INSTALL`` environment variable.

``--prefix=PREFIX``, ``-P PREFIX``
  Directory in which the target dependencies will be installed.
  Will be created if it does not exist.
  Specifies the value of the ``CMAKE_INSTALL_PREFIX`` variable.
  ``//`` at the beginning of the path is a shortcut. The script will
  make the path relative to the sysroot directory.

``--toolchain=FILE``, ``-T FILE``
  CMake toolchain file.
  Must be specified when cross-compiling.
  Specifies the value of the ``CMAKE_TOOLCHAIN_FILE`` variable.
  Defaults to the value of the ``CMAKE_TOOLCHAIN_FILE`` environment variable.

Options
-------

``--config``
  Configures CMake but does not build the dependencies.
  Can be used to verify the parameter settings that will be used.

``--cxx=STD``
  C++ standard to be used by the compiler (11, 14, 17).
  Specifies the value of the ``CXX_STANDARD`` listfile variable.

``--force``, ``-f``
  Requests that the ``-f`` (force) option be used when patching a
  downloaded repository.
  Specifies the value of the ``FORCE_PATCH`` listfile variable.
  Deprecated. If the repositories have already been patched, the
  ``--no-patch`` option bypasses the patch stage entirely.

``--jobs=NJOBS``, ``-j NJOBS``
  Number of build threads.
  Specifies the value of the ``-j`` CMake option.
  Defaults to 8.

``--no-download``
  Do not download the repositories.
  Use this option if building from a source package or from source that was
  previously downloaded.
  The ``DOWNLOAD`` listfile variable will be set to FALSE.
  You will also want to specify ``--no-patch`` (or possibly ``--force``).

``--no-patch``
  Do not patch repositories after downloading them.
  The ``PATCH`` listfile variable will be set to FALSE.

``--sudo``
  Requests that ``sudo`` be used when installing the dependencies.
  The ``USE_SUDO`` listfile variable will be set to TRUE.

Configurations
--------------

``--debug``
  Build with ``-DCMAKE_BUILD_TYPE=Debug``.
  The compiler settings will default to ``-g``.

``--reldeb``
  Build with ``-DCMAKE_BUILD_TYPE=RelWithDebInfo``.
  The compiler settings will default to ``-O2 -g -DNDEBUG``.

``--release``
  Build with ``-DCMAKE_BUILD_TYPE=Release``.
  The compiler settings will default to ``-O3 -DNDEBUG``.

Environment variables
=====================

``CMAKE_TOOLCHAIN_FILE``
  Path to the CMake toolchain file to be used.
  Specifies the value of the ``CMAKE_TOOLCHAIN_FILE`` variable.
  May be overridden by ``--toolchain=TOOLFILE``.
  Must be set.

``HOST_INSTALL``
  Directory in which the Stratum dependencies for the host system were
  installed.
  Specifies the default value of the ``--host`` option.

``SDKTARGETSYSROOT``
  Directory containing the Root File System (RFS) for the target system.
  Must be set.
  Provides the header files and libraries against which the target
  dependencies will be built.
  Used in the toolchain file to set the ``CMAKE_SYSROOT`` variable.
  The target dependencies are usually installed under sysroot.
