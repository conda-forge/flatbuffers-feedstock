#!/bin/bash

set -e

mkdir build-cmake
pushd build-cmake

cmake \
  -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -GNinja \
  ..
ninja
ctest
ninja install

popd
