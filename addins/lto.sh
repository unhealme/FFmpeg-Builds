#!/bin/bash
# shellcheck disable=SC2016
FF_CONFIGURE+=" --enable-lto"

ffbuild_dockeraddin() {
    to_df 'ENV CFLAGS="${CFLAGS} -flto=auto"'
    to_df 'ENV CXXFLAGS="${CXXFLAGS} -flto=auto"'
    to_df 'ENV LDFLAGS="${LDFLAGS} -flto=auto"'
    to_df 'ENV FFLAGS="${FFLAGS} -flto=auto"'
    to_df 'ENV FCFLAGS="${FCFLAGS} -flto=auto"'
    to_df 'ENV RUSTFLAGS="${RUSTFLAGS} -Clto"'
    to_df 'ENV CARGO_PROFILE_RELEASE_LTO=fat'
    to_df 'ENV FFBUILD_TARGET_FLAGS="$FFBUILD_TARGET_FLAGS --ar=${FFBUILD_TOOLCHAIN}-gcc-ar --nm=${FFBUILD_TOOLCHAIN}-gcc-nm --ranlib=${FFBUILD_TOOLCHAIN}-gcc-ranlib"'
}
