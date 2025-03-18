#!/bin/sh

INAME="$1"

[ -z "$INAME" ]
  && echo "$0 <iname>"
  && exit 1

hostnamectl set-hostname ns

nmcli c m "$INAME" \
  ipv4.addresses "192.168.1.1/24" \
  ipv4.method manual \
  ipv4.dns "192.168.1.1" \
  ipv4.dns-search "est.intra"

nmcli c up "$INAME"

tsig-keygen -a hmac-md5 ddns-update-key >/etc/named/ddns.key

[ ! -f /etc/named/ddns.key ] && exit 1

cp ./named.conf /etc/named.conf

[ ! -d /var/named ] && mkdir /var/named
cp ./est.intra.zone /var/named/
cp ./1.168.192.in-addr.arpa.zone /var/named/

named-checkconf /etc/named.conf
named-checkzone est.intra /var/named/est.intra.zone
named-checkzone 1.168.192.in-addr.arpa /var/named/1.168.192.in-addr.arpa.zone

chown named:named /var/named/est.intra.zone /var/named/1.168.192.in-addr.arpa.zone

restorecon -Rv /var/named/

[ -e /usr/lib/systemd/system/named.service ]
  && cp /usr/lib/systemd/system/named.service /etc/systemd/system/
  || cp ./named.service /etc/systemd/system/

if grep -q '^OPTIONS=' /etc/sysconfig/named
then
  :
else
  echo 'OPTIONS="-4"' >>/etc/sysconfig/named
fi

firewall-cmd --add-service=dns --permanent
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload

systemctl daemon-reload
systemctl enable --now named dhcpd
systemctl start --now named dhcpd

