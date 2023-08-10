#!/bin/bash
#2023-08-10
# Check if the script is being run as root
if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please switch to root user"
    exit 1
fi


purge_file=(
    "source_code/.token"
    # "/usr/local/bin/alert"
)

for purge in "${purge_file[@]}"; do
    if [ -f "$purge" ]; then
        rm -f "$purge"
        #   echo "File $purge deleted"
        #   else
        #   echo "File $purge not found"
    fi
done


# Prompt the user for input
sleep 1
echo
echo "Get Token ID from Telegram bot with help of God Father"
sleep 2
echo
echo "use '/newbot' to create new bot" 
sleep 1
echo
echo "or use '/mybot' to reveal the existing token" 
echo
sleep 1
read -p "Enter USERID eg. 1234567: "  USERID
echo
sleep 0.5
read -p "Enter KEY eg. 6085238023:ABEaJi5i-dYgWe1RYuNt0_0s14C5eE7Hw8xEi: "  KEY

# Define other variables
TIMEOUT="10"
URL="https://api.telegram.org/bot\$KEY/sendMessage"

# Create the .token file
touch source_code/.token
echo "USERID=\"$USERID\"" > source_code/.token
echo "KEY=\"$KEY\"" >> source_code/.token
echo "TIMEOUT=\"$TIMEOUT\"" >> source_code/.token
echo "URL=\"$URL\"" >> source_code/.token
echo
echo "Saving token configuration... "
sleep 1

dir_path="/opt"
dir_name="script/login-alert"

full_path="${dir_path}/${dir_name}"

if [ ! -d "$full_path" ]; then
    mkdir -p "$full_path"
fi


rsync -ahz --quiet source_code/ $full_path/ && chmod +x $full_path/alert 2>&1 >/dev/null
sleep 1
cat /dev/null > source_code/.token

#Add Parameter on /etc/pam.d/sshd
string_to_find="session optional pam_exec.so $full_path/alert"
replacement_string="session optional pam_exec.so $full_path/alert"
pam_location="/etc/pam.d/sshd"

#Find and replace if string exist
if grep -q "$string_to_find" "$pam_location"; then
    # echo "String found in $pam_location Replacing..."
    sudo sed -i "s|$string_to_find|$replacement_string|g" "$pam_location"
    # echo "String replaced."
else
    # echo "String not found in $pam_location."
    # Append the new line
    new_line="session optional pam_exec.so $full_path/alert"
    echo "$new_line" | sudo tee -a /etc/pam.d/sshd > /dev/null
    # echo "Done."
    
fi 
 sleep 0.5
 echo
 echo "Re-login server to test the script"
 sleep 1.5
 echo
 echo "Installation Finished..."
 echo
 #End of script
