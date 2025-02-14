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

nmcli c modify $DEVNAME ipv4.addresses "192.168.1.102/24"
nmcli c modify $DEVNAME ipv4.gateway "192.168.1.1"
nmcli c modify $DEVNAME ipv4.method manual
nmcli c down $DEVNAME
nmcli c up $DEVNAME