#!/bin/bash

HOST=gmn.uwo.ca

# Take the username as the argument
#if [ "$#" -ne 1 ] || ! [ -d "$1" ]; then
if [ $# -ne 1 ]; then
  echo "Usage: sudo $0 USER_NAME" >&2
  exit 1
fi

USNAME=$1


# Install OpenVPN
sudo apt-get update
sudo apt-get install openvpn -y

# Copy the VPN configuration from the server
sftp $USNAME@$HOST:files/openvpn/$USNAME.ovpn ~/$USNAME.ovpn

# Install the configuration
sudo cp ~/$USNAME.ovpn /etc/openvpn/client.conf

# Test connectivity
#sudo openvpn --client --config /etc/openvpn/client.conf

# Automatically start the VPN service
sudo /etc/init.d/openvpn start
