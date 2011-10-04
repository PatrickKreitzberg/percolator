# - Find Tokyo Cabinet installation.
# 
# The following are set after the configuration is done:
#
# TokyoCabinet_FOUND        - Set to True if Tokyo Cabinet was found.
# TokyoCabinet_INCLUDE_DIRS - Include directories
# TokyoCabinet_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# Tokyo Cabinet is installed.
#
# TokyoCabinet_ROOT_DIR     - Install root directory. The header files
#                             should be in
#                             ${TokyoCabinet_ROOT_DIR}/include and
#                             libraries are in
#                             ${TokyoCabinet_ROOT_DIR}/lib
#
# TokyoCabinet_INCLUDE_DIR
# TokyoCabinet_LIBRARY      - Set these two to specify include dir and
#                             libraries directly.
#

find_path(TOKYOCABINET_INCLUDE_DIR tcbdb.h )
find_library(TOKYOCABINET_LIBRARIES NAMES tokyocabinet )
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TokyoCabinet DEFAULT_MSG TOKYOCABINET_LIBRARIES TOKYOCABINET_INCLUDE_DIR)

SET (_TokyoCabinet_IN_CACHE FALSE)
IF (TokyoCabinet_INCLUDE_DIR)
  IF (NOT TokyoCabinet_VERSION)
    FIND_FILE(TokyoCabinet_TCUTIL_H tcbdb.h "${TokyoCabinet_INCLUDE_DIR}")

    IF (NOT TokyoCabinet_TCUTIL_H STREQUAL TokyoCabinet_TCUTIL_H-NOTFOUND)
      FILE(READ "${TokyoCabinet_INCLUDE_DIR}/tcbdb.h" _tokyocabinet_tcutil_h_contents)
      STRING(REGEX REPLACE ".*#define _TC_VERSION[^\"]*\"([.0-9]+)\".*" "\\1" TokyoCabinet_VERSION "${_tokyocabinet_tcutil_h_contents}")
    ENDIF (NOT TokyoCabinet_TCUTIL_H STREQUAL TokyoCabinet_TCUTIL_H-NOTFOUND)
  ENDIF (NOT TokyoCabinet_VERSION)

  INCLUDE(MacroFindPackageCheckCacheVersion)
  MACRO_FIND_PACKAGE_CHECK_CACHE_VERSION(_TokyoCabinet_IN_CACHE TokyoCabinet)
  IF(NOT _TokyoCabinet_IN_CACHE)
    SET(TokyoCabinet_INCLUDE_DIR) # remove it
  ENDIF(NOT _TokyoCabinet_IN_CACHE)
ENDIF (TokyoCabinet_INCLUDE_DIR)

IF (_TokyoCabinet_IN_CACHE)
  # in cache already
  MESSAGE(STATUS "TokyoCabinet in cache")

  SET(TokyoCabinet_FOUND TRUE)
  SET(TokyoCabinet_INCLUDE_DIRS ${TokyoCabinet_INCLUDE_DIR})
  SET(TokyoCabinet_LIBRARIES ${TokyoCabinet_LIBRARY})

ELSE (_TokyoCabinet_IN_CACHE)
  # should search it

  SET (TokyoCabinet_FOUND FALSE)

  # first pkg-config if user does not specify TokyoCabinet_INCLUDE_DIR
  IF (NOT TokyoCabinet_INCLUDE_DIR)
    FIND_PACKAGE(PkgConfig)

    IF (PkgConfig_FOUND)
      
      SET(_BACKUP_PKG_CONFIG_PATH "$ENV{PKG_CONFIG_PATH}")
      IF(TokyoCabinet_ROOT_DIR)
        SET(ENV{PKG_CONFIG_PATH} "${TokyoCabinet_ROOT_DIR}/lib/pkgconfig")
      ENDIF(TokyoCabinet_ROOT_DIR)
      PKG_CHECK_MODULES(TokyoCabinet tokyocabinet)
      SET(ENV{PKG_CONFIG_PATH} "${_BACKUP_PKG_CONFIG_PATH}")
    
      IF (TokyoCabinet_FOUND)
        SET(TokyoCabinet_INCLUDE_DIR ${TokyoCabinet_INCLUDE_DIRS})
        SET(TokyoCabinet_LIBRARY ${TokyoCabinet_LIBRARIES})
      ENDIF (TokyoCabinet_FOUND)

    ENDIF(PkgConfig_FOUND)

  ENDIF (NOT TokyoCabinet_INCLUDE_DIR)

  # then try the normal way
  IF (NOT TokyoCabinet_FOUND)
  
    IF (TokyoCabinet_ROOT_DIR)
      FIND_PATH(TokyoCabinet_INCLUDE_DIR tcbdb.h "${TokyoCabinet_ROOT_DIR}/include")
      FIND_LIBRARY(TokyoCabinet_LIBRARY tokyocabinet "${TokyoCabinet_ROOT_DIR}/lib")
    ELSE (TokyoCabinet_ROOT_DIR)
      FIND_PATH(TokyoCabinet_INCLUDE_DIR tcbdb.h)
      FIND_LIBRARY(TokyoCabinet_LIBRARY tokyocabinet)
    ENDIF (TokyoCabinet_ROOT_DIR)

    INCLUDE(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(TokyoCabinet TokyoCabinet_INCLUDE_DIR TokyoCabinet_LIBRARY)
    SET(TokyoCabinet_FOUND "${TOKYOCABINET_FOUND}")

    IF(TokyoCabinet_FOUND)
      #SET(TokyoCabinet_LIBRARIES "${TokyoCabinet_LIBRARY} -lz -lbz2 -lrt -lpthread -lm -lc")
      SET(TokyoCabinet_LIBRARIES "${TokyoCabinet_LIBRARY}")
      SET(TokyoCabinet_INCLUDE_DIRS ${TokyoCabinet_INCLUDE_DIR})
      FIND_FILE(TokyoCabinet_TCUTIL_H tcbdb.h "${TokyoCabinet_INCLUDE_DIR}/log4cpp")
      IF (NOT TokyoCabinet_TCUTIL_H STREQUAL TokyoCabinet_TCUTIL_H-NOTFOUND)
        FILE(READ "${TokyoCabinet_INCLUDE_DIR}/tcbdb.h" _tokyocabinet_tcutil_h_contents)
        STRING(REGEX REPLACE ".*#define _TC_VERSION[^\"]*\"([.0-9]+)\".*" "\\1" TokyoCabinet_VERSION "${_tokyocabinet_tcutil_h_contents}")
      ELSE (NOT TokyoCabinet_TCUTIL_H STREQUAL TokyoCabinet_TCUTIL_H-NOTFOUND)
        SET(TokyoCabinet_FOUND FALSE)
      ENDIF (NOT TokyoCabinet_TCUTIL_H STREQUAL TokyoCabinet_TCUTIL_H-NOTFOUND)
    ENDIF (TokyoCabinet_FOUND)

  ENDIF (NOT TokyoCabinet_FOUND)

  # checks version if user specified one
  SET(_details "Find TokyoCabinet: failed.")
  IF (TokyoCabinet_FOUND AND TokyoCabinet_FIND_VERSION)
    INCLUDE(MacroVersionCmp)
    MACRO_VERSION_CMP("${TokyoCabinet_VERSION}" "${TokyoCabinet_FIND_VERSION}" _cmp_result)
    IF (_cmp_result LESS 0)
      SET(_details "${_details} ${TokyoCabinet_FIND_VERSION} required but ${TokyoCabinet_VERSION} found")
      SET(TokyoCabinet_FOUND FALSE)
    ELSEIF (TokyoCabinet_FIND_VERSION_EXACT AND _cmp_result GREATER 0)
      SET(_details "${_details} exact ${TokyoCabinet_FIND_VERSION} required but ${TokyoCabinet_VERSION} found")
      SET(TokyoCabinet_FOUND FALSE)
    ENDIF (_cmp_result LESS 0)
  ENDIF (TokyoCabinet_FOUND AND TokyoCabinet_FIND_VERSION)

#   IF (NOT TokyoCabinet_FOUND)
#     IF (TokyoCabinet_FIND_REQUIRED)
#       MESSAGE(FATAL_ERROR "${_details}")
#     ELSEIF (NOT TokyoCabinet_FIND_QUIETLY)
#       MESSAGE(STATUS "${_details}")
#     ENDIF (TokyoCabinet_FIND_REQUIRED)
#   ENDIF (NOT TokyoCabinet_FOUND)

ENDIF (_TokyoCabinet_IN_CACHE)

MARK_AS_ADVANCED(
  TokyoCabinet_ROOT_DIR
  TokyoCabinet_LIBRARY
  TokyoCabinet_INCLUDE_DIR
  TokyoCabinet_TCUTIL_H
  TokyoCabinet_LIBRARIES
)


