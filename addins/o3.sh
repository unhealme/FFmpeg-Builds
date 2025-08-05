#!/bin/bash
# shellcheck disable=SC2016
FF_CONFIGURE+=" --optflags=-O3"

ffbuild_dockeraddin() {
    to_df 'ENV CFLAGS="${CFLAGS} -O3"'
    to_df 'ENV CXXFLAGS="${CXXFLAGS} -O3"'
    to_df 'ENV FFLAGS="${FFLAGS} -O3"'
    to_df 'ENV FCFLAGS="${FCFLAGS} -O3"'
    to_df 'ENV RUSTFLAGS="${RUSTFLAGS} -Copt-level=3"'
}
