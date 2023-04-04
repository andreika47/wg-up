# Install tools

apt update -y && apt upgrade -y

apt install -y linux-headers-"$(uname -r)"

apt install net-tools -y

apt install -y software-properties-common

apt install -y wireguard

modprobe wireguard

apt-get install unbound unbound-host

# Create dirs and files

mkdir /etc/wireguard
mkdir /etc/wireguard/keys
wg genkey | tee /etc/wireguard/keys/server-private-key | wg pubkey > /etc/wireguard/keys/server-public-key
wg genkey | tee /etc/wireguard/keys/client-private-key | wg pubkey > /etc/wireguard/keys/client-public-key
touch /etc/wireguard/wg0.conf
touch /etc/wireguard/wg0-client.conf
chown -v root:root /etc/wireguard/wg0.conf
chmod -v 600 /etc/wireguard/wg0.conf

# Setup Wireguard

wg-quick up wg0

systemctl enable wg-quick@wg0.service

# IP Forwarding

Edit the file /etc/sysctl.conf and set the following line as:
net.ipv4.ip_forward=1

sysctl -p
echo 1 > /proc/sys/net/ipv4/ip_forward

# Setup firewall and NAT

see postup.sh

# Setup DNS

curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

touch /etc/unbound/unbound.conf

chown -R unbound:unbound /var/lib/unbound

systemctl enable unbound

# Test

nslookup www.googlec.com 10.200.200.1

# Add new client

wg set wg0 peer <new_client_public_key> allowed-ips <new_client_vpn_IP>/32
