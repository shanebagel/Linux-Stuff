#!/bin/bash


# This script configures a new network profile using the nmcli utility
# An overview of the current network profiles are displayed
# Next a custom profile is generated along with IP, subnet mask, and gateway addresses settings that can be tweaked

createnetworkprofile() {
    
    # Shell parameters
    ipaddress=$1 # IP Address in format x.x.x.x/xx
    gateway=$2 # Gateway IP Address in format x.x.x.x
    dns=$3 # DNS IP in format x.x.x.x
    adaptertype=$4 # Either ethernet or wifi
    adaptername=$5 # Name of the ethernet adapter
    
    
    if [ "$(id -u)" = "0" ]; then # If UID is not root, rerun script as administrator
        
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
        
        echo "Configuring Network Profile for new adapter" >> ./profileresults
        echo "======================================" >> ./profileresults
        
        # nmcli utility adding ethernet interface. Change the network adapter to reflect current adapter name
        nmcli connection add con-name "$adaptername" ifname "$adaptername" type "$adaptertype" ip4 "$ipaddress" gw4 "$gateway" ipv4.dns "$dns"
        nmcli con up "$adaptername" # Set interface up
        cp /etc/hosts /etc/hostsbackup # Backing up hosts file before echoing updated hostname, and IP of adapter into hosts file
        printf "`ip addr show | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v 127.* | grep -v 192.168.1.25[45]` `echo $HOSTNAME`\n" >> /etc/hosts # Regex to select a valid IP, excluding loopback addresses
        
        # Using pretty print to format on the same line, the new IP address that has been applied, using grep to exclude any loopback address, or gateways ending in .254 or .255, and echoing the new hostname to the /etc/hosts file
        echo "New network profile:" >> profileresults
        nmcli connection show "$adaptername" >> profileresults
        echo >> profileresults
        echo "Updated Network Profile settings" >> profileresults
        nmcli device show "$adaptername" >> profileresults
        echo "Script successfully executed, please see the file labelled 'profileresults' for additional info, located in the directory the script was run from"
        
    else
        echo -e "Error:\n Exit code $?: Script must be ran as administrator, re-run using Sudo" # Exit with non-zero error
        exit 1 # Exit with non-zero error
    fi
    
} # End function

createnetworkprofile "$@" # Call function