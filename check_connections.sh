#!/bin/bash
#
# Calculate if fastd should accept more connections.
#
# We use "batctl o" as current network size (NETWORKSIZE)
# We use "batctl gwl" as current number of GWs (NUMGATEWAYS)
# We add 50 to NETWORKSIZE, then do MAXPEERS=NETWORKSIZE/NUMGATEWAYS.
# Finally we check the number of current fastd connections against MAXPEERS.
# If we have more connections, we'll just touch /var/run/FASTD-<%= @mesh_code %>_FULL,
# otherwise, we delete it.
#
# /etc/fastd/<%= @mesh_code %>-mesh-vpn/fastd-blacklist.sh should check for the existence
# of /var/run//FASTD-<%= @mesh_code %>_FULL and reject new connections if it's there ...

NETWORKSIZE="`/usr/local/sbin/batctl o | /usr/bin/wc -l`"
NUMGATEWAYS="`/usr/local/sbin/batctl gwl | sed -r 's/([^\.]*)\(.*/\1/' | sed '/04:74:05:d0:4f/d' | sed $= -n`"
NETWORKSIZE="`/usr/bin/expr ${NETWORKSIZE} + 1`"
if [ ${NUMGATEWAYS} -eq 0 ]; then
    NUMGATEWAYS=1
fi
MAXPEERS="`/usr/bin/expr ${NETWORKSIZE} / ${NUMGATEWAYS}`"
CURPEERS="`FASTD_SOCKET=/var/run/fastd-status.sock /usr/local/bin/fastd-query connections`"
if [ "X${CURPEERS}" = "X" ]; then
    /usr/bin/logger "$0: WARNING: empty string reading fastd connections"
    CURPEERS=0
fi

if [ ${CURPEERS} -ge ${MAXPEERS} ]; then
    if [ ! -e /var/run/FASTD_FULL ]; then
        echo "TOO FULL: Current: ${CURPEERS} Max: ${MAXPEERS}" > /var/run/FASTD_FULL
        /usr/bin/logger "$0: halting new fastd connections (${CURPEERS} >= ${MAXPEERS})"
    fi
else
     if [ -e /var/run/FASTD_FULL ]; then
        /bin/rm -f /var/run/FASTD_FULL
        /usr/bin/logger "$0: fastd to accept new connections again (${CURPEERS} < ${MAXPEERS})"
     fi
fi

exit 0 
