#!/bin/bash

set -e

sed -i.bak 's/-Werror //g' CMakeLists.txt

mkdir build-cmake
pushd build-cmake

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DFLATBUFFERS_BUILD_TESTS=OFF"
fi

cmake ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DFLATBUFFERS_OSX_BUILD_UNIVERSAL=OFF \
  -DFLATBUFFERS_BUILD_SHAREDLIB=ON \
  -GNinja \
  ..

ninja
ninja install
popd

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  ./build-cmake/flattests
fi
