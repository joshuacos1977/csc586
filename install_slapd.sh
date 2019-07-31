#!/bin/bash

sudo apt update
# Install openLDAP server quietly
export DEBIAN_FRONTEND='non-interactive'
echo -e "slapd slapd/root_password password admin" | sudo debconf-set-selections
echo -e "slapd slapd/root_password_again password admin" | sudo debconf-set-selections
echo -e "slapd slapd/internal/adminpw password admin" | sudo debconf-set-selections
echo -e "slapd slapd/internal/generated_adminpw password admin" | sudo debconf-set-selections
echo -e "slapd slapd/password2 password admin" | sudo debconf-set-selections
echo -e "slapd slapd/password1 password admin" | sudo debconf-set-selections
echo -e "slapd slapd/domain string clemson.cloudlab.us" | sudo debconf-set-selections
echo -e "slapd shared/organization string WestChester" | sudo debconf-set-selections
echo -e "slapd slapd/backend string MDB" | sudo debconf-set-selections
echo -e "slapd slapd/purge_database boolean false" | sudo debconf-set-selections
echo -e "slapd slapd/move_old_database boolean true" | sudo debconf-set-selections
echo -e "slapd slapd/allow_ldap_v2 boolean false" | sudo debconf-set-selections
echo -e "slapd slapd/no_configuration boolean false" | sudo debconf-set-selections

# Grab slapd and ldap-utils (pre-seeded)
sudo apt-get install -y slapd ldap-utils

