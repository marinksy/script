#!/bin/bash

#####Tweak settings#######

sed -i '/requiressl/c\requiressl=0' /var/cpanel/cpanel.config
sed -i '/maxemailsperhour/c\maxemailsperhour=400' /var/cpanel/cpanel.config
sed -i '/emailusersbandwidthexceed/c\emailusersbandwidthexceed=0' /var/cpanel/cpanel.config
sed -i '/maxmem=4096/c\maxmem' /var/cpanel/cpanel.config
sed -i '/emailusersbandwidthexceed80/c\emailusersbandwidthexceed80=0' /var/cpanel/cpanel.config
sed -i '/allowremotedomains/c\allowremotedomains=1' /var/cpanel/cpanel.config
sed -i '/allowunregistereddomains/c\allowunregistereddomains=1' /var/cpanel/cpanel.config
sed -i '/empty_trash_days/c\empty_trash_days=1' /var/cpanel/cpanel.config
sed -i '/publichtmlsubsonly/c\publichtmlsubsonly=0' /var/cpanel/cpanel.config
sed -i '/defaultmailaction/c\defaultmailaction=fail' /var/cpanel/cpanel.config
sed -i '/phploader/c\phploader=ioncube' /var/cpanel/cpanel.config
sed -i '/pma_disableis/c\pma_disableis=1' /var/cpanel/cpanel.config
sed -i '/skipbwlimitcheck/c\skipbwlimitcheck=0' /var/cpanel/cpanel.config
