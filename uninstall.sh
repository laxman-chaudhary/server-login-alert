#!/bin/bash
#Author: Laxman Chaudhary
#Date:  2023-08-10

# Check if the script is being run as root user


if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please switch to root user"
    exit 1
fi

# Remove content from /etc/pam.d/sshd; if exists
file_path="/etc/pam.d/sshd"  # Replace with the actual file path
search_string="session optional pam_exec.so /opt/script/login-alert/alert"

if [ -f "$file_path" ]; then
    
    if grep -qF "$search_string" "$file_path"; then
        # echo "String found in the file."
        sudo sed -i "\|$search_string|d" "$file_path"
        # echo "Line deleted."
    # else
        # echo "String not found in the file. Skipping deletion."
    fi
fi
     echo
     sleep 1
     echo "Please wait..."

#Remove Script
installed_directory="/opt/script/login-alert"
if [ -d "$installed_directory" ]; then

    # echo "Directory '$installed_directory' exists. Deleting..."
    rm -r "$installed_directory"
     echo
     sleep 2
     echo "Sucessfully Removed. Reboot Your Server!!!"
     sleep 0.5
     echo
 else
    
    echo
    sleep 2
    echo "Application not installed. Please use ./install to install the script"
    sleep 0.5
    echo
fi


