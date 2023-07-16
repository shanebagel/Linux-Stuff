#!/bin/bash
# This script configures a new network profile using the nmcli utility
# An overview of the current network profiles are displayed
# Next a custom profile is generated along with IP, subnet mask, and gateway addresses settings that can be tweaked
# Additionally, the /etc/hosts file is backed up, and content is appended to it
echo "Please add a new virtualized network adapter"
echo
echo "Have you added a new network adapter? Answer Y/N:"
read x
if [ $x = "Y" ]
then
        echo "Generating Network Profile..."
else [ $x = "N" ]
        echo "Please attach new network adapter, and re-run script"
        exit
fi
echo "Current Network Profile settings:" >> NetworkResults
echo "=================================" >> NetworkResults
nmcli device show >> NetworkResults
echo >> NetworkResults
echo "Adding Network Profile for new adapter" >> NetworkResults
echo "======================================" >> NetworkResults
nmcli connection add con-name NewNetProfile ifname enp14s0 type ethernet ip4 192.168.1.150/24 gw4 192.168.1.254 >> NetworkResults
# nmcli utility adding interface enp14s0. Change the network adapter to reflect current adapter name
cp /etc/hosts /tmp/hostsbackup
hostnamectl hostname server1
systemctl restart systemd-hostnamed
echo >> NetworkResults
echo "/etc/hosts backed up to /tmp directory, hostname updated, hosts file updated with new address" >> NetworkResults
printf "`ip addr show | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v 127.* | grep -v 192.168.1.25[45]` `echo $HOSTNAME`\n" >> /etc/hosts
# Using pretty print to format on the same line, the new IP address that has been applied, using grep to exclude any loopback address, or gateways ending in .254 or .255, and echoing the new hostname to the /etc/hosts file
echo >> NetworkResults
echo "New network profile:" >> NetworkResults
nmcli connection show >> NetworkResults
echo >> NetworkResults
echo "Updated Network Profile settings" >> NetworkResults
nmcli device show >> NetworkResults
echo "Script successfully executed, please see the file labelled 'NetworkResults' for additional info, located in the directory the script was run from"