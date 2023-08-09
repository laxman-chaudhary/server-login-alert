#!/bin/bash

# Check if the script is being run as root
if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please switch to root user"
    exit 1
fi

#Define an array of file paths
purge_file=(
    "source_code/.token"
    "/usr/local/bin/alert"
)

for purge in "${purge_file[@]}"; do
    if [ -f "$purge" ]; then
        rm "$purge"
        #  echo "File $purge deleted"
        #  else
        #  echo "File $purge not found"

    fi
done


# Prompt the user for input
echo
sleep 1
echo "Get Token ID from Telegram bot with help of God Father"
sleep 2
echo
echo "use '/newbot' to create new bot" 
sleep 0.5
echo "or use '/mybot' to reveal the existing token" 
echo
sleep 0.5
read -p "Enter USERID eg. 1234567: "  USERID
echo
sleep 0.5
read -p "Enter KEY eg. 6085238023:ABEaJi5i-dYgWe1RYuNt0_0s14C5eE7Hw8xEi: " KEY

# Define other variables
TIMEOUT="10"
URL="https://api.telegram.org/bot\$${KEY}/sendMessage"

# Create the .token file
touch source_code/.token
echo "USERID=\"$USERID\"" > source_code/.token
echo "KEY=\"$$KEY\"" >> source_code/.token
echo "TIMEOUT=\"$TIMEOUT\"" >> source_code/.token
echo "URL=\"$URL\"" >> source_code/.token
echo
sleep 0.2
echo "Token configuration saved "
sleep 1

dir_path="/opt"
dir_name="script/login-alert"

full_path="${dir_path}/${dir_name}"

if [ ! -d "$full_path" ]; then
    mkdir -p "$full_path"
fi

echo
rsync -q source_code/ $full_path/ && chmod +x $full_path/alert 2>&1 >/dev/null
sleep 1
cat /dev/null > source_code/.token
#Create softlink
ln -s $full_path/alert /usr/local/bin/alert


string_to_find="session optional pam_exec.so $full_path/alert"
replacement_string="session optional pam_exec.so $full_path/alert"
pam_location="/etc/pam.d/sshd"

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
 echo "Sucessfully installed..."
 echo
 sleep 0.5
 echo "Try ' $sudo alert' command to test the script"
 echo

 #End of script

