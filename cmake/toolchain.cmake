set(HOST "aarch64-linux")
set(CMAKE_C_COMPILER "${HOST}-gcc")
set(CMAKE_CXX_COMPILER "${HOST}-g++")
set(CMAKE_AR "${HOST}-ar")
set(CMAKE_RANLIB "${HOST}-ranlib")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

# workaround
add_definitions(-DENABLE_DBENGINE=1) 
