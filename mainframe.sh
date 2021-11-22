#!/bin/bash

########verificare RAM,	nu va functiona	cu mai putin de	2GB##########
#awk '/Mem:/ {print $2}' < (free -m) > freem
#freem=$(cat ./freem)
#if [ "$freem" -gt "2000" ]
#then
#    	echo "Serverul are $freem MB RAM, continuam instalarea!"
#        sleep 2

#else
#   	echo "Serverul nu are suficient RAM, scriptul va functiona doar cu 2GB+ RAM!"
#        sleep 2
#        exit
#fi
#############final verificare ram##############

systemctl mask firewalld
systemctl stop firewalld
yum -y install iptables-services
systemctl enable iptables
systemctl stop iptables

#####Updateuri####
yum install epel-release -y
yum install nano mc wget screen openssh-clients tcpdump nmap iptraf iftop iotop telnet e2fsprogs rsyslog gcc htop atop -y
yum -y update

sed -i '/SELINUX=permissive/c\SELINUX=disabled' /etc/selinux/config

cd /home
wget -N http://layer1.cpanel.net/latest
chmod 0755 latest
./latest


#########modificare port ssh restartam dupa instalare csf#############

sed -i '/#Port/c\Port 2112' /etc/ssh/sshd_config

#####Disable Cphulk######
rm -f /var/cpanel/hulkd/enabled

######setari eximconf##########
cd ~/cpanelinstall/
chmod o+x eximconf.sh
sh eximconfm.sh

######setari eximconf##########
cd ~/cpanelinstall/
chmod o+x tweakset.sh
sh tweakset.sh

#####adaugare port 26 exim##########
sed -i '/daemon_smtp_ports/s/$/ : 26/' /etc/exim.conf && service exim reload && service exim restart

#####dezactivae compile access########
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

#####install pure-ftpd#########
/usr/local/cpanel/scripts/setupftpserver pure-ftpd

######setare timp si timezone##########
timedatectl set-timezone "Europe/Bucharest"

######setari awstats##########
cd ~/cpanelinstall/
chmod o+x awstats.sh
sh awstats.sh

###############disable AUTOSSL###############
> /var/cpanel/autossl.json
echo '{"provider":null,"_schema_version":1}' >> /var/cpanel/autossl.json
#####instalare apache4 all si opcache#####
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/cpanel/allphp-opcache.json

#####modifica handlere############
/usr/local/cpanel/bin/rebuild_phpconf --ea-php73=suphp
/usr/local/cpanel/bin/rebuild_phpconf --ea-php74=suphp
/usr/local/cpanel/bin/rebuild_phpconf --ea-php80=suphp

###modifica optiuni multiphp#######
cd ~/cpanelinstall/
chmod o+x multiphp.sh
sh multiphp.sh

######SQLMODE#######
cd ~/cpanelinstall/
service mysqld stop
cat ~/cpanelinstall/sqlmode >> /etc/my.cnf
service mysqld start

########instalare csf, adaugare ipuri si modificare conf##########
cd ~/cpanelinstall/
chmod o+x csfinstalledit.sh
sh csfinstalledit.sh


#############owasp instal_enable_update###########

/usr/local/cpanel/scripts/modsec_vendor add http://httpupdate.cpanel.net/modsecurity-rules/meta_OWASP3.yaml

######disable webalizer si analog ###############

echo 'analog=0' >> /var/cpanel/features/default
echo 'webalizer=0' >> /var/cpanel/features/default
/usr/local/cpanel/scripts/restartsrv_*

########adaugare cheie ansible#############

mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAABAEA0161H3xccH7lEwmYcvDpfuj1txMmOLEvsbFFb+Sus/BAkIAdzf/42rObfmg+9ddqpfuFm0NC5mKflFJq8Um5miKol8jl7C30FLkusWs7nNK2eF0p8tmpKPwwP5hjwgr5btGEJOCUzBGOYpgvbzxg3yniqUABf+ylrIXzw4mhFducoAS8Yh3+NSEiduqShgt9IIQiIyjq+moxitOyOtVjdPYnXudyinZVofaIU3dsh4gDjTfUPHXWk4hE0MjIP0eefD/Ugvm3B8JBbGukx4ggUQAntHA2M92Ye+zr5oXQkEY2U177FnMNoPjBQAOpp9L6Se/vHUjZ1Q6Y6jNVetWhh9oyXm+G8x2TELdTC6kUQCrizd1zifHpPeAmIDqfL2MEfR3W9xTUDW0nDNmdo5uPIxw56cGfFBuGjRskLGsSxh63raeeTWJ0SxI2rX+DpnLBki53HgbbEdKQZtLn3PBrQauvHp1r89nu16kOUbDYbmNO+HQPMipnrvKbTrY3m64npGBXo70668UAOfU9O/PKmEPUI/gPCSsuhpN90RSsbYSegLUXbYCPi8vVllUIczoICKInP7770jUie7ykRN3ZXjlYXhZQ7YhuzYLj1ItNLywoflN+zXDKKlpK6zdFDFTTHz0vrespU6Coe3wiIV0u0rdZvxrTX4ceAusgp+4MurswQNe0yCySc/GQrNfYyVSuuXHvFbl2o7LmXYwCPAyxo3TJdmTeiNMUL9FbPisxaqNA2KqjX8rIQGmhOT6GmT3XRiEkSH2ELM1fPtqsDss9DITrMU+E8ldHIOalyT0D15Q5uxXQ4Dk+oOXIZ60Q3OW8QDJo5uZdjyQoppA0udsxBgRANb4uWsJOPMS7psqFXO+TUQgkhfx27AGiTA+Xo8cAg0L4rzJxpfCyZUB/2xZp6CPB9RDRlGTMxTdjOj3Li9drBK4elE6gKL4FtPQYfr3ywYoTUxGwAkBPQ1H8dAmSSAxfNZw3UqEwZkHFi3PMVn/yGUOI1vw7L9AUWQdp+wkZp3vSgxWH4EEyUTs3K6PDon8i5H2tot36HvP89rZgtIXMlO37yDRbg5CWYUwmUJfx6CaX1b5AqCtDBQgT8q1CvLZKmpT9X+2GrgE5DACXXPyPORxA9QyqzXWcxAKakdMrU2Ujn1Onbxsbb1NqqV6nHBY+57U4V5KBc4uV7fB54XQNJ41VWViGrygr4qoqmXI35etqEj6tPd1mOWVH13qZkSNm9KrNDkckxVaRYl9vNRUKFPEqgkk5qhoBFaiOmfS4Dax1V/1CHwVtPO1HLKBuCxWCVY9mZDiW64bmTiNN+Krow2VhfKamJzA1ORlDXXrrdnDekedU/9e20LF2ZpKhBQ== AnsVPS" >> ~/.ssh/authorized_keys



######adaugare cron stergere sesiuni abandonate#############
echo "#Ansible: Close abandoned systemd sessions
*/10 * * * * root /usr/bin/systemctl | grep "abandoned" | sed "s/\.scope.*/.scope/" | /usr/bin/xargs systemctl stop  /dev/null 2>&1" > /etc/cron.d/close_abandoned_systemd_sessions

wget --no-check-certificate ="Authorization: Bearer Mzc5NjM3MzYwMzI0OsA3q4cQJf66YWHdsGc7tTxA1SSW" https://bitbucket.mxserver.ro/projects/SM/repos/clean-session-files-cpanel-shared/raw/install_clean_session_files.sh -O /root/install_clean_session_files.sh && sh /root/install_clean_session_files.sh

########setare logrotate pentru logurile care permit#############
cat ~/cpanelinstall/logrotateconf >> /etc/logrotate.conf
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

echo 'Instalarea a fost efectuata cu success!!!Urmeaza reboot final.pwp'
########load avarage din w cu print pe char row 10/11/12#####
echo 'Loadul actual este' && w | awk '/load average/ { printf "%s %s %s\n", $10, $11, $12 }'

sleep 10

cd ~
rm -rf cpanelinstall/

reboot
