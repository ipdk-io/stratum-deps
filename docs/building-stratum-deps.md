# Building the Stratum Dependencies

Stratum is the component of `infrap4d` that implements the P4Runtime and gNMI
(OpenConfig) services. It requires that a number of third-party libraries
be installed on the development system.

This document explains how to build and install the Stratum dependencies.

> **Note**: For the Intel&reg; IPU E2100, see
[Building Stratum Dependencies for the ES2K ACC](building-acc-stratum-deps.md).

## Prerequisites

In order to build the Stratum dependencies:

* CMake 3.15 or above must be installed.

  Avoid versions 3.24 and 3.25. There is an issue in cmake that causes the
  Protobuf build to fail. This problem was fixed in version 3.26.

* OpenSSL 1.1 must be installed.

  P4 Control Plane uses OpenSSL instead of BoringSSL.

## Source code

Clone the repository to your development system:

```bash
git clone https://github.com/ipdk-io/stratum-deps.git
```

The CMake script will download the source code for the libraries as the
first step in the build.

## Install location

You will need to decide where on your system you would like to install the
dependencies. This location (the "install prefix") must be specified when you
configure the build.

It is recommended that you _not_ install the dependency libraries in `/usr` or
`/usr/local`. It is easier to upgrade or rebuild if packages that are
updated on different cadences are kept separate from one another.

The `CMAKE_INSTALL_PREFIX` option is used to specify the directory in which
the dependencies should be installed.

If you plan to install the dependency libraries in a system directory, you will
need to log in as `root` or run from an account that has `sudo` privilege.

## 5 Build options

The CMake build script supports the following configuration options.

| Option | Type | Description |
| ------ | ---- | ----------- |
| `CMAKE_INSTALL_PREFIX` | Path | Directory in which the dependencies should be installed. |
| `CXX_STANDARD` | Number | C++ standard (11, 14, 17, etc.) the compiler should apply. (Default: not specified) |
| `DOWNLOAD` | Boolean | Whether to download the source repositories. (Default: TRUE)
| `ON_DEMAND` | Boolean | Whether to build only the specified target(s). If this option is FALSE, all targets will be built. (Default: FALSE) |
| `PATCH` | Boolean | Whether to patch the source after downloading it. Should be FALSE if building source that was previously downloaded. (Default: TRUE)
| `USE_LDCONFIG` | Boolean | Whether to use `ldconfig` to update the loader cache[1] after installing a module. Only valid if `USE_SUDO` is enabled. (Default: FALSE) |
| `USE_SUDO` | Boolean | Whether to use `sudo` to install each module. (Default: FALSE) |

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
