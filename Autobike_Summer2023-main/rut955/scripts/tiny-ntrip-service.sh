#!/bin/sh

##
## Install location: /root
##
## This file provides functions to start and stop the ntrip client which
## provides RTK corrections to the u-blox board
##
## Author: Ossian Eriksson
##

# The PID of the ntrip client is stored in this file
PIDFILE="/var/run/tiny-ntrip.pid"

function stop {
    PID="$(cat "${PIDFILE}" 2> /dev/null)"
    if [ ! -z "${PID}" ]; then
        logger -t tiny-ntrip "Stopping tiny-ntrip"
        kill "${PID}"
        rm -f "${PIDFILE}"
    else
        logger -t tiny-ntrip "No PID of tiny-ntrip instance was found, nothing was stopped"
    fi
}

function start {
    if [ ! -z "$1" ]; then
        DEVICE="$1"
    else
        logger -t tiny-ntrip "Looking for u-blox device"

        # Look through all connected devices to find the u-blox
        FOUND=1
        for product in $(find /sys/devices/platform/ehci-platform/ -name 'product' -type f); do
            if [ "$(cat $product)" = "u-blox GNSS receiver" ]; then
                DEVICE=$(find ${product%/*} -name 'ttyACM*' | head -1)
                DEVICE=/dev/$(basename $DEVICE)
                
                FOUND=1
                break
            fi
        done

        if [ $FOUND -eq 0 ]; then
            logger -t tiny-ntrip "Unable to find u-blox device"
            exit 1
        fi
    fi

    stop

    logger -t tiny-ntrip "Starting tiny-ntrip on ${DEVICE}"
    /root/tiny-ntrip --server 192.71.190.141 --port 80 --user ChalmersE2RTK --password 885511 --mount MSM_GNSS --device "${DEVICE}" &
    echo $! > "${PIDFILE}"
}
