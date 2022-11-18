# zip build from source

set(LIBZIP_ROOT ${CMAKE_SOURCE_DIR}/depend)

set(ENV{PKG_CONFIG_PATH} "${LIBZIP_ROOT}/zlib-1.2.9/install/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
if(NOT EXISTS ${LIBZIP_ROOT}/zlib-1.2.9)
    message("-- install zip begin.")

    set(ENV{CC} "${CMAKE_C_COMPILER}")
    set(ENV{CXX} "${CMAKE_CXX_COMPILER}")
    set(ENV{AR} "${CMAKE_AR}")
    set(ENV{RANLIB} "${CMAKE_RANLIB}")

    execute_process(COMMAND unzip ${LIBZIP_ROOT}/zlib-1.2.9.zip WORKING_DIRECTORY ${LIBZIP_ROOT})
    execute_process(COMMAND ./configure --prefix=${LIBZIP_ROOT}/zlib-1.2.9/install WORKING_DIRECTORY ${LIBZIP_ROOT}/zlib-1.2.9)
    execute_process(COMMAND make -j8 WORKING_DIRECTORY  ${LIBZIP_ROOT}/zlib-1.2.9)
    execute_process(COMMAND make install WORKING_DIRECTORY ${LIBZIP_ROOT}/zlib-1.2.9)
    message("-- install zip end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBZIP_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- libzip already install, skip.")
endif()