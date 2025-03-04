#!/bin/bash

set -x

IFACE="$1"

nmcli c m "$IFACE" ipv4.method auto
nmcli c down "$IFACE"
nmcli c up "$IFACE"