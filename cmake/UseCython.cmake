# Define a function to add a Cython module
function(cython_add_module _name _source)
    set_source_files_properties(${_source} PROPERTIES CYTHON_IS_CXX TRUE)
    
    # Run Cython compiler to generate C++ code
    add_custom_command(
        OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${_name}_cython.cpp"
        COMMAND ${CYTHON_EXECUTABLE}
        ARGS --cplus -3
             -o "${CMAKE_CURRENT_BINARY_DIR}/${_name}_cython.cpp"
             "${_source}"
        DEPENDS "${_source}"
        COMMENT "Cythonizing ${_source}"
    )
    
    # Create the Python module
    Python_add_library(${_name} MODULE "${CMAKE_CURRENT_BINARY_DIR}/${_name}_cython.cpp")
    target_include_directories(${_name} PRIVATE ${Python_INCLUDE_DIRS})
    
    # Set output name to match Python import expectations
    set_target_properties(${_name} PROPERTIES 
        PREFIX ""
        OUTPUT_NAME ${_name}
    )
    
    if(WIN32)
        set_target_properties(${_name} PROPERTIES SUFFIX ".pyd")
    endif()
endfunction()
