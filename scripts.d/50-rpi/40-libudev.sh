#!/bin/bash

SCRIPT_REPO="https://github.com/systemd/systemd.git"
SCRIPT_COMMIT="b3d8fc43e9cb531d958c17ef2cd93b374bc14e8a"

ffbuild_enabled() {
    [[ -n $RPI_ADDIN ]] || return -1
    return 0
}

ffbuild_dockerbuild() {
    mkdir build && cd build

    export CFLAGS="$RAW_CFLAGS"
    export CXXFLAGS="$RAW_CXXFLAGS"

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Dauto_features=disabled
    )

    if [[ $TARGET == win* ]]; then
        myconf+=(
            -Dhave_mingw_pthreads=true
        )
    fi

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j"$(nproc)"
    DESTDIR="$FFBUILD_DESTDIR" ninja install
}

ffbuild_configure() {
    echo --enable-libudev
}

ffbuild_unconfigure() {
    echo --disable-libudev
}
