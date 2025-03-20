cmake_minimum_required(VERSION 3.16)
project(stratum_python_bindings)

# Find Python and Cython
find_package(Python COMPONENTS Interpreter Development REQUIRED)
find_package(Cython REQUIRED)
include(UseCython)

# Get version from main project or set it explicitly
set(PYTHON_MODULE_VERSION "${CMAKE_PROJECT_VERSION}")

# Define the Cython module
set(CYTHON_MODULE_NAME "stratum_python")
set(CYTHON_SOURCE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/stratum_bindings.pyx")

# Include directories for gRPC headers
include_directories(
    ${CMAKE_INSTALL_PREFIX}/include
    ${CMAKE_SOURCE_DIR}/source/grpc/third_party/abseil-cpp
)

# Cython compile command
cython_add_module(${CYTHON_MODULE_NAME} ${CYTHON_SOURCE_FILE})

# Now that the target exists, we can add dependencies
# Note: This only works if grpc is a proper CMake target in this context
# If using ExternalProject_Add, this dependency is handled differently
# add_dependencies(${CYTHON_MODULE_NAME} grpc)

# Add include directories to the target
target_include_directories(${CYTHON_MODULE_NAME} PRIVATE
    ${CMAKE_INSTALL_PREFIX}/include
    ${CMAKE_SOURCE_DIR}/source/grpc/third_party/abseil-cpp
)

# Link against the libraries built by stratum-deps
# Use the actual library files instead of targets
target_link_libraries(${CYTHON_MODULE_NAME} PRIVATE
    ${CMAKE_INSTALL_PREFIX}/lib/libgrpc++.so
    ${CMAKE_INSTALL_PREFIX}/lib/libgrpc.so
    ${CMAKE_INSTALL_PREFIX}/lib/libaddress_sorting.so
    ${CMAKE_INSTALL_PREFIX}/lib/libgpr.so
    ${CMAKE_INSTALL_PREFIX}/lib64/libprotobuf.so
    ${CMAKE_INSTALL_PREFIX}/lib64/libupb.a
    -pthread
)

# Installation path for the Python module
install(TARGETS ${CYTHON_MODULE_NAME}
    LIBRARY DESTINATION python/stratum_python
)

# Configure setup.py from template
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in"
    "${CMAKE_CURRENT_BINARY_DIR}/setup.py"
    @ONLY
)

# Configure pyproject.toml
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml"
    "${CMAKE_CURRENT_BINARY_DIR}/pyproject.toml"
    COPYONLY
)

# Copy __init__.py
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/stratum_python/__init__.py"
    "${CMAKE_CURRENT_BINARY_DIR}/stratum_python/__init__.py"
    COPYONLY
)

# Add custom target to build the wheel
add_custom_target(python_wheel
    COMMAND ${Python_EXECUTABLE} -m pip install --upgrade build
    COMMAND ${Python_EXECUTABLE} -m build --wheel
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${CYTHON_MODULE_NAME}
    COMMENT "Building Python wheel package"
)
