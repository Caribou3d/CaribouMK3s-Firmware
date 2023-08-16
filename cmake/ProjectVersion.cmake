#
# This file is responsible for setting the following variables:
#
# ~~~
# BUILD_NUMBER (1035)
# PROJECT_VERSION (4.0.3)
# PROJECT_VERSION_FULL (4.0.3-BETA+1035.PR111.B4)
# PROJECT_VERSION_SUFFIX (-BETA+1035.PR111.B4)
# PROJECT_VERSION_SUFFIX_SHORT (+1035)
# PROJECT_VERSION_TIMESTAMP (unix timestamp)
#
# The `PROJECT_VERSION` variable is set as soon as the file is included.
# To set the rest, the function `resolve_version_variables` has to be called.
#
# ~~~

FILE(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/Firmware/Configuration.h CFG_VER_DATA REGEX "#define FW_[A-Z]+ ([0-9]+)" )
LIST(GET CFG_VER_DATA 0 PROJECT_VERSION_MAJOR)
LIST(GET CFG_VER_DATA 1 PROJECT_VERSION_MINOR)
LIST(GET CFG_VER_DATA 2 PROJECT_VERSION_REV)
STRING(REGEX MATCH "FW_MAJOR ([0-9]+)" PROJECT_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
SET(PROJECT_VERSION_MAJOR  "${CMAKE_MATCH_1}")

STRING(REGEX MATCH "FW_MINOR ([0-9]+)" PROJECT_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
SET(PROJECT_VERSION_MINOR  ${CMAKE_MATCH_1})

STRING(REGEX MATCH "FW_REVISION +([0-9]+)" PROJECT_VERSION_REV "${PROJECT_VERSION_REV}")
SET(PROJECT_VERSION_REV  ${CMAKE_MATCH_1})

SET(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_REV}")


function(resolve_version_variables)
  # BUILD_NUMBER
  if(NOT BUILD_NUMBER)
    git_count_parent_commits(BUILD_NUMBER)
    set(ERRORS "GIT-NOTFOUND" "HEAD-HASH-NOTFOUND")
    if(BUILD_NUMBER IN_LIST ERRORS)
      message(WARNING "Failed to resolve build number: ${BUILD_NUMBER}. Setting to zero.")
      set(BUILD_NUMBER "0")
    endif()
    set(BUILD_NUMBER
        ${BUILD_NUMBER}
        PARENT_SCOPE
        )
  endif()

  # PROJECT_VERSION_SUFFIX
  if(PROJECT_VERSION_SUFFIX STREQUAL "<auto>")
    # TODO: set to +<sha>.dirty?.debug?
    set(PROJECT_VERSION_SUFFIX "+${BUILD_NUMBER}.LOCAL")
    set(PROJECT_VERSION_SUFFIX
        "+${BUILD_NUMBER}.LOCAL"
        PARENT_SCOPE
        )
  endif()

  # PROJECT_VERSION_SUFFIX_SHORT
  if(PROJECT_VERSION_SUFFIX_SHORT STREQUAL "<auto>")
    set(PROJECT_VERSION_SUFFIX_SHORT
        "+${BUILD_NUMBER}"
        PARENT_SCOPE
        )
  endif()

  # PROJECT_VERSION_FULL
  set(PROJECT_VERSION_FULL
      "${PROJECT_VERSION}${PROJECT_VERSION_SUFFIX}"
      PARENT_SCOPE
      )

  # PROJECT_VERSION_TIMESTAMP
  if(NOT PROJECT_VERSION_TIMESTAMP)
    git_head_commit_timestamp(timestamp)
    set(PROJECT_VERSION_TIMESTAMP
        "${timestamp}"
        PARENT_SCOPE
        )
  endif()

endfunction()
