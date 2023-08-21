=================
make-host-deps.sh
=================

.. Copyright 2023 Intel Corporation
   SPDX-License-Identifier: Apache 2.0

Helper script to build and install the Stratum dependencies for the
x86 build system.

Syntax
======

.. code-block:: text

  ./scripts/make-host-deps.sh \
      [--help | -h]  [--dry-run | -n] \
      [--config]  [--cxx=STD] [--sudo] \
      [--no-download]  [--no-patch] \
      [--minimal | --full] \
      [--build=BLDDIR | -B BLDDIR] \
      [--prefix=PREFIX | -P PREFIX] \
      [--jobs=NJOBS | -j NJOBS]

Command-line parameters
=======================

Help
----

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

``--prefix=PREFIX``, ``-P PREFIX``
  Directory in which the host dependencies will be installed.
  Will be created if it does not exist.
  Specifies the value of the ``CMAKE_INSTALL_PREFIX`` variable.
  Defaults to ``hostdeps``.

Options
-------

``--config``
  Configures CMake but does not build the dependencies.
  Can be used to verify the parameter settings that will be used.

``cxx=STD``
  C++ standard to be used by the compiler (11, 14, 17).
  Specifies the value of the ``CXX_STANDARD`` listfile variable.

``--force``, ``-f``
  Requests that the ``-f`` (force) option be used when patching a
  downloaded repository.
  Specifies the value of the ``FORCE_PATCH`` listfile variable.
  Deprecated. If the repositories have already been patched, the
  ``--no-patch`` option bypasses the patch stage entirely.

``--full``
  Requests that the script build all the dependency libraries.
  The opposite of ``--minimal``.
  The default is ``--full``.

``--jobs=NJOBS``, ``-j NJOBS``
  Number of build threads.
  Specifies the value of the ``-j`` CMake option.
  Defaults to 8.

``--minimal``
  Requests that the script build only the dependencies needed in the
  cross-compilation environment.
  The opposite of ``--full``, which is the default.

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

Examples
========

Install as non-privileged user
------------------------------

To build the dependencies and install them in a user directory:

.. code-block:: bash

  ./scripts/make-host-deps.sh --prefix=~/hostdeps

The source files will be downloaded and built, and the results will be
installed in the ``~/hostdeps`` directory.

Install to system directory (non-root)
--------------------------------------

To install the Host dependencies in a system directory, log in as ``root``
or build from an account that has ``sudo`` privilege.

.. code-block:: bash

  ./scripts/make-host-deps.sh --prefix=/opt/deps --sudo

CMake will build the dependencies as the current user and use ``sudo`` to
install the libraries in ``/opt/deps``.

Install to system directory (root)
----------------------------------

To build and install to a system directory when logged in as ``root``:

.. code-block:: bash

  ./scripts/make-host-deps.sh --prefix=/opt/ipdk/hostdeps

CMake will build the dependencies and install them in ``/opt/ipdk/hostdeps``.

Build without downloading
-------------------------

Once the source repositories have been downloaded, it is possible to do
another build without downloading again:

.. code-block:: bash

  ./scripts/make-host-deps.sh --no-download --no-patch --prefix=hostdeps

The libraries will be built and installed in ``./hostdeps`` without
downloading or patching the source code.

Verify parameter settings
-------------------------

You can use the ``--dry-run`` or ``-n`` option to review the cmake parameter
settings your build will use:

.. code-block:: bash

  ~/stratum-deps$ ./scripts/make-host-deps.sh -B build.host -j6 \
      --no-download --no-patch --debug -n

  CMAKE_BUILD_TYPE=Debug
  CMAKE_INSTALL_PREFIX=hostdeps
  DOWNLOAD=FALSE
  PATCH=FALSE
  -B build.host
  -j6

  Will perform a full build

  ~/stratum-deps$

No other action will be taken.
