#!/bin/bash

set -x

IFACE="$1"

nmcli c m "$IFACE" ipv4.addresses "192.168.2.10/24" ipv4.method manual
nmcli c down "$IFACE"
nmcli c up "$IFACE"

cp ./dhcpd.conf /etc/dhcp/dhcpd.conf