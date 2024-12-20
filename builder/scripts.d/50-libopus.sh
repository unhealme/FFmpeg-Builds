#!/bin/bash

SCRIPT_REPO="https://github.com/xiph/opus.git"
SCRIPT_COMMIT="7db26934e4156597cb0586bb4d2e44dccdde1a59"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" opus
    cd opus

    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-extra-programs
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    elif [[ $TARGET == mac* ]]; then
        :
    else
        echo "Unknown target"
        return -1
    fi

    if [[ $TARGET == linux* || $TARGET == mac* ]] && [[ $TARGET == *arm64 ]]; then
        myconf+=(
            --with-NE10-libraries="$FFBUILD_PREFIX"/lib
            --with-NE10-includes="$FFBUILD_PREFIX"/include/libNE10
        )
    fi

    # reset CLFAGS because libopus may give up optimization if current CFLAGS contains value
    CFLAGS_BACKUP="$CFLAGS"
    export CFLAGS="-O3" # For some reason libopus will not add optimization flag, we have to set it ourselves

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install

    export CFLAGS="$CFLAGS_BACKUP"

    if [[ $TARGET == *arm64 ]]; then
        if [[ $TARGET == mac* ]]; then
          gsed -i 's/-lopus/-lopus -lNE10/' "$FFBUILD_PREFIX"/lib/pkgconfig/opus.pc
          gsed -i 's/-I${includedir}\/opus/-I${includedir}\/opus -I${includedir}\/libNE10/' "$FFBUILD_PREFIX"/lib/pkgconfig/opus.pc
      else
          sed -i 's/-lopus/-lopus -lNE10/' "$FFBUILD_PREFIX"/lib/pkgconfig/opus.pc
          sed -i 's/-I${includedir}\/opus/-I${includedir}\/opus -I${includedir}\/libNE10/' "$FFBUILD_PREFIX"/lib/pkgconfig/opus.pc
      fi
    fi
}

ffbuild_configure() {
    echo --enable-libopus
}

ffbuild_unconfigure() {
    echo --disable-libopus
}
