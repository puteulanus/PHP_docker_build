#!/bin/bash

# Install 
yum install -y php-fpm php-cli php-mysql php-gd php-imap \
php-ldap php-odbc php-pear php-xml php-xmlrpc \
php-magickwand php-mbstring php-mcrypt php-devel \
php-mssql php-shout php-snmp php-soap php-tidy php-pecl-ssh2

# Configure
sed -i "s/daemonize = yes/daemonize = no/" /etc/php-fpm.conf