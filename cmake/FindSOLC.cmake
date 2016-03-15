include(FindPackageHandleStandardArgs)

if(NOT SOLC_BIN)
    find_program(SOLC_BIN "solc")
endif()

if(NOT SOLC_VERSION)
    execute_process(COMMAND ${SOLC_BIN} --version OUTPUT_VARIABLE SOLC_VERSION)
    string(REGEX MATCH "([0-9\\.]+)" SOLC_VERSION ${SOLC_VERSION})
endif()

FIND_PACKAGE_HANDLE_STANDARD_ARGS(SOLC DEFAULT_MSG SOLC_BIN SOLC_VERSION)
