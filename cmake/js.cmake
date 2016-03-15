configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/js/package.json ${CMAKE_CURRENT_BINARY_DIR}/npm/bitprofile-contract/package.json)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/js/BitProfile.js.in ${CMAKE_CURRENT_BINARY_DIR}/npm/bitprofile-contract/BitProfile.js)
