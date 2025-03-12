# DNS scenario 1 guide

## Config steps

## Step 1

> [!NOTE]
> make sure the the virtual machine is connected to the internet

Install `bind`:

```sh
sudo dnf -y install bind bind-utils
```

### Step 2

Clone the repo in the ns server:

```sh
git clone https://github.com/karimelkh/dhcp-server-setup.git
cd dhcp-server-setup/dns-scen1
```

### Step 3

> [!NOTE]
> The vm should now be in the internal network (vbox).

Run the `config_ns.sh` script in the ns server (AS root):

```sh
sudo ./config_ns.sh
```

### Step 4

> [!NOTE]
> The client should be in the same internal network as the ns server.

Run the `config_client.sh` script in the client:

```sh
./config_client.sh
```

## Testing

In the client and ns server, type:

```sh
dig ns.est.intra
dig client.est.intra
```

```sh
dig -x 192.168.1.1
dig -x 192.168.1.11
```