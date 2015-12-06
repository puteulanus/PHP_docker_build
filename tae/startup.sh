#!/bin/bash

# 启动Nginx
echo '/usr/sbin/nginx -c /etc/nginx/nginx.conf' >> /ace/bin/start
# 安装supervisor
yum install -y python-setuptools
easy_install pip
pip install supervisor

echo '/usr/sbin/php-fpm --nodaemonize & >/dev/null 2>&1' >> /ace/bin/start