#!/bin/sh

set -xe

IFACE="$1"

[ -z "$IFACE" ] && echo "$0 <iface>" && exit 1

hostnamectl set-hostname ns

nmcli c m "$IFACE" \
  ipv4.addresses "192.168.1.1/24" \
  ipv4.gateway "192.168.1.10" \
  ipv4.method manual \
  ipv4.dns "192.168.1.1" \
  ipv4.dns-search "est.intra"

nmcli c up "$IFACE"

tsig-keygen -a hmac-md5 ddns-update-key >/etc/named/ddns.key

[ ! -f /etc/named/ddns.key ] && exit 1
cp /etc/named/ddns.key /etc/dhcp/ddns.key

chown named:named /etc/named/ddns.key
chmod 640 /etc/named/ddns.key

chown named:named /etc/dhcp/ddns.key
chmod 640 /etc/dhcp/ddns.key

# semanage fcontext -a -t named_conf_t /etc/named/ddns.key

cp ./dhcpd.conf /etc/dhcp/
cp ./named.conf /etc/

[ ! -d /var/named ] && mkdir /var/named
cp ./est.intra.zone /var/named/
cp ./1.168.192.in-addr.arpa.zone /var/named/
cp ./2.168.192.in-addr.arpa.zone /var/named/

named-checkconf /etc/named.conf
named-checkzone est.intra /var/named/est.intra.zone
named-checkzone 1.168.192.in-addr.arpa /var/named/1.168.192.in-addr.arpa.zone
named-checkzone 2.168.192.in-addr.arpa /var/named/2.168.192.in-addr.arpa.zone

chown named:named /var/named/est.intra.zone /var/named/1.168.192.in-addr.arpa.zone /var/named/2.168.192.in-addr.arpa.zone

restorecon -Rv /var/named/

cp ./dhcpd.service /etc/systemd/system/
[ -e /usr/lib/systemd/system/named.service ] && cp /usr/lib/systemd/system/named.service /etc/systemd/system/ || cp ./named.service /etc/systemd/system/

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

echo "== NAMESERVER CONFIGURED WITH SUCCESS =="