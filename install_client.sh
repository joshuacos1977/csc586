#!/bin/bash

ADMIN_PASSWORD="admin"
#updates the system repository database
sudo apt update

#change the frontend to noninteractive for automation
#Provide the hostname of the node for LDAP server
#Provide dn for LDAP search base
#Provide default LDAP version 3
export DEBIAN_FRONTEND=noninteractive
echo "
ldap_auth_config        ldap_auth_config/bindpw password admin    
ldap_auth_config        ldap_auth_config/rootbindpw password admin
ldap-auth-config        ldap-auth-config/dbrootlogin    boolean true
ldap-auth-config        ldap-auth-config/pam_password   select  md5
ldap-auth-config        ldap-auth-config/move-to-debconf        boolean true
ldap_auth_config        ldap_auth_config/ldapns/base-dn string  dc=clemson,dc=cloudlab,dc=us
ldap_auth_config        ldap_auth_config/rootbinddn     string  cn=admin,dc=clemson,dc=cloudlab,dc=us
ldap_auth_config        ldap_auth_config/ldapns/ldap-server     string  ldap://192.168.1.1
ldap_auth_config        ldap_auth_config/ldapns/ldap_version    select  3
ldap_auth_config        ldap_auth_config/dblogin        boolean false
ldap_auth_config        ldap_auth_config/override       boolean true " | sudo debconf-get-selections

#installs libnss-ldap libpam-ldap ldap-utils along with all their dependencies
sudo apt install -y -q libnss-ldap -y libpam-ldap ldap-utils
#modify IP address
#modify search base
sudo sed -i 's/uri ldapi:\/\/\//uri ldap:\/\/192.168.1.1\//g' /etc/ldap.conf
sudo sed -i 's/base dc=example,dc=net/base dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
sudo sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=admin,dc=clemson,dc=cloudlab,dc=us/g' /etc/ldap.conf
#enable LDAP profile for NSS and add ldap  to end of the lines for passwd and group
sudo sed -i '/passwd:/ s/$/ ldap/' /etc/nsswitch.conf
sudo sed -i '/group:/ s/$/ ldap/' /etc/nsswitch.conf
#enable LDAP profile for PAM
#edit /etc/pam.d/common-sssion and add optional pam_mkhomedir
sudo sed -i '/# end of pam-auth-update config/ i session optional pam_mkhomedir.so  skel=/etc/skel  umask=077' /etc/pam.d/common-session
#edit /etc/pam.d/common-password and find line use_authok and remove that phrase from that line
sudo sed -i 's/use_authtok//g' /etc/pam.d/common-password
sudo bash <<EOF
#enter a root pasword to use when ldap-auth-config tries to login to the LDAP directory
echo $ADMIN_PASSWORD > /etc/ldap.secret
EOF
#make the file readable to rrot only
sudo chmod 600 /etc/ldap.secret

#auhtenticate student on ldapclient 
getent passwd student
sudo su - student

