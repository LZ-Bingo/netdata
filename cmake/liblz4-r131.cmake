# lz4 build from source

set(LIBLZ4_ROOT ${CMAKE_SOURCE_DIR}/depend)

set(ENV{PKG_CONFIG_PATH} "${LIBLZ4_ROOT}/lz4-r131/install/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
if(NOT EXISTS ${LIBLZ4_ROOT}/lz4-r131)
    message("-- install lz4 begin.")
    set(ENV{CC} "${CMAKE_C_COMPILER}")
    execute_process(COMMAND unzip ${LIBLZ4_ROOT}/lz4-r131.zip WORKING_DIRECTORY ${LIBLZ4_ROOT})
    execute_process(COMMAND make "PREFIX=${LIBLZ4_ROOT}/lz4-r131/install" install WORKING_DIRECTORY  ${LIBLZ4_ROOT}/lz4-r131)
    message("-- install lz4 end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBLZ4_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- liblz4 already install, skip.")
endif()