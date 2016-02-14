#!/bin/bash

if [[ "$OSTYPE" == 'msys' ]]; then
    # Msys installation, thus MinGW32 (was a pain to set up on devkitpro...)
    echo \* Detected msys
    if [[ "$1" != "-l" ]]; then
        echo Building binary resource file
        windres asar.rc -O coff -o asar.res
        echo Building asar.exe
        g++ -std=c++98 -U__STRICT_ANSI__ -Wall -Werror -Wno-unused-result -Wno-uninitialized *.cpp -oasar.exe asar.res -s -O3 -fno-rtti -DINTERFACE_CLI -DFstricmp=strcasecmp -DGNUWIN32 -Dwindows -Dfixgw -DRELEASE
    fi
    if [[ "$1" != "-q" ]]; then
        echo Building asar.dll
        g++ -std=c++98 -U__STRICT_ANSI__ -Wall -Werror -Wno-unused-result -Wno-uninitialized *.cpp -oasar.dll -s -O3 -fno-rtti -DINTERFACE_LIB -Dstricmp=strcasecmp -DGNUWIN32 -Dwindows -D_WIN32 -Dfixgw -DRELEASE -fvisibility=hidden -fvisibility-inlines-hidden -shared
    fi
else
    echo \* Detected linux
    #For all Linux users out there. I don't think anything uses the Asar library on Linux, but it does no harm.
    echo Building asar
    g++ -std=c++98 -Wall -Werror -Wno-unused-result -Wno-uninitialized *.cpp -oasar -s -O3 -fno-rtti -DINTERFACE_CLI -Dstricmp=strcasecmp -Dlinux -DRELEASE
    if [[ "$1" != "-q" ]]; then
        echo Building libasar.so
        g++ -std=c++98 -Wall -Werror -Wno-unused-result -Wno-uninitialized *.cpp -olibasar.so -s -O3 -fno-rtti -DINTERFACE_LIB -Dstricmp=strcasecmp -Dlinux -DRELEASE -fvisibility=hidden -fvisibility-inlines-hidden -shared
    fi
fi
echo \* Done
