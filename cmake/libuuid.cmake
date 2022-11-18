# uuid build from source
set(LIBUUID_ROOT ${CMAKE_SOURCE_DIR}/depend)

set(ENV{PKG_CONFIG_PATH} "${LIBUUID_ROOT}/libuuid-1.0.3/install/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
if(NOT EXISTS ${LIBUUID_ROOT}/libuuid-1.0.3)
    message("-- install uuid begin.")
    execute_process(COMMAND tar zxvf ${LIBUUID_ROOT}/libuuid-1.0.3.tar.gz -C ${LIBUUID_ROOT})
    execute_process(COMMAND ./configure --host=${HOST} --prefix=${LIBUUID_ROOT}/libuuid-1.0.3/install WORKING_DIRECTORY ${LIBUUID_ROOT}/libuuid-1.0.3)
    execute_process(COMMAND make -j8 WORKING_DIRECTORY ${LIBUUID_ROOT}/libuuid-1.0.3)
    execute_process(COMMAND make install WORKING_DIRECTORY ${LIBUUID_ROOT}/libuuid-1.0.3)
    message("-- install uuid end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBUUID_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()

    # workaround
    execute_process(COMMAND sed -i "10s/uuid/uuid \-I\$\{includedir\}/g" ./install/lib/pkgconfig/uuid.pc WORKING_DIRECTORY ${LIBUUID_ROOT}/libuuid-1.0.3)
    
else()
    message("-- libuuid already install, skip.")
endif()