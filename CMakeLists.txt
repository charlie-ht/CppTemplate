cmake_minimum_required(VERSION 3.3)

project(Template)

if (NOT CMAKE_BUILD_TYPE)
    message(WARNING "No CMAKE_BUILD_TYPE value specified, defaulting to RelWithDebInfo.")
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build." FORCE)
else ()
    message(STATUS "The CMake build type is: ${CMAKE_BUILD_TYPE}")
endif ()


set(PORT "WPE")

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
# -----------------------------------------------------------------------------
# Determine the compiler
# -----------------------------------------------------------------------------
if (${CMAKE_CXX_COMPILER_ID} STREQUAL "Clang" OR ${CMAKE_CXX_COMPILER_ID} STREQUAL "AppleClang")
    set(COMPILER_IS_CLANG ON)
endif ()

if (${CMAKE_CXX_COMPILER_ID} STREQUAL "GNU")
  # not a useful check for us, but keeping it as an example...
    if (${CMAKE_CXX_COMPILER_VERSION} VERSION_LESS "6.0.0")
        message(FATAL_ERROR "Your compiler is old!")
    endif ()
endif ()

if (CMAKE_COMPILER_IS_GNUCXX OR COMPILER_IS_CLANG)
    set(COMPILER_IS_GCC_OR_CLANG ON)
endif ()

if (MSVC AND COMPILER_IS_CLANG)
    set(COMPILER_IS_CLANG_CL ON)
endif ()



# -----------------------------------------------------------------------------
# Determine the target processor
# -----------------------------------------------------------------------------
# Use MSVC_CXX_ARCHITECTURE_ID instead of CMAKE_SYSTEM_PROCESSOR when defined,
# since the later one just resolves to the host processor on Windows.
if (MSVC_CXX_ARCHITECTURE_ID)
    string(TOLOWER ${MSVC_CXX_ARCHITECTURE_ID} LOWERCASE_CMAKE_SYSTEM_PROCESSOR)
else ()
    string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} LOWERCASE_CMAKE_SYSTEM_PROCESSOR)
endif ()
if (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "(^aarch64|^arm64)")
    set(WTF_CPU_ARM64 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "^arm")
    set(WTF_CPU_ARM 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "^mips64")
    set(WTF_CPU_MIPS64 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "^mips")
    set(WTF_CPU_MIPS 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "(x64|x86_64|amd64)")
    set(WTF_CPU_X86_64 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "(i[3-6]86|x86)")
    set(WTF_CPU_X86 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "ppc")
    set(WTF_CPU_PPC 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64")
    set(WTF_CPU_PPC64 1)
elseif (LOWERCASE_CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64le")
    set(WTF_CPU_PPC64LE 1)
else ()
    set(WTF_CPU_UNKNOWN 1)
endif ()


# -----------------------------------------------------------------------------
# Determine the operating system
# -----------------------------------------------------------------------------
if (UNIX)
    if (APPLE)
        set(WTF_OS_MAC_OS_X 1)
    elseif (CMAKE_SYSTEM_NAME MATCHES "Linux")
        set(WTF_OS_LINUX 1)
    else ()
        set(WTF_OS_UNIX 1)
    endif ()
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(WTF_OS_WINDOWS 1)
elseif (CMAKE_SYSTEM_NAME MATCHES "Fuchsia")
    set(WTF_OS_FUCHSIA 1)
else ()
    message(FATAL_ERROR "Unknown OS '${CMAKE_SYSTEM_NAME}'")
endif ()



set(WTF_LIBRARY_TYPE STATIC)
set(CMAKE_POSITION_INDEPENDENT_CODE True)

    include(CheckCCompilerFlag)
    include(CheckCXXCompilerFlag)
    include(CheckCXXSourceCompiles)
    include(CheckFunctionExists)
    include(CheckIncludeFile)
    include(CheckSymbolExists)
    include(CheckStructHasMember)
    include(CheckTypeSize)
    include(CMakeDependentOption)
    include(CMakeParseArguments)
    include(ProcessorCount)

    include(WebKitPackaging)
    include(WebKitMacros)
    include(WebKitFS)
    include(WebKitCCache)
    include(WebKitCompilerFlags)
    include(WebKitFeatures)

    include(OptionsCommon)
    include(OptionsWPE)
#port
find_package(ICU REQUIRED)
find_package(GLIB 2.40.0 REQUIRED COMPONENTS gio gio-unix gobject gthread gmodule)
find_package(ZLIB REQUIRED)


CREATE_CONFIGURATION_HEADER()
WEBKIT_OPTION_BEGIN()

add_subdirectory(bmalloc)
add_subdirectory(WTF)

set(DirectoryLister_SOURCES
  EntryPoint.cpp
  )

set(DirectoryLister_LIBRARIES
  WTF
  )

add_executable(Template ${DirectoryLister_SOURCES})
target_include_directories(Template SYSTEM PUBLIC ${GLIB_INCLUDE_DIRS})
target_link_libraries(Template ${DirectoryLister_LIBRARIES})
