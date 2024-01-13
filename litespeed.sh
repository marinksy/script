#!/bin/bash

# Move to root directory
cd /

# Download LiteSpeed Web Server autoinstaller script
wget http://www.litespeedtech.com/packages/cpanel/lsws_whm_autoinstaller.sh

# Provide execute permissions to the script
chmod +x lsws_whm_autoinstaller.sh

# Prompt for root password
echo "Please enter your root password:"
read -s ROOT_PASSWORD

# Replace placeholder password in the script
sed -i "s/PUNE_PAROLA_ROOT_A_SERVERULUI/${ROOT_PASSWORD}/g" lsws_whm_autoinstaller.sh

# Run the autoinstaller script with specified parameters using sudo
echo "$ROOT_PASSWORD" | sudo -S ./lsws_whm_autoinstaller.sh TRIAL 1 0 admin ${ROOT_PASSWORD} mxhost.ro@gmail.com 1 0

# Clear the entered root password from the variable
ROOT_PASSWORD=""
