#!/bin/bash

# Function to modify PHP configuration values for a given version
modify_php_config() {
    local php_version=$1
    local config_file="/opt/cpanel/ea-php${php_version}/root/etc/php.ini"

    sed -i '/disable_functions =/c\disable_functions = \"exec,passthru,shell_exec,system,proc_open,popen,show_source\"' $config_file
    sed -i '/open_basedir =/c\open_basedir = \"\/home:\/usr\/lib\/php:\/usr\/local\/lib\/php:\/tmp:\/var\/cpanel\/php\/sessions\/ea-php'"${php_version}$
    sed -i '/max_execution_time/c\max_execution_time = 3600' $config_file
    sed -i '/max_input_time/c\max_input_time = 3600' $config_file
    sed -i '/max_input_vars/c\max_input_vars = 10000' $config_file
    sed -i '/memory_limit/c\memory_limit = 2048M' $config_file
    sed -i '/upload_max_filesize/c\upload_max_filesize = 512M' $config_file
    sed -i '/post_max_size/c\post_max_size = 1024M' $config_file
    sed -i '/date.timezone = /c\date.timezone = \"Europe\/Bucharest\"' $config_file
    sed -i '/allow_url_fopen =/c\allow_url_fopen = On' $config_file
    sed -i '/display_errors =/c\display_errors = On' $config_file

    echo "Configurations updated for PHP $php_version"
}

# Loop through PHP versions including 5.6, 7.4, and 8.0 to 8.3
for php_version in 56 74 {80..83}; do
    modify_php_config "$php_version"
done
