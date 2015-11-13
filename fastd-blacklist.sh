#!/bin/bash
PEER_KEY=$1

if [ -e /var/run/FASTD_FULL ] ; then
    /usr/bin/logger "$0: fastd rejects $PEER_KEY due to too many connections."
    exit 1
fi

if /bin/grep -Fq $PEER_KEY /etc/fastd/tro/fastdbl/fastd-blacklist.json; then
	exit 1
else
	exit 0
fi
