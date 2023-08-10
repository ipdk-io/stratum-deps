# Building Stratum dependencies

Stratum is the component of `infrap4d` that implements the P4Runtime and gNMI
(OpenConfig) services. It requires  a number of third-party libraries, which
this package provides.

This document explains how to build and install the Stratum dependencies.

> **Note**: For the Intel&reg; IPU E2100, see
[Building Stratum dependencies for the ACC](building-acc-stratum-deps.md).

## Prerequisites

Before you build the dependencies, you need to:

- Install CMake 3.15 or above

  Avoid versions 3.24 and 3.25. They cause the dependencies build to fail.

- Install OpenSSL 1.1

  Note that P4 Control Plane is not compatible with BoringSSL.

## Source code

Clone the repository to your development system:

```bash
git clone https://github.com/ipdk-io/stratum-deps.git
```

The CMake script will download the source code for the libraries as the
first step in the build.

The source code for the dependencies is not part of the distribution.
It is downloaded by the build script.

## Install location

You will need to decide where to install the dependencies. This location
(the "install prefix") must be specified when you configure the build.

It is recommended that you _not_ install the dependency libraries in `/usr`
or `/usr/local`. The packages will be easier to update if they are separated
from other libraries.

The `CMAKE_INSTALL_PREFIX` option specifies the directory in which the
dependencies should be installed.

If you _do_ decide to install the dependencies in a system directory, you
will need to log in as `root` or do the build in an account that has `sudo`
privilege.

## Build options

The CMake build script supports the following configuration options.

| Option | Type | Description |
| ------ | ---- | ----------- |
| `CMAKE_INSTALL_PREFIX` | Path | Directory in which the dependencies should be installed. |
| `CXX_STANDARD` | Number | C++ standard (11, 14, 17, etc.) the compiler should apply. (default: not specified) |
| `DOWNLOAD` | Boolean | Whether to download the source repositories. (default: TRUE) |
| `FORCE_PATCH` | Boolean | Whether to specify the force (`-f`) option when patching a downloaded repository. (default: FALSE) (deprecated) |
| `ON_DEMAND` | Boolean | Whether to build only the specified target(s). If this option is FALSE, all targets will be built. (default: FALSE) |
| `PATCH` | Boolean | Whether to patch the source after downloading it. Should be FALSE if building source that was previously downloaded. (default: TRUE) |
| `USE_LDCONFIG` | Boolean | Whether to use `ldconfig` to update the loader cache[1] after installing a module. Only valid if `USE_SUDO` is enabled. (default: FALSE) |
| `USE_SUDO` | Boolean | Whether to use `sudo` to install each module. (default: FALSE) |

Boolean values are (`TRUE`, `YES`, `ON`) and (`FALSE`, `NO`, `OFF`).
They may be upper or lower case.

[1] See the `ldconfig` man page for more information.

## Examples

### Non-root build

To build and install as a non-privileged user:

```bash
cd setup
cmake -B build -DCMAKE_INSTALL_PREFIX=./install
cmake --build build -j8
```

The source files will be downloaded, built, and installed in the `install`
directory. The targets will be built in parallel, using eight threads.

CMake will generate all of its temporary files in the `build` directory.
This is called an "out-of-source" build.

### Non-root build to system directory

To build as a non-privileged user and use `sudo` to install the libraries to
a system directory:

```bash
cmake -B build -DCMAKE_INSTALL_PREFIX=/opt/deps -DUSE_SUDO=yes
cmake --build build -j6
```

CMake will build the dependencies as the current user and use `sudo` to
install the libraries in `/opt/deps`. The build will be done in parallel,
using six threads.

### Build and install as root user

To build and install to a system directory when logged in as `root`:

```bash
cmake -B build -DCMAKE_INSTALL_PREFIX=/opt/ipdk/hostdeps
cmake --build build -j8
```

CMake will build and install the dependency libraries.

### Build without downloading

Once the source repositories have been downloaded, it is possible to do
another build without downloading again:

```bash
# Remove artifacts of previous build
rm -fr build

# Build and install dependencies
cmake -B build -DDOWNLOAD=NO -DPATCH=NO -DCMAKE_INSTALL_PREFIX=hostdeps
cmake --build build -j6
```

The libraries will be built and installed in `./hostdeps` without downloading
or patching the source code.

### On-demand build

To build and install just gRPC and its dependencies:

```bash
cmake -B build -DON_DEMAND=yes -DCMAKE_INSTALL_PREFIX=~/hostdeps
cmake --build build -j6 --target grpc
```

The necessary components will be downloaded, built, and installed in
`/home/<username>/hostdeps`.

### Clean the `stratum-deps` directory

To scrub the directory:

```bash
rm -fr build source
```

This removes the temporary build files and the downloaded source.
