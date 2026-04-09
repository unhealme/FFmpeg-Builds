#!/bin/bash
# shellcheck disable=SC2016
FF_CONFIGURE+=" --cpu=x86-64-v3"

ffbuild_dockeraddin() {
    to_df 'ENV CFLAGS="${CFLAGS} -march=x86-64-v3 -O3 -mpclmul"'
    to_df 'ENV CXXFLAGS="${CXXFLAGS} -march=x86-64-v3 -O3 -mpclmul"'
    to_df 'ENV RUSTFLAGS="${RUSTFLAGS} -Copt-level=3 -Ctarget-cpu=x86-64-v3 -Clink-arg=-z -Clink-arg=pack-relative-relocs -Ccodegen-units=1"'
    to_df 'ENV GOAMD64=v3'
}
