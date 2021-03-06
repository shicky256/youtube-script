#! /bin/bash

#tries to connect to team2537_cs network
echo "connecting to the network"
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf

#waits for the connection to be made
sleep 2

#tries to get a dhcp lease
echo "getting a dhcp lease..."
dhclient wlan0 -v

#change 192.168.0.1 to the router's web config site
if nc -zw1 192.168.0.1 80; then
  echo "we have connectivity"
  exit 0
fi
echo "making an AP now"
ip link set wlan0 down
ip link set wlan0 up                                
ip addr add 10.0.0.1/24 dev wlan0
sleep 2
echo "enabling dhcp server"
dhcpd wlan0 &

echo "enabling AP"
hostapd /home/pi/hostapd.conf &
