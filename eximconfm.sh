#!/bin/bash

########Setari Exim configuration manager##########

sed -i '/acl_spamcop_rbl/c\acl_spamcop_rbl=1' /etc/exim.conf.localopts
sed -i '/acl_spamhaus_rbl/c\acl_spamhaus_rbl=1' /etc/exim.conf.localopts
sed -i '/use_rdns_for_helo/c\use_rdns_for_helo=0' /etc/exim.conf.localopts
sed -i '/custom_mailhelo/c\custom_mailhelo=1' /etc/exim.conf.localopts
sed -i '/custom_mailips/c\custom_mailips=1' /etc/exim.conf.localopts
touch /var/cpanel/custom_mailips
touch /var/cpanel/custom_mailhelo
sed -i '/require_secure_auth/c\require_secure_auth=0' /etc/exim.conf.localopts
/usr/local/cpanel/scripts/restartsrv_*
