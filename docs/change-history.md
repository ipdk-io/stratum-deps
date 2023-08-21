# Change History

This document summarizes the changes that have been made in the transtion
from `networking-recipe/setup` to the `stratum-deps` repository.

## General changes

### CMake listfiles

- Change the default build type to Release.

- Refactor CMakeLists.txt file, creating a separate include file for each
  external package.

- Don't define the CMAKE_TOOLCHAIN_FILE variable when building external
  projects unless it is defined in the superproject.

### Directory layout

- Move documentation to `docs` subdirectory.

- Move script files to `scripts` subdirectory.

- Download repositories to `source` subdirectory.

### Documentation

- Overhaul build documentation.

- Add user guides for the `make-host-deps.sh` and `make-cross-deps.sh`
  helper scripts

- Add Change History document.

### Helper scripts

- Implement `--debug`, `--release`, and `--reldeb` options to specify
  the CMake build configuration.

### Package selection

- Google bundles a number of third-party packages with gRPC and Protobuf.
  Implement an OVERRIDE_PKGS option (default: ON) to specify whether we
  replace several of these packages with our own versions.

### Patch stage

- Implement PATCH option (default: ON) to allow the patch step to be disabled.

- Deprecate the FORCE_PATCH option.

- Move generated patch file to CMAKE_CURRENT_BINARY_DIR.

### Repository content

- Add CODEOWNERS and LICENSE files.

- Add README.md file.

## Individual packages

Most of these changes were made in anticipation of upgrading to more
recent versions of packages.

### Abseil

- Specify -DABSL_PROPAGATE_CXX_STD=on as an argument to the Abseil build,
  not as a standalone CMake variable.

- Newer versions of Abseil no longer automatically set RPATH.
  Modify build to do this explicitly.

### gRPC

- Allow GRPC_GIT_TAG to be overridden on the command line.

- Implement separate patch files for gRPC v1.54.2 and v1.56.0.
  Add a GRPC_VERSION variable that allows the patch file to be
  selected based on gRPC version number.

### Protobuf

- Modify Protobuf build to adapt to new location of the top-level
  CMakeLists.txt file.

- Protobuf now bundles a version of Abseil. Modify build to override this.

- When we build Protobuf v23.x with BUILD_SHARED_LIBS=ON, we get
  undefined external references to `thread_cache_`. Work around
  this problem by making the libraries static instead of shared.
