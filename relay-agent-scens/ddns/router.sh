#!/bin/sh

set -xe

IFACE_LAN="$1"
IFACE_DMZ="$2"

if [ -z "$IFACE_LAN" ] || [ "$IFACE_DMZ" ]
then
  echo "$0 <iface_lan> <iface_dmz>"
  exit 1
fi

hostnamectl set-hostname router

nmcli c m "$IFACE_LAN" \
  ipv4.addresses "192.168.1.10/24" \
  ipv4.method manual \
  ipv4.dns "192.168.1.1" \
  ipv4.dns-search "est.intra" \
  connection.id enp0s3

nmcli c m "$IFACE_DMZ" \
  ipv4.addresses "192.168.2.10/24" \
  ipv4.method manual \
  ipv4.dns "192.168.1.1" \
  ipv4.dns-search "est.intra" \
  connection.id enp0s8

sysctl -w net.ipv4.ip_forward=1

# allow DNS traffic
iptables -A FORWARD -p udp --dport 53 -j ACCEPT

cp ./dhcrelay.service /etc/systemd/system/
cp ./dhcrelay /etc/sysconfig/

systemctl daemon-reload
systemctl enable dhcrelay
systemctl start dhcrelay

echo "== ROUTER CONFIGURED WITH SUCCESS =="