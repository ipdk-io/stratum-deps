# Stratum Dependencies Transition Guide

The logic to build and install the Stratum dependencies is moving from
`networking-recipe/setup` to its own repository (`stratum-deps`).

This document provides information to help users of P4 Control Plane
to transition from the old repository to the new one.

## GitHub repository (URL)

The Stratum dependencies were previously located at
[https://github.com/ipdk-io/networking-recipe/setup](https://github.com/ipdk-io/networking-recipe/tree/main/setup).
The new URL is <https://github.com/ipdk-io/stratum-deps>.

You will need to update any documentation or procedures you maintain (e.g.,
script files) that specify (a) the URL of the repository, or (b) the path to
the local copy on your development system.

We recommend maintaining the separation between `networking-recipe` and
`stratum-deps` when you download the repositories to your local system.
This allows the two packages to be updated independently of each other.

## Repository reference (SHA)

The SHA you specify for the Stratum dependencies will be different, because
you are fetching from a new repository.

The SHA will not change as often in the future, because `stratum-deps`
now has its own SHA, which is only updated when there is a change in the
dependencies.
The `networking-recipe` SHA changes when *any* of its components are
modified.

## Helper scripts

The helper scripts have moved to a new `scripts` folder.

You will need to update any documentation or procedures you maintain (e.g.,
scripts that invoke the helper scripts) to reflect their new location.

| Old path | New path |
| -------- | -------- |
| `./make-host-deps.sh`  | `./scripts/make-host-deps.sh`  |
| `./make-cross-deps.sh` | `./scripts/make-cross-deps.sh` |

This change reduces clutter in the top-level directory.

## Source files

The downloaded repositories containing the source files for the dependencies
are now under a `source` folder.

This change isolates the downloaded code from the rest of the project
and reduces clutter in the top-level directory.

## Patch options

The cmake `FORCE_PATCH=ON` option (`--force` in the helper scripts) has
been deprecated in favor of a new `PATCH=OFF` (`--no-patch`) option.

The directive is used to avoid reapplying the gRPC patch when the source
files you are building were previously downloaded.

`FORCE_PATCH=ON` works by enabling the `-f` option of the Linux `patch`
utility. This has proven to be an unreliable operation.

`PATCH=NO` simply disables the patch step. This approach is consistent
in its results. It is also easier to understand.

## Source bundles

Some distributions of P4 Control Plane (specifically MEV-TS)
download the Stratum dependencies in advance and bundle them with the
rest of the source code. This makes it easier for you to build the
package in environments that do not have Internet access.

The bundled source ordinarily requires additional parameters on the
build command line, to disable the Download and Patch steps.

`stratum-deps` has a new feature that allows you to change the default
values of the `DOWNLOAD` and `PATCH` options in a bundled-source
distribution.

To use this feature, build the stratum dependencies normally and then
issue the command:

```bash
./scripts/preconfig.sh
```

in the `stratum-deps` directory. The script will create a file in the
`source` directory that the CMake listfile reads on startup:

```cmake
set(DOWNLOAD FALSE CACHE BOOL "preconfig: Download repositories")
set(PATCH FALSE CACHE BOOL "preconfig: Patch source after downloading")
```

The `DOWNLOAD` and `PATCH` options will now be disabled by default,
removing the need for additional build parameters.

## Releases

We have begun using the GitHub
[Releases](https://github.com/ipdk-io/stratum-deps/releases)
feature to define numbered versions of the Stratum dependencies package, each
with its own release notes and build artifacts.

The plan is to provide prebuilt binaries that can be downloaded and used
as an "off-the-shelf" alternative to the "do-it-yourself" process of
downloading and building the dependencies yourself. The current offering
is an Ubuntu 22.04 build that is suitable for use in GitHub workflows.

## Source tarball

The release artifacts include a source tarball that may be downloaded
using `wget` or `curl`, instead of having cmake fetch the git repositories
at build time.

For example:

```bash
wget https://github.com/ipdk-io/stratum-deps/releases/download/v1.2.1/deps-source.tar.gz
tar -xzf deps-source.tar.gz
```

The source tarball omits unused and redundant subprojects, as well as
the git history. This reduces the amount of data transferred considerably,
resulting in a much faster download.

The tarball also includes a preconfig file that disables the `DOWNLOAD`
and `PATCH` options.
