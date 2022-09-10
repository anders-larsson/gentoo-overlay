#!/bin/sh

set -ue

# Load optional configuration from /opt/bind-adblock/bind-adblock.conf
test -f /opt/bind-adblock/bind-adblock.conf && source /opt/bind-adblock/bind-adblock.conf

ZONEDIR=${ZONEDIR:-/var/bind/pri}
ZONE=${ZONE:-rpz.unwanted}

/opt/bin/update-zonefile.py "${ZONEDIR}/${ZONE}.zone" "${ZONE}" 1>/dev/null
