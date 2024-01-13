#!/bin/bash

# Define the profile JSON data
profile_data='{
    "version": 0.9,
    "desc": "This is the MPM Worker cPanel profile plus every supported PHP version and each version’s options (sans recode and zendguard due to incompatibilities). This package can host multiple sites and users.",
    "name": "All PHP Options + OpCache",
    "tags": [
        "All PHP Opts",
        "Apache 2.4",
        "PHP 8.1",
        "PHP 8.2"
    ],
    "pkgs": [
        "ea-apache24",
        "ea-apr",
        "ea-apr-util",
        "ea-apache24-mod_mpm_worker",
        "ea-apache24-mod_ssl",
        "ea-apache24-mod_deflate",
        "ea-apache24-mod_expires",
        "ea-apache24-mod_headers",
        "ea-apache24-mod_proxy",
        "ea-apache24-mod_cgid",
        "ea-apache24-mod_suexec",
        "ea-apache24-mod_suphp",
        "ea-apache24-mod_security2",
        "ea-apache24-mod_proxy_fcgi",
        "ea-php72",
        "ea-php73",
        "ea-php74",
        "ea-php80",
        "ea-php81",
        "ea-php82",
        "ea-php83"
    ]
}'

# Specify the file path
file_path="/etc/cpanel/ea4/profiles/cpanel/allphp-opcache.json"

# Write the profile data to the file
echo "$profile_data" > "$file_path"

# Run the ea_install_profile command
/usr/local/bin/ea_install_profile --install "$file_path"

echo "Profile installation completed."
