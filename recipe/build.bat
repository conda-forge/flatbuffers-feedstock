mkdir build
pushd build

cmake %CMAKE_ARGS% -GNinja -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" -DFLATBUFFERS_BUILD_TESTS=OFF "%SRC_DIR%" -DCMAKE_BUILD_TYPE=Release
cmake --build . --target install
