# Building ACC Target Dependencies

This document explains how to build the Stratum dependencies for the
ARM Compute Complex (ACC) of the Intel&reg; IPU E2100.

> **Note**: To build the dependencies for the Host system, see
[Building Host Dependencies](building-host-deps.md).

## Introduction

Stratum is the component of P4 Control Plane that implements the P4Runtime
and gNMI (OpenConfig) services. It requires a number of third-party
libraries, which this package provides.

You will need to build two versions of the libraries:

- The **Host** libraries, which run on the build system. They provide
  tools that are used to build P4 Control Plane.

- The **Target** libraries, which run on the ACC. P4 Control Plane is
  compiled and linked against these libraries.

The Host and Target libraries must be the same version.

## Requirements

Before you build the dependencies, you need to:

- Install CMake 3.15 or above

  Avoid versions 3.24 and 3.25. They cause the dependencies build to fail.

- Install OpenSSL 1.1

  Note that P4 Control Plane is not compatible with BoringSSL.

- Install the ACC SDK

  See [Installing the ACC SDK](https://ipdk.io/p4cp-userguide/guides/es2k/installing-acc-sdk)
  for directions.

## Source

Clone this repository to your development system:

```bash
git clone https://github.com/ipdk-io/stratum-deps.git
```

The build procedure will download the source code for the libraries
as needed.

## Host dependencies

### Host install location

Pick an install location for the Host dependencies. This location (the
"install prefix") must be specified when you configure the build.

It is recommended that you *not* install the Host dependencies in `/usr` or
`/usr/local`. It will be easier to rebuild or update the dependencies if
their libraries are not mingled with other libraries.

### Host build script

The `scripts` subdirectory includes a helper script (`make-host-deps.sh`) that
can be used to build the Host dependencies.

- The `--help` (`-h`) option lists the parameters the helper script supports

- The `--dry-run` (`-n`) option displays the parameter values without
  running CMake

### Host build environment

The Host and Target build environments are mutually incompatible.
You must ensure that the [ACC build environment](defining-acc-environment.md)
is undefined when you build the Host dependencies.

### User build

To install the dependencies in a user directory:

```bash
./scripts/make-host-deps.sh --prefix=PREFIX
```

PREFIX might something like `~/hostdeps`.

The source files will be downloaded and built, and the results will be
installed in the specified directory.

### System build

To install the Host dependencies in a system directory, log in as `root`
or build from an account that has `sudo` privilege.

```bash
./scripts/make-host-deps.sh --prefix=PREFIX --sudo
```

PREFIX might be something like `/opt/ipdk/x86deps`.

The script only uses `sudo` when installing libraries.
Omit the `--sudo` parameter if you are running as `root`.

## Target dependencies

### Target install location

Pick an install location for the Target dependencies.
This will typically be under the sysroot directory structure. For
example, the `opt` subdirectory will become the root-level `/opt`
directory when the file structure is copied to the E2100 file system.

### Target build script

The `setup` directory includes a helper script (`make-cross-deps.sh`) that
can be used to build the Target dependencies.

- The `--help` (`-h`) option lists the parameters the helper script supports

- The `--dry-run` (`-n`) option displays the parameter values without
  running CMake

You will need to provide the helper script with the path to the Host
dependencies (`--host`) as well as the install prefix (`--prefix`).

### Target build environment

See [Defining the ACC Build Environment](defining-acc-environment.md)
for instructions on creating an `acc-setup.env` file to define the environment
variables needed for cross-compilation.

### Target build

Source the file that defines the the ACC build environment:

```bash
source acc-setup.env
```

Run the build script:

```bash
./scripts/make-cross-deps.sh --host=HOSTDEPS --prefix=PREFIX
```

`HOSTDEPS` is the path to the Host dependencies, e.g., `~/p4cp-dev/hostdeps`.

`PREFIX` is the install prefix for the Target dependencies. Here, you might
specify something like `//opt/ipdk/deps`.

The `//` at the beginning of the prefix path is a shortcut provided by
the helper script. It will be replaced with the sysroot directory path.
