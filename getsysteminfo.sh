#!/bin/bash

getsysteminfo(){
    
    # Script gathers information about the system, including networking, disk usage, and Kernel information, takes input from parameter
    # Validates that script is being ran as Sudo
    
    if [ "$(id -u)" = "0" ]; then # If function is ran with sudo - execute script if UID = 0 (Root)
        
        DATE=$(date)
        hostname=$1
        
        {
            echo "Running System Information on $DATE"
            echo
            echo -e "Hostname:\n" $(hostname) "has the following uptime:" $(uptime)
            echo
            echo -e "Kernel Information:\n" $(uname -a)
            echo
            
            echo "Network Information:"
            Adapters=$(ip addr show)
            echo "$Adapters" | grep "lo\|inet\|en*\|eth*\|wlan*\|wl*\|vlan*\|veth" | grep -v "inet6\|valid_lft\|link/loopback\|link" # Use ip addr to gather networking info, Include all loopback, ethernet and wireless adapter info, exclude IPv6/MAC
            echo
            
            echo "Block Storage Devices:"
            lsblk -l
            echo
            
            echo "Disk Utilization:"
            df -hT | grep -v tmpfs
            echo
            
            echo "File System Mount Points:"
            cat /etc/fstab | grep -v "#"
            echo
            
            echo "Firewall Rules:"
            firewall-cmd --list-all
            echo
            
            echo "Top Processes Utilizing CPU & Memory Statistics:"
            top -o +%CPU -n 1 -b | head -n 18 # Sort by numeric, sort by CPU utilization, use head to select the top 10 processes using CPU
            # Top -n: Numer of iterations 1, -b: batch mode, -o: override sort field, select first 10 processes sorted by CPU (including top as a process)
            echo
            free -th # Free memory - human readable
            
        } > ./systeminfo # Output to systeminfo file
        
        printf "Please view the systeminfo file created in: $(pwd -L)\n"
    else
        echo -e "Error:\n Exit code $?: Script must be ran as administrator, re-run using Sudo" # Exit with non-zero error
        exit 1 # Exit with non-zero error
    fi
    
} # End function

getsysteminfo "$@" # Pass in all the arguments made to parameters when the script is ran