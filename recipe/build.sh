#!/bin/bash

set -e

mkdir build-cmake
pushd build-cmake

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
