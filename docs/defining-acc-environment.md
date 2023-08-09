# Defining the ACC build environment

In order to cross-compile for the ACC, you will need to define a number
of environment variables. This is typically done by putting the bash
commands in a file (e.g. `acc-setup.env`) and using the `source` command
to execute it. We recommend removing execute permission from the file
(`chmod a-x setup.env`) to remind yourself to source it, not run it.

## File template

```bash
# Used internally.
AARCH64=@ACC_SDK@/aarch64-intel-linux-gnu
SYSROOT=$AARCH64/aarch64-intel-linux-gnu/sysroot

# Used externally for build.
export SDKTARGETSYSROOT=$SYSROOT
export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
export PKG_CONFIG_PATH=$SYSROOT/usr/lib64/pkgconfig:$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig
export CMAKE_TOOLCHAIN_FILE=@CMAKE_DIR@/aarch64-toolchain.cmake

# Adds cross-compiler to PATH.
[ -z "$ACC_SAVE_PATH" ] && export ACC_SAVE_PATH=$PATH
export PATH=$AARCH64/bin:$ACC_SAVE_PATH
```

## Symbol definitions

In the template above, you will need to provide values for these placeholders:

- `@ACC_SDK@` - install path of the ACC-RL SDK (for example,
  `$HOME/p4cp-dev/acc_sdk`)
- `@CMAKE_DIR@` - path to the `cmake` directory containing the toolchain file

From `@ACC_SDK@`, the setup script derives:

- `AARCH64` - path to the directory containing the AArch64
  cross-compiler suite
- `SYSROOT` - path to the sysroot directory, which contains AArch64
  header files and binaries

These directories are part of the ACC SDK.

The setup script exports the following variables, which are used by CMake
and the helper script:

- `SDKTARGETSYSROOT` - path to the sysroot directory
- `PKG_CONFIG_PATH` - search path for `pkg-config` to use when looking for
  packages on the target system
- `PKG_CONFIG_SYSROOT_DIR` - path to the sysroot directory, for use by
  `pkg-config`
- `CMAKE_TOOLCHAIN_FILE` - path to the CMake toolchain file

The setup script also adds the directory containing the cross-compiler
to the system `PATH`.

## SDK setup file

The ACC-RL SDK includes its own setup file
(`environment-setup-aarch64-intel-linux-gnu`).
We strongly recommend *against* using this file when building P4 Control Plane
or the Stratum dependencies.

The SDK setup file is intended for use with GNU Autotools.
The environment variables it defines affect the behavior of the C and
C++ compilers and the linker.
These definitions may interfere with the CMake build in non-obvious ways.
