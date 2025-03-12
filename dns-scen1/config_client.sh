#!/usr/bin/env bash

set -xe

INAME="$1"

hostnamectl set-hostname client

nmcli c m "$INAME" \
  ipv4.method manual \
  ipv4.addresses 192.168.1.11/24 \
  ipv4.dns 192.168.1.1 \
  ipv4.dns-search "est.intra"

nmcli c up "$INAME"
