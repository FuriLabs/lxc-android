#!/bin/sh

# Halium 9
mkdir -p /dev/__properties__
mkdir -p /dev/socket

# Clear stale property areas in case of an unexpected shutdown
find /dev/__properties__ -mindepth 1 -delete

# Mount a tmpfs on /apex if we should
if [ -e "/apex" ] && ! mountpoint -q /apex; then
    mount -t tmpfs tmpfs /apex
fi

# mount binderfs if needed
if [ ! -e /dev/binder ]; then
    mkdir -p /dev/binderfs

    if ! mountpoint -q /dev/binderfs; then
        mount -t binder binder /dev/binderfs -o stats=global
    fi

    ln -sf /dev/binderfs/*binder /dev
fi
