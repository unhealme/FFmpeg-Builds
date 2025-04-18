#!/bin/bash

SCRIPT_REPO="https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git"
SCRIPT_COMMIT="16f7d73e0b45c473e903e46981ed0b91efc4c091"

ffbuild_enabled() {
    [[ $TARGET == mac* ]] && return -1
    [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" amf
    cd amf

    mkdir -p "$FFBUILD_PREFIX"/include
    mv amf/public/include "$FFBUILD_PREFIX"/include/AMF
}

ffbuild_configure() {
    echo --enable-amf
}

ffbuild_unconfigure() {
    [[ $TARGET == mac* ]] && return 0
    [[ $TARGET == *arm64 ]] && return 0
    echo --disable-amf
}
