# Change History

This document summarizes the changes that have been made in the transtion
from `networking-recipe/setup` to a standlone repository.

## General changes

### Directory layout

- Move script files to `scripts` subdirectory.

- Move documentation to `docs` subdirectory.

- Move downloaded repositories to `source` subdirectory.

### Repository content

- Add CODEOWNERS and LICENSE files.

- Add README.md file.

### CMake build files

- Refactor CMakeLists.txt file, creating a separate include file for each
  external package.

### Package selection

- Implement OVERRIDE_PKGS option to control whether we build our own
  versions of third-party packages bundled with gRPC and Protobuf.
  (Default: ON)

### Patch stage

- Implement PATCH option to allow the patch step to be disabled.
  (Default: OFF)

- Deprecate the FORCE_PATCH option.

- Move generated patch file to CMAKE_CURRENT_BINARY_DIR.

### Documentation

- Overhaul build documentation.

- Add Ninja example to build instructions.

- Add Change History document.

### Configuration options

- Don't define the CMAKE_TOOLCHAIN_FILE variable when building external
  projects unless it is defined in the superproject.

## Individual packages

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
  undefined external references to `thread_cache_``. Work around
  this problem by building Protobuf in static library mode.
