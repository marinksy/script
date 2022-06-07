#!/bin/bash

cd /usr/src
rm -fv csf.tgz
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh
cd /home/
wget https://download.configserver.com/cmq.tgz
tar -xzf cmq.tgz
cd cmq/
sh install.sh
cd /usr/src
rm -fv /usr/src/cmm.tgz
wget http://download.configserver.com/cmm.tgz
tar -xzf cmm.tgz
cd cmm
sh install.sh
rm -Rfv /usr/src/cmm*
cd /usr/src
rm -fv /usr/src/cmc.tgz
wget http://download.configserver.com/cmc.tgz
tar -xzf cmc.tgz
cd cmc
sh install.sh
rm -Rfv /usr/src/cmc*

csf -r

sed -i '/TCP_IN = "20/c\TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995,2077,2078,2079,2080,2082,2083,2086,2087,2095,2096,8443,26,49152:65534,7080,2112"' /etc/csf/csf.conf
sed -i '/TESTING = "1"/c\TESTING = "0"' /etc/csf/csf.conf
sed -i '/RESTRICT_SYSLOG = "0"/c\RESTRICT_SYSLOG = "2"' /etc/csf/csf.conf

sed -i '/# .configserver.com/c\.configserver.com' /etc/csf/csf.rignore
sed -i '/# www.configserver.com/c\www.configserver.com' /etc/csf/csf.rignore
sed -i '/# .configserver.co.uk/c\.configserver.co.uk' /etc/csf/csf.rignore
sed -i '/# .crawl.yahoo.net/c\.crawl.yahoo.net' /etc/csf/csf.rignore
sed -i '/# .search.msn.com/c\.search.msn.com' /etc/csf/csf.rignore
sed -i '/# .googlebot.com/c\.googlebot.com' /etc/csf/csf.rignore

csf -x && csf -e

csf -a 5.2.174.151 Birou RDS si VPN
csf -a 82.78.34.196 Adi
csf -a 89.120.111.179 birou telecom
csf -a 91.195.28.4 birou Cluj

