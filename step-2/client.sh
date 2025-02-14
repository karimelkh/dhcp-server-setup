#!/usr/bin/sh

set -x

if [ $# -lt 1 ]
then
  echo "USAGE: $0 <device_name>" >&2
  echo "e.g.: $0 enp0s3" >&2
  echo "type \`ifconfig\` or \`ip a\` to get it" >&2
  exit 1
fi

DEVNAME="$1"

if nmcli device show $DEVNAME &>/dev/null;
then
  echo "device name '$DEVNAME' does not exist" >&2
  exit 1
fi

nmcli c modify $DEVNAME ipv4.addresses ""
nmcli c modify $DEVNAME ipv4.gateway ""
nmcli c modify $DEVNAME ipv4.method auto
nmcli c down $DEVNAME
nmcli c up $DEVNAME

sudo mkdir -p /etc/NetworkManager/conf.d/
sudo cp ./dhcp-client.conf /etc/NetworkManager/conf.d/dhcp-client.conf