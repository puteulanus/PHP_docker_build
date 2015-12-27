#!/bin/bash

# Install supervisor
yum install python-setuptools -y
easy_install supervisor

# Configure
mkdir -p /var/log/mysql
mkdir /etc/supervisord.d
echo_supervisord_conf > /etc/supervisord.conf
echo '[include]' >> /etc/supervisord.conf
echo 'files = supervisord.d/*.ini' >> /etc/supervisord.conf

cat << _EOF_ >"/etc/supervisord.d/nginx-php.ini"
[program:php-fpm]
command=/usr/sbin/php-fpm -c /etc/php-fpm.conf

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
_EOF_

cat << _EOF_ >"/etc/supervisord.d/mysql.ini"
[program:mysqld]
command=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/bin/mysqld_safe --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --log-error=/var/log/mysql/error.log --socket=/var/run/mysqld/mysqld.sock --port=3306
user=mysql
_EOF_