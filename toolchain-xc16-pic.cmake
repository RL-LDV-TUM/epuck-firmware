# Specify search path for xc16 compiler
set(XC16_SEARCH_PATH
    /opt/microchip/xc16/v1.22
    /usr/local/share/microchip/xc16/v1.22
    )

# Mandatory target system name, e.g. "Linux", for embedded fw, use "Generic"
set(CMAKE_SYSTEM_NAME Generic)
# Will be supplied via -mcpu to gcc, use the corresponding µC id
set(CMAKE_SYSTEM_PROCESSOR 30F6014A)


foreach(XC16_PATH ${XC16_SEARCH_PATH})
    if(EXISTS ${XC16_PATH}/bin/xc16-gcc)
        # specify compiler
        set(CMAKE_C_COMPILER ${XC16_PATH}/bin/xc16-gcc)

        # installation path of compiler environment (searched for includes, etc.)
        set(CMAKE_FIND_ROOT_PATH ${XC16_PATH})
        break()
     endif()
endforeach()

# The next block ensures that cmake only uses the toolchain files and 
# not libraries and headers from the build machine
#
# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
