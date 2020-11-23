#!/bin/bash

set -e

sed -i.bak 's/-Werror //g' CMakeLists.txt

mkdir build-cmake
pushd build-cmake

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DFLATBUFFERS_BUILD_TESTS=OFF"
fi

cmake ${CMAKE_ARGS} \
  -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -GNinja \
  ..

ninja
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  ctest
fi
ninja install

popd
