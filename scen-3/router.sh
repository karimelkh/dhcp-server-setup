#!/bin/bash

# RUN as root

set -x

IFACE_1="$1"
IFACE_2="$2"

nmcli c m "$IFACE_1" ipv4.addresses "192.168.1.1/24" ipv4.method manual connection.id enp0s3
nmcli c down "$IFACE_1"
nmcli c up "$IFACE_1"

nmcli c m "$IFACE_2" ipv4.addresses "192.168.2.1/24" ipv4.method manual connection.id enp0s8
nmcli c down "$IFACE_2"
nmcli c up "$IFACE_2"

sysctl -w net.ipv4.ip_forward=1

cp ./dhcrelay /etc/sysconfig/

cp ./dhcrelay.service /etc/systemd/system/

systemctl enable dhcrelay
systemctl start dhcrelay