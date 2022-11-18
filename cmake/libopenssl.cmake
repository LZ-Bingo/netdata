# openssl build from source

set(LIBOPENSSL_ROOT ${CMAKE_SOURCE_DIR}/depend)

set(ENV{PKG_CONFIG_PATH} "${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable/install/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
if(NOT EXISTS ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable)
    message("-- install openssl begin.")

    set(ENV{CC} "${CMAKE_C_COMPILER}")
    set(ENV{CXX} "${CMAKE_CXX_COMPILER}")
    set(ENV{AR} "${CMAKE_AR}")
    set(ENV{RANLIB} "${CMAKE_RANLIB}")

    execute_process(COMMAND unzip ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable.zip WORKING_DIRECTORY ${LIBOPENSSL_ROOT})
    execute_process(COMMAND ./config no-asm no-shared --prefix=${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable/install WORKING_DIRECTORY ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable)
    execute_process(COMMAND sed -i "s/ -m64/  /g" ./Makefile WORKING_DIRECTORY ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable)
    execute_process(COMMAND make -j8 WORKING_DIRECTORY  ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable)
    execute_process(COMMAND make install WORKING_DIRECTORY ${LIBOPENSSL_ROOT}/openssl-OpenSSL_1_1_0-stable)
    message("-- install openssl end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBOPENSSL_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- libopenssl already install, skip.")
endif()