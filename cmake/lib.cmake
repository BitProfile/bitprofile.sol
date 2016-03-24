
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp/BitProfile.hpp.in ${CMAKE_CURRENT_BINARY_DIR}/cpp/include/bitprofile/ContractCode.hpp)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/cpp/BitProfile.cpp.in ${CMAKE_CURRENT_BINARY_DIR}/cpp/ContractCode.cpp)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/cpp/include/bitprofile)
add_library(bitprofile-contract STATIC ${CMAKE_CURRENT_BINARY_DIR}/cpp/ContractCode.cpp)


install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cpp/include DESTINATION include)
install (TARGETS bitprofile-contract ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
