find_package(SOLC REQUIRED)

set(BITPROFILE_SOL ${CMAKE_CURRENT_BINARY_DIR}/bitprofile.sol)
set(SOL_FILES 
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Auth.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/AddressAuth.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/ProfileInterface.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/ProfileFactoryInterface.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Profile.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/ProfileFactory.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Owned.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/RegistrarContextInterface.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/RegistrarInterface.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/RegistrarFactoryInterface.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/RegistrarContext.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Registrar.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/RegistrarFactory.sol
    ${CMAKE_CURRENT_SOURCE_DIR}/src/MasterRegistrar.sol
)

file(WRITE ${BITPROFILE_SOL} "")

foreach(SRC_FILE ${SOL_FILES})
    file(READ ${SRC_FILE} CONTENTS)
    file(APPEND ${BITPROFILE_SOL} "${CONTENTS}")
endforeach()


execute_process(COMMAND ${SOLC_BIN} --bin --abi --userdoc --devdoc --optimize --optimize-runs=10000 -o ${CMAKE_CURRENT_BINARY_DIR}/obj ${BITPROFILE_SOL})

file(GLOB BIN_FILES ${CMAKE_CURRENT_BINARY_DIR}/obj/*.bin)

foreach(BIN_FILE ${BIN_FILES})

    get_filename_component(Contract_Name ${BIN_FILE} NAME_WE)

    file(READ ${BIN_FILE} Contract_Code)
    file(READ ${CMAKE_CURRENT_SOURCE_DIR}/src/${Contract_Name}.sol Contract_Source)
    string(REGEX REPLACE "[ ]+" " " Contract_Source "${Contract_Source}")
    string(REGEX REPLACE "(\n)+" "\\n" Contract_Source "${Contract_Source}")
    string(REPLACE "\n" "\\n" Contract_Source "${Contract_Source}")
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.abi Contract_ABI)
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.docuser Contract_DOCUSER)
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.docdev Contract_DOCDEV)
    string(REPLACE "\n" "" Contract_DOCUSER ${Contract_DOCUSER})
    string(REPLACE "\n" "" Contract_DOCDEV ${Contract_DOCDEV})

    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/js/Contract.json.in ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.json)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp/Contract.hpp.in ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.hpp)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp/Contract.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.cpp)

    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.json Contract_JSON)
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.hpp Contract_HPP)
    file(READ ${CMAKE_CURRENT_BINARY_DIR}/obj/${Contract_Name}.cpp Contract_CPP)

    list(APPEND BitProfile_JSON ${Contract_JSON})
    list(APPEND BitProfile_CPP ${Contract_CPP})
    list(APPEND BitProfile_HPP ${Contract_HPP})

endforeach()

string(REPLACE "\n;" ",\n" BitProfile_JSON "${BitProfile_JSON}")
string(REPLACE "\n;" "" BitProfile_CPP "${BitProfile_CPP}")
string(REPLACE "\n;" "" BitProfile_HPP "${BitProfile_HPP}")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/js/BitProfile.json.in ${CMAKE_CURRENT_BINARY_DIR}/BitProfile.json)

