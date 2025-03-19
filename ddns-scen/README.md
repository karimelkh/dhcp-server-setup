# DDNS

## Step 1: Get ready PART 1

> [!NOTE]
> the virtual machine should be connected to the internet

Ensure that `bind`, `bind-utils`, `dhcp-server` and `git` (to clone this repo)
packages are installed.

```sh
sudo dnf4 install bind bind-utils dhcp-server git
```

> [!NOTE]
> `dnf` may not work. Try `dnf4` instead.

## Step 2: Get ready PART 2

Clone this repo.

```sh
git clone https://github.com/karimelkh/dhcp-server-setup.git
```

## Step 3: Main event

> [!NOTE]
> the virtual machine should be connected to internal network

1. After cloning the repo, cd into it.

```sh
cd dhcp-server-setup/ddns-scen
```
2. Get the interface id

```sh
nmcli d
```

3. Run the script (with **enp0s3** as the interface id):

```sh
sudo ./config_ns.sh enp0s3
```

## Step 4: Testing

In the client (which is in the same LAN as the ns server), type:

```sh
dig ns.est.intra
```

Now you should see the ns server ip address, so the named part is working.

Get ip address:

```
sudo dhclient -r && sudo dhclient -v
```

Now the zone files: *est.intra.zone* and *1.168.192.in-addr.arpa.zone* should have changed
and includes now the client records

## Troubleshooting

1. If the dhcpd service did not (re)start, type:

```sh
sudo setenforce 0
sudo systemctl restart dhcpd
```
