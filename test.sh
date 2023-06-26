#!/usr/bin/env bash

__architecture=$1

if [ -z $__architecture ]; then
    echo "No architecture specified, testing for all supported architectures"

    ./test.sh x86_64
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ./test.sh arm64
        ./test.sh 'arm64;x86_64'
    fi
    exit 0
fi

__architecture_directory=${__architecture/;/_}

echo "Testing cimgui for $OSTYPE $__architecture in $__architecture_directory"

__executable_name="cimgui_test"
__configuration_dir_debug=""
__configuration_dir_release=""
if [[ "$GITHUB_OS" == "windows-latest" ]]; then
    __executable_name="$__executable_name.exe"
    __configuration_dir_debug="Debug/"
    __configuration_dir_release="Release/"
fi

echo "Begin Debug test
--------------------------------------------------------------------------------"
./cmake-build-debug/$__architecture_directory/$__configuration_dir_debug$__executable_name
echo "--------------------------------------------------------------------------------
End Debug Test
"

echo "Begin Release test
--------------------------------------------------------------------------------"
./cmake-build-release/$__architecture_directory/$__configuration_dir_release$__executable_name
echo "--------------------------------------------------------------------------------
End Release Test"
