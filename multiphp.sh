#!/bin/bash

sed -i '/disable_functions =/c\disable_functions = \"exec,passthru,shell_exec,system,proc_open,popen,show_source\"' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/open_basedir =/c\open_basedir = \"\/home:\/usr\/lib\/php:\/usr\/local\/lib\/php:\/tmp:\/var\/cpanel\/php\/sessions\/ea-php82:\/usr\/local\/lsws\"' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/max_execution_time/c\max_execution_time = 3600' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/max_input_time/c\max_input_time = 3600' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/max_input_vars/c\max_input_vars = 10000' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/memory_limit/c\memory_limit = 2048M' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/upload_max_filesize/c\upload_max_filesize = 512M' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/post_max_size/c\post_max_size = 1024M' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/date.timezone = /c\date.timezone = \"Europe\/Bucharest\"' /opt/cpanel/ea-php82/root/etc/php.ini

sed -i '/disable_functions =/c\disable_functions = \"exec,passthru,shell_exec,system,proc_open,popen,show_source\"' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/open_basedir =/c\open_basedir = \"\/home:\/usr\/lib\/php:\/usr\/local\/lib\/php:\/tmp:\/var\/cpanel\/php\/sessions\/ea-php80:\/usr\/local\/lsws\"' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/max_execution_time/c\max_execution_time = 3600' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/max_input_time/c\max_input_time = 3600' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/max_input_vars/c\max_input_vars = 10000' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/memory_limit/c\memory_limit = 2048M' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/upload_max_filesize/c\upload_max_filesize = 512M' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/post_max_size/c\post_max_size = 1024M' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/date.timezone = /c\date.timezone = \"Europe\/Bucharest\"' /opt/cpanel/ea-php80/root/etc/php.ini

sed -i '/disable_functions =/c\disable_functions = \"exec,passthru,shell_exec,system,proc_open,popen,show_source\"' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/open_basedir =/c\open_basedir = \"\/home:\/usr\/lib\/php:\/usr\/local\/lib\/php:\/tmp:\/var\/cpanel\/php\/sessions\/ea-php81:\/usr\/local\/lsws\"' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/max_execution_time/c\max_execution_time = 3600' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/max_input_time/c\max_input_time = 3600' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/max_input_vars/c\max_input_vars = 10000' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/memory_limit/c\memory_limit = 2048M' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/upload_max_filesize/c\upload_max_filesize = 512M' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/post_max_size/c\post_max_size = 1024M' /opt/cpanel/ea-php81/root/etc/php.ini

sed -i '/date.timezone = /c\date.timezone = \"Europe\/Bucharest\"' /opt/cpanel/ea-php81/root/etc/php.ini
