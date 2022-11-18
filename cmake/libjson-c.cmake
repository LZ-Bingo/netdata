# json-c build from source

set(LIB_JSON_C_ROOT ${CMAKE_SOURCE_DIR}/depend)

# workaround
set(NETDATA_COMMON_INCLUDE_DIRS ${NETDATA_COMMON_INCLUDE_DIRS} "${LIB_JSON_C_ROOT}/json-c-json-c-0.15/install/usr/local/include")
set(NETDATA_COMMON_LIBRARY_DIRS ${NETDATA_COMMON_LIBRARY_DIRS} "${LIB_JSON_C_ROOT}/json-c-json-c-0.15/install/usr/local/lib")
set(NETDATA_COMMON_LIBRARIES ${NETDATA_COMMON_LIBRARIES} "json-c")

if(NOT EXISTS ${LIB_JSON_C_ROOT}/json-c-json-c-0.15)
    message("-- install json-c begin.")
    execute_process(COMMAND unzip ${LIB_JSON_C_ROOT}/json-c-json-c-0.15.zip WORKING_DIRECTORY ${LIB_JSON_C_ROOT})
    file(MAKE_DIRECTORY ${LIB_JSON_C_ROOT}/json-c-json-c-0.15/build)
    execute_process(COMMAND cmake ..
                    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} 
                    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}  
                    WORKING_DIRECTORY ${LIB_JSON_C_ROOT}/json-c-json-c-0.15/build)
    execute_process(COMMAND make -j8  WORKING_DIRECTORY  ${LIB_JSON_C_ROOT}/json-c-json-c-0.15/build)
    execute_process(COMMAND make install DESTDIR=${LIB_JSON_C_ROOT}/json-c-json-c-0.15/install  WORKING_DIRECTORY  ${LIB_JSON_C_ROOT}/json-c-json-c-0.15/build)
    message("-- install json-c end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIB_JSON_C_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- libjson-c already install, skip.")
endif()