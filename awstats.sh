#!/bin/bash
echo 'ALLOWALL=yes' >> /etc/stats.conf
echo 'allow_awstats_include=1' >> /etc/stats.conf
sed -i '/DEFAULTGENS/c\DEFAULTGENS=AWSTATS' /etc/stats.conf
