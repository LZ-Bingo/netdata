# uv build from source

set(LIBUV_ROOT ${CMAKE_SOURCE_DIR}/depend)

set(ENV{PKG_CONFIG_PATH} "${LIBUV_ROOT}/libuv-1.42.0/install/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
if(NOT EXISTS ${LIBUV_ROOT}/libuv-1.42.0)
    message("-- install uv begin.")
    execute_process(COMMAND unzip ${LIBUV_ROOT}/libuv-1.42.0.zip WORKING_DIRECTORY ${LIBUV_ROOT})
    execute_process(COMMAND sh autogen.sh WORKING_DIRECTORY ${LIBUV_ROOT}/libuv-1.42.0)
    execute_process(COMMAND ./configure --host=${HOST} --prefix=${LIBUV_ROOT}/libuv-1.42.0/install WORKING_DIRECTORY ${LIBUV_ROOT}/libuv-1.42.0)
    execute_process(COMMAND make -j8 WORKING_DIRECTORY  ${LIBUV_ROOT}/libuv-1.42.0)
    execute_process(COMMAND make install WORKING_DIRECTORY ${LIBUV_ROOT}/libuv-1.42.0)
    message("-- install uv end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBUV_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- libuv already install, skip.")
endif()