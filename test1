#!/bin/bash

sudo apt update

export DEBIAN_FRONTEND=noninteractive

echo -e " 
slapd slapd/internal/generated_adminpw password test
slapd slapd/no_configuration boolean false
slapd slapd/invalid_config boolean true
slapd slapd/domain string wisc.cloudlab.us
slapd slapd/organization string wisc.cloudlab.us
slapd slapd/internal/adminpw password test
slapd slapd/backend select MDB
slapd slapd/purge_database boolean true
slapd slapd/dump_databse_destdir string /var/backups/slapd-VERSION
slapd slapd/dump_databse select when needed
slapd slapd/move_old_database boolean true
slapd slapd/password2 password test
slapd slapd/password1 password test
slapd slapd/password_mismatch note
slapd slapd/policy_schema_needs_update select abort installation
slapd slapd/unsafe_selfwrite_acl note
slapd slapd/upgrade_slapcat_failure error
slapd slapd/allow_ldap_v2 boolean false
" | sudo debconf-set-selections


sudo apt-get install -y slapd ldap-utils
#sudo dpkg-reconfigure slapd
sudo ufw allow ldap
ldapadd -x -D cn=admin,dc=clemson,dc=cloudlab,dc=us -w pkhadse -f basedn.ldif

#echo   -n  PASS=$(slappasswd -s rammy) | awk '{print PASS}'
PASS=$(slappasswd -s rammy)
cat <<EOF >/local/repository/users.ldif
dn: uid=student,ou=People,dc=clemson,dc=cloudlab,dc=us
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: student
sn: Ram
givenName: Golden
cn: student
displayName: student
uidNumber: 10000
gidNumber: 5000
userPassword: $PASS
gecos: Golden Ram
loginShell: /bin/dash
homeDirectory: /home/student
EOF
