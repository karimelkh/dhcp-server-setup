#!/usr/bin/env bash

INAME="$1"

hostnamectl set-hostname ns

nmcli c m "$INAME" \
  ipv4.method manual \
  ipv4.addresses 192.168.1.1/24 \
  ipv4.dns 192.168.1.1 \
  ipv4.dns-search "est.intra"

nmcli c up "$INAME"

cp ./named.conf /etc/
cp ./est.intra.zone /var/named/
cp ./1.168.192.in-addr.arpa.zone /var/named/

cp /usr/lib/systemd/system/named.service /etc/systemd/system/
echo 'OPTIONS="-4"' >>/etc/sysconfig/named

systemctl daemon-reload
systemctl start --now named

firewall-cmd --add-service=dns
firewall-cmd --runtime-to-permanent