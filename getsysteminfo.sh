#!/bin/bash

getsysteminfo(){

# Script gathers information about the system, including networking, disk usage, and Kernel information

# Take input from parameter 
# Validate that command is being ran with sudo 
# Gather system information
# Add error handling 
# Create a file that formats and cleans up information 

# Run script with getsysteminfo.sh mypc - substitute mypc for your hostname

	if ["$(id -u)" != "0"]; then # If function is ran with sudo - execute script

		DATE=$(date)
		hostname=$1

		echo "Running System Information on $DATE:" > ./systeminfo
		echo "Hostname:" $(hostname) "has the following uptime:" $(uptime) >> ./systeminfo 
		uname -a >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Networking Information:"
		ip addr show | grep "lo\|inet\|en*\|eth*\|wlan*\|wl*\|vlan*\|veth" | grep -v "inet6\|link/loopback" >> ./systeminfo # Use ip addr to gather networking info, include all loopback, ethernet and wireless adapter info - exclude IPv6
		echo "" >> ./systeminfo

		echo "Block Storage Devices:"
		lsblk -f >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Disk Utilization:"
		df -hT | grep -v "tempfs" >> ./systeminfo
		echo "" >> ./systeminfo

		echo "File System Mount Points:"
		cat /etc/fstab | grep -v "#"
		echo "" >> ./systeminfo

		echo "Firewall Rules:"
		firewall-cmd --list-all >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Top Processes Utilizing CPU & Memory Statistics:"
		ps aux | sort -nrk 3,3 | head >> ./systeminfo # Sort by numeric, sort by CPU utilization, use head to select the top 10 processes using CPU
		free -th >> /.systeminfo
else	
	echo "Error - Exit code $?: Script must be ran as administrator - Rerun with Sudo" # Exit with non-zero error
	exit 1 # Exit with non-zero error
fi

}

getsysteminfo $@ # Pass in all the arguments made to parameters when the script is ran