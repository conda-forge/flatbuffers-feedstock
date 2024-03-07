#!/bin/bash

set -e

if [[ "${target_platform}" == "osx-64" ]]; then
  export CFLAGS="${CFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

sed -i.bak 's/-Werror //g' CMakeLists.txt

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" == "1" ]]; then
  (
    mkdir -p build-host
    pushd build-host

    export CC=$CC_FOR_BUILD
    export CXX=$CXX_FOR_BUILD
    export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}
    export PKG_CONFIG_PATH=${PKG_CONFIG_PATH//$PREFIX/$BUILD_PREFIX}
    export CMAKE_ARGS=${CMAKE_ARGS//$PREFIX/$BUILD_PREFIX}

    # Unset them as we're ok with builds that are either slow or non-portable
    unset CFLAGS
    unset CXXFLAGS

    cmake ${CMAKE_ARGS} ..  \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$BUILD_PREFIX \
      -DCMAKE_INSTALL_PREFIX=$BUILD_PREFIX \
      -DFLATBUFFERS_OSX_BUILD_UNIVERSAL=OFF
    ninja install
    popd
  )

  CMAKE_ARGS="${CMAKE_ARGS} -DFLATBUFFERS_BUILD_TESTS=OFF -DFLATBUFFERS_FLATC_EXECUTABLE=$BUILD_PREFIX/bin/flatc"
fi

mkdir build-cmake
pushd build-cmake

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
