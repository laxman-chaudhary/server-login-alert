#!/bin/bash

# Check if the script is being run as root
if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please switch to root user"
    exit 1
fi

soft_link="/usr/local/bin/alert" 

if [ -f "$soft_link" ]; then
    # echo "File '$soft_link' exists. Deleting..."
 rm "$soft_link"

#     echo "File deleted."
# else
#     echo "File '$soft_link' does not exist. Skipping deletion."
fi



installed_directory="/opt/script/login-alert"
if [ -d "$installed_directory" ]; then
    # echo "Directory '$installed_directory' exists. Deleting..."
    rm -r "$installed_directory"
    # echo "Directory '$installed_directory' deleted."
# else
    # echo "Directory '$installed_directory' does not exist."
fi
# echo "deleting softlinkls"

#Deleting Parameter from /etc/pam.d/sshd

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

 echo "Please wait...."
sleep 2 
 echo "Sucessfully uninstalled"
 echo
sleep 2
 echo "Reboot Your Server"
 echo


