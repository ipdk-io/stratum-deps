# Make sure we have Python and Cython available
find_package(Python COMPONENTS Interpreter Development REQUIRED)
find_package(Cython REQUIRED)

ExternalProject_Add(python_bindings
    DEPENDS grpc  # This ensures grpc is built first
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/python
    BINARY_DIR ${CMAKE_BINARY_DIR}/python_build
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
        ${deps_BUILD_TYPE}
        ${deps_TOOLCHAIN_FILE}
    BUILD_ALWAYS TRUE
    INSTALL_COMMAND ""  # Handle installation separately if needed
)

# Add a custom target to build the wheel
add_custom_target(python_wheel
    COMMAND ${Python_EXECUTABLE} -m pip install --upgrade build
    COMMAND ${Python_EXECUTABLE} -m build --wheel
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/python_build
    DEPENDS python_bindings
    COMMENT "Building Python wheel package"
)
