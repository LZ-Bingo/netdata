# openssl build from source

set(LIBJUDY_ROOT ${CMAKE_SOURCE_DIR}/depend)

# workaround
set(CMAKE_REQUIRED_INCLUDES "${CMAKE_SOURCE_DIR}/depend/judy-1.0.5/install/include")
set(CMAKE_REQUIRED_FLAGS "-L${CMAKE_SOURCE_DIR}/depend/judy-1.0.5/install/lib")
include_directories("${CMAKE_SOURCE_DIR}/depend/judy-1.0.5/install/include")
set(NETDATA_COMMON_LIBRARY_DIRS ${NETDATA_COMMON_LIBRARY_DIRS} "${CMAKE_SOURCE_DIR}/depend/judy-1.0.5/install/lib")

if(NOT EXISTS ${LIBJUDY_ROOT}/judy-1.0.5)
    message("-- install openssl begin.")

    set(ENV{CC} "${CMAKE_C_COMPILER}")
    set(ENV{CXX} "${CMAKE_CXX_COMPILER}")
    set(ENV{AR} "${CMAKE_AR}")
    set(ENV{RANLIB} "${CMAKE_RANLIB}")

    execute_process(COMMAND tar zxvf ${LIBJUDY_ROOT}/Judy-1.0.5.tar.gz WORKING_DIRECTORY ${LIBJUDY_ROOT})

    # workaround : make host aarch64 recognizable
    execute_process(COMMAND sed -i "239s/1750a /1750a \| aarch64 /g" ./config.sub WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
    execute_process(COMMAND sed -i "374s/)/ | aarch64\-\* )/g" ./config.sub WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)

    execute_process(COMMAND ./configure --host=${HOST} --prefix=${LIBJUDY_ROOT}/judy-1.0.5/install WORKING_DIRECTORY ${LIBUUID_ROOT}/judy-1.0.5)

    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        execute_process(COMMAND sed -i "563s/\$(CC)/gcc/g" ./src/JudyL/Makefile WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
        execute_process(COMMAND sed -i "563s/\$(CC)/gcc/g" ./src/Judy1/Makefile WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
    else()
        execute_process(COMMAND sed -i "563s/\$(CC)/gcc -m32/g" ./src/JudyL/Makefile WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
        execute_process(COMMAND sed -i "563s/\$(CC)/gcc -m32/g" ./src/Judy1/Makefile WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
    endif()
    execute_process(COMMAND make -j8 WORKING_DIRECTORY  ${LIBJUDY_ROOT}/judy-1.0.5)
    execute_process(COMMAND make install WORKING_DIRECTORY ${LIBJUDY_ROOT}/judy-1.0.5)
    message("-- install openssl end.")

    # remove dynamic lib
    file(GLOB_RECURSE DYNAMIC_LIBS "${LIBJUDY_ROOT}/*.so*")
    foreach(DYNAMIC_LIB ${DYNAMIC_LIBS})
        file(REMOVE ${DYNAMIC_LIB})
    endforeach()
else()
    message("-- libopenssl already install, skip.")
endif()