# Find Cython
#
# This module defines
#  CYTHON_EXECUTABLE
#  CYTHON_FOUND

find_program(CYTHON_EXECUTABLE NAMES cython cython.bat cython3)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cython DEFAULT_MSG CYTHON_EXECUTABLE)

mark_as_advanced(CYTHON_EXECUTABLE)
