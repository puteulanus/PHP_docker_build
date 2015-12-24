#!/bin/bash

# Install
yum install -y nginx

# Main Configure
groupadd www
useradd -g www www
usermod -s /sbin/nologin www
mkdir -p /usr/www/default/{public_html,logs}
chmod -R +w /usr/www/
chown -R www:www /usr/www/
chmod a+w /usr/www/default/public_html
sed -i "s/#user  nobody/user  www www/g" /etc/nginx/nginx.conf
sed -i "s/#worker_processes  1/worker_processes  4/g" /etc/nginx/nginx.conf
sed -i "s/#error_log  logs\/error.log/error_log  logs\/error.log crit/g" /etc/nginx/nginx.conf
sed -i "s/#pid/pid/g" /etc/nginx/nginx.conf
sed -i '/worker_connections/ i use epoll;' /etc/nginx/nginx.conf

# Site Configure
cat << _EOF_ >"/etc/nginx/conf.d/default.conf"
server {
listen 80 default_server;
root /usr/www/default/public_html;
access_log /usr/www/default/logs/access.log;
error_log /usr/www/default/logs/error.log;
index index.php;

location / {
try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
}

location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
access_log off;
expires max;
}

location ~ /\.ht {
deny  all;
}
location ~ \.php$ {
fastcgi_pass  127.0.0.1:9000;
fastcgi_index  index.php;
fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
include  fastcgi_params;
}

}
_EOF_