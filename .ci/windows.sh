#!/bin/sh -ex

mkdir build && cd build

if [ "$GITHUB_REF_TYPE" == "tag" ]; then
	export EXTRA_CMAKE_FLAGS=(-DENABLE_QT_UPDATE_CHECKER=ON)
fi

cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_DISCORD_RPC=OFF \
	-DENABLE_WEB_SERVICE=OFF \
	-DENABLE_GDBSTUB=OFF \
	-DUSE_SYSTEM_QT=ON \
	-DQt5_DIR=D:\a\azahar\azahar\Qt-Win-Static\Qt\Qt-5.15.19\lib\cmake\Qt5 \
	"${EXTRA_CMAKE_FLAGS[@]}"
ninja
ninja bundle
strip -s bundle/*.exe

ccache -s -v

ctest -VV -C Release || echo "::error ::Test error occurred on Windows build"
