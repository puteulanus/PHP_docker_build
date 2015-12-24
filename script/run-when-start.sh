#!/bin/bash

# Install supervisor
yum install python-setuptools -y
easy_install pip
pip install supervisor

# Configure
cat << _EOF_ >"/etc/supervisord.d/nginx-php.conf"
[program:php-fpm]
command=/usr/sbin/php-fpm -c /etc/php-fpm.conf

[program:nginx]
command=/usr/sbin/nginx
_EOF_

cat << _EOF_ >"/etc/supervisord.d/mysql.conf"
[program:mysqld]
command=/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --log-error=/var/log/mysql/error.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306
_EOF_