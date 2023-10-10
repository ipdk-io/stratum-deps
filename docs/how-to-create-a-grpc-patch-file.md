# How to create a gRPC patch file

## Get version to patch

Fetch the version of gRPC you wish to patch. The quickest way to do this is
to download it as a tarball:

  ```bash
  wget https://github.com/grpc/grpc/archive/refs/tags/v1.59.1.tar.gz
  ```

Unpack the tarball:

  ```bash
  tar xzf v1.59.1.tar.gz
  ```

## Edit CMakeLists.txt

Make a copy of the `CMakeLists.txt` file.

  ```bash
  cd grpc-1.59.1
  cp CMakeLists.txt CMakeLists.patched.txt
  ```

Load the copy into your favorite editor.

  ```bash
  code CMakeLists.patched.txt
  ```

Find `add_executable(grpc_cpp_plugin`:

  ```bash
  add_executable(grpc_cpp_plugin
    src/compiler/cpp_plugin.cc
  )
  target_compile_features(grpc_cpp_plugin PUBLIC cxx_std_14)
  ```

Insert a command to set the `INSTALL_RPATH` property between the
`add_executable()` command and its successor:

  ```bash
  add_executable(grpc_cpp_plugin
    src/compiler/cpp_plugin.cc
  )
  set_target_properties(grpc_cpp_plugin
    PROPERTIES INSTALL_RPATH @GRPC_INSTALL_RPATH@
  )
  target_compile_features(grpc_cpp_plugin PUBLIC cxx_std_14)
  ```

Find `add_executable(grpc_python_plugin`:

  ```bash
  add_executable(grpc_python_plugin
    src/compiler/python_plugin.cc
  )
  target_compile_features(grpc_python_plugin PUBLIC cxx_std_14)
  ```

Insert a command to set the `INSTALL_RPATH` property between the
`add_executable()` command and its successor:

  ```bash
  add_executable(grpc_python_plugin
    src/compiler/python_plugin.cc
  )
  set_target_properties(grpc_python_plugin
    PROPERTIES INSTALL_RPATH @GRPC_INSTALL_RPATH@
  )
  target_compile_features(grpc_python_plugin PUBLIC cxx_std_14)
  ```

Save the modified file.

## Create patch file

Use the `diff` command to generate a patch file.

  ```bash
  diff -u CMakeLists.txt CMakeLists.patched.txt > grpc-v1.59.1.patch.in
  ```

The patch file should look something like this:

  ```bash
  diff --git a/CMakeLists.txt b/CMakeLists.patched.txt
  index 14501a1..a032c3a 100644
  --- a/CMakeLists.txt
  +++ b/CMakeLists.patched.txt
  @@ -12804,6 +12804,9 @@ if(gRPC_BUILD_CODEGEN AND gRPC_BUILD_GRPC_CPP_PLUGIN)
  add_executable(grpc_cpp_plugin
    src/compiler/cpp_plugin.cc
  )
  +set_target_properties(grpc_cpp_plugin
  +  PROPERTIES INSTALL_RPATH @GRPC_INSTALL_RPATH@
  +)
  target_compile_features(grpc_cpp_plugin PUBLIC cxx_std_14)
  target_include_directories(grpc_cpp_plugin
    PRIVATE
  @@ -13037,6 +13040,9 @@ if(gRPC_BUILD_CODEGEN AND gRPC_BUILD_GRPC_PYTHON_PLUGIN)
  add_executable(grpc_python_plugin
    src/compiler/python_plugin.cc
  )
  +set_target_properties(grpc_python_plugin
  +  PROPERTIES INSTALL_RPATH @GRPC_INSTALL_RPATH@
  +)
  target_compile_features(grpc_python_plugin PUBLIC cxx_std_14)
  target_include_directories(grpc_python_plugin
    PRIVATE
  ```

Copy the patch file to the `cmake/patches` folder.

**Note:**

The name of the file in the `patches` folder *must* be of the form
`grpc-v${GRPC_VERSION}.patch.in`, where `${GRPC_VERSION}` is the
gRPC version number. For example, the patch file for version `1.59.1`
would be `grpc-v1.59.1.patch.in`.
