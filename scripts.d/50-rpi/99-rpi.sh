#!/bin/bash

ffbuild_enabled() {
    [[ -n $RPI_ADDIN ]] || return -1
    return 0
}

ffbuild_dockerstage() {
    return 0
}

ffbuild_dockerdl() {
    return 0
}

ffbuild_configure() {
    echo "--enable-sand --enable-v4l2-request"
}