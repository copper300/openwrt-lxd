#!/bin/sh

# Original script by: melato
#
# Modified by Craig Miller
# December 2018

VERSION="0.92"


# 8 May 2019
#
# gjedeer found a simpler way to get openwrt to complete the boot process
#
#   
#


# mount /dev
mount -t devtmpfs devtmpfs /dev


# wait, let things startup
echo "waiting for rest of boot up..."
while ! pgrep uhttpd 
do
  echo "wait.."
  sleep 1
done

#
# Firewall should start normally, but keeping this in the script for now 
#    until more testing can be done

# kick iptables, so firewall will start 
ip6tables -L
iptables -L

echo "Restarting Firewall"
# clear and restart firewall
/etc/init.d/firewall restart

# show result
#ip6tables -L


# insert NAT44 iptables rule, firewall fails to insert this rule
WAN=$(uci get network.wan.ifname)
if [ $(uci get firewall.@zone[1].masq) -eq 1 ]; then
    echo "Enabling IPv4 NAT"
   /usr/sbin/iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
fi

echo "Pau!"

