#!/bin/bash
set -e

echo "Starting NUT Server..."
echo "UPS Name: $NAME"
echo "Driver: $DRIVER"
echo "Port: $PORT"
echo "Poll Frequency: $POLLFREQ seconds"

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

echo "Configuring UPS..."
cat > /etc/nut/ups.conf << EOF
[$NAME]
    driver = $DRIVER
    port = $PORT
    pollfreq = $POLLFREQ
    desc = $DESC
    vendorid = $VENDORID
    productid = $PRODUCTID
    subdriver = $SUBDRIVER
    langid_fix = $LANGID_FIX
EOF

if [ "$USERSSTRING" != "#" ]; then
    echo "Configuring NUT users..."
    echo -e "$USERSSTRING" > /etc/nut/upsd.users
fi

if [ -d /dev/bus/usb ]; then
    echo "Setting USB device permissions..."
    chgrp nut /dev/bus/usb/*/* 2>/dev/null || echo "No USB devices found or permission already set"
fi

chgrp nut /etc/nut/* 2>/dev/null || true

echo "Starting UPS driver..."
upsdrvctl start
trap 'echo "Stopping UPS driver..."; upsdrvctl stop' EXIT

echo "Starting UPS daemon..."
exec upsd -F
