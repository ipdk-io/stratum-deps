# Identify default CXX standard
#
# Copyright 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

function(get_cplusplus_standard CXX_STANDARD)

  function(get_cplusplus CPLUSPLUS)

    set(tempfile ${CMAKE_CURRENT_BINARY_DIR}/tempcode/get-cxx-version.cxx)

    file(WRITE ${tempfile}
      "#include <iostream>\n"
      "int main() {\n"
      "  std::cout << __cplusplus << std::endl;\n"
      "  return 0;\n"
      "}\n"
    )

    try_run(
      run_status
      build_status
      ${CMAKE_CURRENT_BINARY_DIR}
      ${tempfile}
      RUN_OUTPUT_VARIABLE cplusplus
    )

    if(run_status EQUAL FAILED_TO_RUN OR NOT build_status)
      set(_default "201402")
      message(WARNING
        "Cannot get _cplusplus value from compiler. Defaulting to ${_default}."
      )
      set(cplusplus ${_default})
    endif()

    string(STRIP "${cplusplus}" cplusplus)

    set(${CPLUSPLUS} ${cplusplus} PARENT_SCOPE)
  endfunction()

  get_cplusplus(cplusplus)

  if(DEFINED cplusplus)
    # see https://en.cppreference.com/w/cpp/preprocessor/replace#Predefined_macros
    # for constants
    if(cplusplus EQUAL 201103)
      set(cxx_standard 11)
    elseif(cplusplus EQUAL 201402)
      set(cxx_standard 14)
    elseif(cplusplus EQUAL 201703)
      set(cxx_standard 17)
    else()
      message(WARNING "_cplusplus value (${cplusplus}) not recognized")
    endif()
  endif()

  set(${CXX_STANDARD} ${cxx_standard} PARENT_SCOPE)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
endfunction()
