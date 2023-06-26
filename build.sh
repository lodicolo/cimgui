#!/usr/bin/env bash

__architecture=$1

if [ -z $__architecture ]; then
    echo "No architecture specified, building for all supported architectures"

    ./build.sh x86_64
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ./build.sh arm64
        ./build.sh 'arm64;x86_64'
    fi
    exit 0
fi

__architecture_directory=${__architecture/;/_}

__extra_args=""

if [[ "$OSTYPE" == "darwin"* ]]; then
    __extra_args="$__extra_args -DCMAKE_OSX_ARCHITECTURES=$__architecture -DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
fi

echo "Building cimgui for $OSTYPE $__architecture in $__architecture_directory"

cmake -S . -B cmake-build-debug/$__architecture_directory -DCIMGUI_TEST=1 -DCMAKE_BUILD_TYPE=Debug $__extra_args
cmake --build cmake-build-debug/$__architecture_directory --config Debug # Keeping "parity" with the release version of the command

cmake -S . -B cmake-build-release/$__architecture_directory -DCIMGUI_TEST=1 -DCMAKE_BUILD_TYPE=Release $__extra_args
cmake --build cmake-build-release/$__architecture_directory --config Release # Need to specify --config Release to accommodate Windows
