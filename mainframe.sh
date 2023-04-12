#!/bin/bash

########Verificare RAM,	sunt necesari minim	2GB RAM##########
#awk '/Mem:/ {print $2}' < (free -m) > freem
#freem=$(cat ./freem)
#if [ "$freem" -gt "2000" ]
#then
#    	echo "Serverul are $freem MB RAM, continuam instalarea!"
#        sleep 2

#else
#   	echo "Serverul nu are suficient RAM, scriptul functioneaza doar cu minim 2GB RAM!"
#        sleep 2
#        exit
#fi
#############Final verificare RAM##############
echo "nameserver 8.8.8.8" >> /etc/resolv.conf && echo "nameserver 8.8.4.4" >> /etc/resolv.conf
#############Actualizare MySQL GPG Keys##############
#rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
#############Final actualizare MySQL GPG Keys##############

systemctl mask firewalld
systemctl stop firewalld
yum -y install iptables-services
systemctl enable iptables
systemctl stop iptables

#####Actualizari/Updates####
yum install epel-release -y
yum install nano mc wget screen openssh-clients tcpdump nmap iptraf iftop iotop telnet e2fsprogs rsyslog gcc htop atop -y
yum -y update

sed -i '/SELINUX=permissive/c\SELINUX=disabled' /etc/selinux/config

#####Selectare Stable tier####
touch /etc/cpupdate.conf
echo "CPANEL=release" > /etc/cpupdate.conf
#####Final selectare Stable tier####
#####Selectare MariaDB 10.6####
mkdir /root/cpanel_profile
touch /root/cpanel_profile/cpanel.config
echo "mysql-version=10.6" > /root/cpanel_profile/cpanel.config
#####Final selectare MariaDB 10.6####

cd /home
wget -N http://layer1.cpanel.net/latest
chmod 0755 latest
./latest


#########Modificare port ssh restartam dupa instalare CSF#############

sed -i '/#Port/c\Port 2112' /etc/ssh/sshd_config

#####Disable Cphulk######
rm -f /var/cpanel/hulkd/enabled

######Setari eximconf##########
cd ~/mxhcp/
chmod o+x eximconf.sh
sh eximconfm.sh

######Setari eximconf##########
cd ~/mxhcp/
chmod o+x tweakset.sh
sh tweakset.sh

#####Adaugare port 26 exim##########
sed -i '/daemon_smtp_ports/s/$/ : 26/' /etc/exim.conf && service exim reload && service exim restart

#####Dezactivare compile access########
chmod 0750 /usr/bin/gcc && chown root:compiler /usr/bin/gcc


######Activeaza shell fork bomb protection##########
/usr/local/cpanel/bin/install-login-profile --install limits


##########Kill process###########
cat >/var/cpanel/killproc.conf <<EOF
BitchX
bnc
eggdrop
generic-sniffers
guardservices
ircd
psyBNC
ptlink
services
EOF

#####Install pure-ftpd#########
/usr/local/cpanel/scripts/setupftpserver pure-ftpd

#####Setare BIND ca server DNS#####
yes | /scripts/setupnameserver bind

######Setare timp si timezone##########
timedatectl set-timezone "Europe/Bucharest"

######Setari awstats##########
cd ~/mxhcp/
chmod o+x awstats.sh
sh awstats.sh

###############Disable AUTOSSL###############
> /var/cpanel/autossl.json
echo '{"provider":null,"_schema_version":1}' >> /var/cpanel/autossl.json
#####Instalare apache4 all si opcache#####
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/cpanel/allphp-opcache.json

#####Modifica handlere############
/usr/local/cpanel/bin/rebuild_phpconf --ea-php74=suphp
/usr/local/cpanel/bin/rebuild_phpconf --ea-php80=suphp
/usr/local/cpanel/bin/rebuild_phpconf --ea-php81=suphp

###Modifica optiuni multiphp#######
cd ~/mxhcp/
chmod o+x multiphp.sh
sh multiphp.sh

######SQLMODE#######
cd ~/mxhcp/
service mysqld stop
cat /dev/null > /etc/my.cnf
cat ~/mxhcp/sqlmode >> /etc/my.cnf
/scripts/restartsrv_mysql

########Instalare CSF, adaugare IP-uri si modificare conf##########
cd ~/mxhcp/
chmod o+x csfinstalledit.sh
sh csfinstalledit.sh

#############OWASP instal_enable_update###########

/usr/local/cpanel/scripts/modsec_vendor add http://httpupdate.cpanel.net/modsecurity-rules/meta_OWASP3.yaml

######Disable webalizer si analog ###############

echo 'analog=0' >> /var/cpanel/features/default
echo 'webalizer=0' >> /var/cpanel/features/default
/usr/local/cpanel/scripts/restartsrv_*

########Adaugare cheie ansible#############

mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAABAEA0161H3xccH7lEwmYcvDpfuj1txMmOLEvsbFFb+Sus/BAkIAdzf/42rObfmg+9ddqpfuFm0NC5mKflFJq8Um5miKol8jl7C30FLkusWs7nNK2eF0p8tmpKPwwP5hjwgr5btGEJOCUzBGOYpgvbzxg3yniqUABf+ylrIXzw4mhFducoAS8Yh3+NSEiduqShgt9IIQiIyjq+moxitOyOtVjdPYnXudyinZVofaIU3dsh4gDjTfUPHXWk4hE0MjIP0eefD/Ugvm3B8JBbGukx4ggUQAntHA2M92Ye+zr5oXQkEY2U177FnMNoPjBQAOpp9L6Se/vHUjZ1Q6Y6jNVetWhh9oyXm+G8x2TELdTC6kUQCrizd1zifHpPeAmIDqfL2MEfR3W9xTUDW0nDNmdo5uPIxw56cGfFBuGjRskLGsSxh63raeeTWJ0SxI2rX+DpnLBki53HgbbEdKQZtLn3PBrQauvHp1r89nu16kOUbDYbmNO+HQPMipnrvKbTrY3m64npGBXo70668UAOfU9O/PKmEPUI/gPCSsuhpN90RSsbYSegLUXbYCPi8vVllUIczoICKInP7770jUie7ykRN3ZXjlYXhZQ7YhuzYLj1ItNLywoflN+zXDKKlpK6zdFDFTTHz0vrespU6Coe3wiIV0u0rdZvxrTX4ceAusgp+4MurswQNe0yCySc/GQrNfYyVSuuXHvFbl2o7LmXYwCPAyxo3TJdmTeiNMUL9FbPisxaqNA2KqjX8rIQGmhOT6GmT3XRiEkSH2ELM1fPtqsDss9DITrMU+E8ldHIOalyT0D15Q5uxXQ4Dk+oOXIZ60Q3OW8QDJo5uZdjyQoppA0udsxBgRANb4uWsJOPMS7psqFXO+TUQgkhfx27AGiTA+Xo8cAg0L4rzJxpfCyZUB/2xZp6CPB9RDRlGTMxTdjOj3Li9drBK4elE6gKL4FtPQYfr3ywYoTUxGwAkBPQ1H8dAmSSAxfNZw3UqEwZkHFi3PMVn/yGUOI1vw7L9AUWQdp+wkZp3vSgxWH4EEyUTs3K6PDon8i5H2tot36HvP89rZgtIXMlO37yDRbg5CWYUwmUJfx6CaX1b5AqCtDBQgT8q1CvLZKmpT9X+2GrgE5DACXXPyPORxA9QyqzXWcxAKakdMrU2Ujn1Onbxsbb1NqqV6nHBY+57U4V5KBc4uV7fB54XQNJ41VWViGrygr4qoqmXI35etqEj6tPd1mOWVH13qZkSNm9KrNDkckxVaRYl9vNRUKFPEqgkk5qhoBFaiOmfS4Dax1V/1CHwVtPO1HLKBuCxWCVY9mZDiW64bmTiNN+Krow2VhfKamJzA1ORlDXXrrdnDekedU/9e20LF2ZpKhBQ== AnsVPS" >> ~/.ssh/authorized_keys

########Setare logrotate pentru logurile care permit#############
cat ~/mxhcp/logrotateconf >> /etc/logrotate.conf
#####Editare crontaburi pentru sters loguri necuprinse in logrotate############
  
crontab -l | { cat; echo "0 1 * * * find /home . -name 'error_log' -exec rm {} \; > /dev/null 2>&1"; } | crontab -
crontab -l | { cat; echo "45 3 * * * > /var/log/stderr.log"; } | crontab -
crontab -l | { cat; echo "0 3 * * 0 rm -rf /usr/local/apache/logs/archive/*"; } | crontab -
crontab -l | { cat; echo "45 3 * * 0 rm -rf /usr/local/apache/domlogs/*"; } | crontab -
crontab -l | { cat; echo "15 3 * * 0 rm -rf /var/log/*.gz"; } | crontab -
crontab -l | { cat; echo "30 3 * * 0 rm -rf /var/log/*-20*"; } | crontab -
crontab -l | { cat; echo "20 3 * * 0 rm -rf /tmp/*"; } | crontab -

sed -i '/allow_url_fopen = /c\allow_url_fopen = On' /opt/cpanel/ea-php*/root/etc/php.ini
sed -i '/allow_url_include = /c\allow_url_fopen = On' /opt/cpanel/ea-php*/root/etc/php.ini
sed -i '/memory_limit/c\memory_limit = 2048M' /opt/cpanel/ea-php*/root/etc/php.ini

########Instalare ImunifyAV + Activare modul in cPanel#############
wget https://repo.imunify360.cloudlinux.com/defence360/imav-deploy.sh -O imav-deploy.sh
sh imav-deploy.sh
/usr/share/av-userside-plugin.sh
########Final instalare ImunifyAV + Activare modul in cPanel#############

########Instalare Wordpress Toolkit#############
curl https://wp-toolkit.plesk.com/cPanel/installer.sh | sh
########Finae instalare Wordpress Toolkit#############

########Setare session save path si tmp dir in PHP-FPM#############
echo "php_value_session_save_path: { name: 'php_value[session.save_path]', value: \"/var/cpanel/php/sessions/[% ea_php_version %]\" }" >> /var/cpanel/ApachePHPFPM/system_pool_defaults.yaml
echo "php_value_upload_tmp_dir: { name: 'php_value[upload_tmp_dir]', value: \"[% homedir %]/tmp\" }" >> /var/cpanel/ApachePHPFPM/system_pool_defaults.yaml
/scripts/php_fpm_config --rebuild
/scripts/restartsrv_httpd
########Final setare session save path si tmp dir in PHP-FPM#############

#####Demian######
whmapi1 set_tweaksetting key=resetpass value=0 && whmapi1 set_tweaksetting key=resetpass_sub value=0
#####Final Demian######

########Acceptare EULA########
whmapi1 accept_eula
########Final acceptare EULA########

########Fixare hostname server########
hostname -f > /root/hostname
/usr/local/cpanel/bin/set_hostname $(cat /root/hostname)
rm -f /root/hostname
########Final fixare hostname server########

########Setare EXIM on another port + Refresh certificate SSL servicii########
whmapi1 configureservice service=exim-altport enabled=1 monitored=1
whmapi1 configureservice service=p0f enabled=0 monitored=0
whmapi1 reset_service_ssl_certificate service='ftp'
whmapi1 reset_service_ssl_certificate service='exim'
whmapi1 reset_service_ssl_certificate service='dovecot'
whmapi1 reset_service_ssl_certificate service='cpanel'
########Final setare EXIM on another port + Refresh certificate SSL servicii########
service nftables stop
systemctl disable nftables.service
systemctl mask nftables.service
service csf restart
rm -f /etc/csf/csf.error
service csf start
service sshd restart

echo ""
echo "               __                ______      ____        "
echo "   _______  __/ /_  ___  _____  / ____/___  / / /_______ "
echo "  / ___/ / / / __ \/ _ \/ ___/ / /_  / __ \/ / //_/ ___/ "
echo " / /__/ /_/ / /_/ /  __/ /    / __/ / /_/ / / ,< (__  )  "
echo " \___/\__, /_.___/\___/_/____/_/    \____/_/_/|_/____/   "
echo "     /____/            /_____/                           "
echo ""
echo 'Instalarea a fost efectuata cu success!!!'
echo ""
echo 'Pentru probleme si sugestii referitoare la script, trimite mail la adrian.rus@mxh.ro'
echo ""

cd ~
rm -rf mxhcp/ && cd ~
