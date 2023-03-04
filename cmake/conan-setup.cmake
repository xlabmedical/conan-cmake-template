macro(set_conan_deps)
# Check if conan.cmake exists in binary directory
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  if(EXISTS "${CMAKE_SOURCE_DIR}/conan.cmake")
    file(COPY "${CMAKE_SOURCE_DIR}/conan.cmake" DESTINATION "${CMAKE_BINARY_DIR}")
  else()
    include(FetchContent)
    # Download from XLAB github repo
    FetchContent_Declare(conan_cmake 
	  GIT_REPOSITORY https://github.com/xlabmedical/conan-cmake
      GIT_TAG b08deca75af4f520f3563c055fd19dd2a959871c
    )
    FetchContent_MakeAvailable(conan_cmake)
    file(COPY "${conan_cmake_SOURCE_DIR}/conan.cmake" DESTINATION "${CMAKE_BINARY_DIR}")
  endif()
endif()

include("${CMAKE_BINARY_DIR}/conan.cmake")
conan_add_remotes()


# Scan for conan recipe in the root source directory.
# If the conan recipe ('conanfile.txt' or 'conanfile.py') doesn't exist in
# the root source directory, then the process will stop and return an error.
set(CONAN_RECIPE_FILE "")
if(EXISTS "${CMAKE_SOURCE_DIR}/conanfile.py")
	set(CONAN_RECIPE_FILE "${CMAKE_SOURCE_DIR}/conanfile.py")
endif()
if(CONAN_RECIPE_FILE STREQUAL "")
  message(FATAL_ERROR "Conan recipe doesn't exist in the root source directory...")
endif()



conan_cmake_autodetect(settings)
# Remove cppstd entry from autodetected settings
message(STATUS "Conan: Settings ${settings}")
string(REPLACE "compiler.cppstd=${CMAKE_CXX_STANDARD}" "" settings "${settings}")
message(STATUS "Conan: Settings ${settings}")
conan_cmake_install(
	PATH_OR_REFERENCE "${CONAN_RECIPE_FILE}"
	OUTPUT_FOLDER     "${CMAKE_BINARY_DIR}"
	UPDATE
	CONF              tools.cmake.cmaketoolchain:generator="${CMAKE_GENERATOR}"
	SETTINGS          ${settings}
)
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${CMAKE_CURRENT_BINARY_DIR})
if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/conan_paths.cmake)
	include(${CMAKE_CURRENT_BINARY_DIR}/conan_paths.cmake)
endif()
endmacro()
