# GUIDE

## Requirements

- fedora (v41) virtual machines (>= 3)
- `dhcp-server` (server)
- `dhcp-client` (clients)

## Start

## Step 0

```
sudo dnf update
sudo dnf install dhcp-server # server
sudo dnf install dhcp-client # client
```

### Step 1

> [!NOTE]
> The machines in this step should be connected to the internet.
> Use NAT or Bridged network

Run each script in the apropriate machine:

- `./step-1/client-1.sh` in the 1st client
- `./step-1/client-2.sh` in the 2nd client
- `./step-1/dhcp-server.sh` in the dhcp server

### Step 2

> [!NOTE]
> Use Internal network (VirtualBox) or Custom (VMware) network

- `./step-2/client.sh` in both clients