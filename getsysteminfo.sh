#!/bin/bash

getsysteminfo(){

# Script gathers information about the system, including networking, disk usage, and Kernel information

# Take input from parameter 
# Validate that command is being ran with sudo 
# Gather system information
# Add error handling 
# Create a file that formats and cleans up information 

# Run script with getsysteminfo.sh mypc - substitute mypc for your hostname


# Once complete and looking how you want it - remove all the redundant echo commands

	if [ "$(id -u)" = "0" ]; then # If function is ran with sudo - execute script if UID = 0 (Root)

		DATE=$(date)
		hostname=$1

		echo "Running System Information on $DATE" > ./systeminfo
		echo "" >> ./systeminfo
		echo -e "Hostname:\n" $(hostname) "has the following uptime:" $(uptime) >> ./systeminfo 
		echo "" >> ./systeminfo
		echo -e "Kernel Information:\n" $(uname -a) >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Network Information:" >> ./systeminfo
		Adapters=$(ip addr show)
		echo "$Adapters" | grep "lo\|inet\|en*\|eth*\|wlan*\|wl*\|vlan*\|veth" | grep -v "inet6\|valid_lft\|link/loopback\|link" >> ./systeminfo # Use ip addr to gather networking info, Include all loopback, ethernet and wireless adapter info, exclude IPv6/MAC
		echo "" >> ./systeminfo

		echo "Block Storage Devices:" >> ./systeminfo
		lsblk -l >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Disk Utilization:" >> ./systeminfo
		df -hT | grep -v tmpfs >> ./systeminfo
		echo "" >> ./systeminfo

		echo "File System Mount Points:" >> ./systeminfo
		cat /etc/fstab | grep -v "#" >> ./systeminfo
		echo "" >> ./systeminfo

		echo "Firewall Rules:" >> ./systeminfo
		firewall-cmd --list-all >> ./systeminfo
		echo "" >> ./systeminfo

		echo -e "Top Processes Utilizing CPU & Memory Statistics:\n" >> ./systeminfo
		top -o +%CPU -n 1 -b | head -n 18 >> ./systeminfo # Sort by numeric, sort by CPU utilization, use head to select the top 10 processes using CPU 
		# Top -n: Numer of iterations 1, -b: batch mode, -o: override sort field, select first 10 processes sorted by CPU (including top as a process)
		echo "" >> ./systeminfo
		free -th >> ./systeminfo # Free memory - human readable

		printf "Please view the systeminfo file created in: $(pwd -L)\n"
else	
	echo -e "Error:\n Exit code $?: Script must be ran as administrator - Rerun with Sudo" # Exit with non-zero error
	exit 1 # Exit with non-zero error
fi

}

getsysteminfo "$@" # Pass in all the arguments made to parameters when the script is ran