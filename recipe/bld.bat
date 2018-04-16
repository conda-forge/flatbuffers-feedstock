mkdir build
pushd build

cmake -G "%CMAKE_GENERATOR%" -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" -DFLATBUFFERS_BUILD_TESTS=OFF "%SRC_DIR%"
cmake --build . --target install --config Release
