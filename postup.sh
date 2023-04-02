#!/bin/bash
IPT="/sbin/iptables"
 
IN_FACE="ens3"                   # NIC connected to the internet
WG_FACE="wg0"                    # WG NIC 
SUB_NET="10.200.200.1/24"            # WG IPv4 sub/net aka CIDR
WG_PORT="51820"                  # WG udp port
IN_PORT="53"
 
## IPv4 ##
$IPT -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$IPT -A INPUT -p udp -m udp --dport $WG_PORT -m conntrack --ctstate NEW -j ACCEPT
$IPT -A INPUT -s $SUB_NET -p tcp -m tcp --dport $IN_PORT -m conntrack --ctstate NEW -j ACCEPT
$IPT -A INPUT -s $SUB_NET -p udp -m udp --dport $IN_PORT -m conntrack --ctstate NEW -j ACCEPT
$IPT -A FORWARD -i $WG_FACE -o $WG_FACE -m conntrack --ctstate NEW -j ACCEPT
$IPT -t nat -A POSTROUTING -s $SUB_NET -o $IN_FACE -j MASQUERADE
