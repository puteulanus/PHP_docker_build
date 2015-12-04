#!/bin/bash
# 设定
url="debug.puteulanus.com"
# 安装MariaDB
cat << _EOF_ >/etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
_EOF_
yum install -y MariaDB-server MariaDB-client
# 安装Nginx
yum remove -y httpd
cat << _EOF_ >/etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/x86_64/
gpgcheck=0
enabled=1
_EOF_
yum install -y nginx
fuser -k 80/tcp
chkconfig --levels 235 nginx on
/etc/init.d/nginx start
# 安装PHP
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sed -i -e '/\[remi\]/,/^\[/s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo
sed -i -e '/\[remi\-php56\]/,/^\[/s/enabled=0/enabled=1/' /etc/yum.repos.d/remi.repo
yum install -y php-fpm php-cli php-mysql php-gd php-imap \
php-ldap php-odbc php-pear php-xml php-xmlrpc \
php-magickwand php-mbstring php-mcrypt php-devel \
php-mssql php-shout php-snmp php-soap php-tidy
chkconfig --levels 235 php-fpm on
/etc/init.d/php-fpm start
# 配置Nginx
groupadd www
useradd -g www www
usermod -s /sbin/nologin www
mkdir -p /usr/www/"${url}"/{public_html,logs}
chmod -R +w /usr/www/
chown -R www:www /usr/www/
chmod a+w /usr/www/"${url}"/public_html
sed -i "s/#user  nobody/user  www www/g" /etc/nginx/nginx.conf
sed -i "s/#worker_processes  1/worker_processes  4/g" /etc/nginx/nginx.conf
sed -i "s/#error_log  logs\/error.log/error_log  logs\/error.log crit/g" /etc/nginx/nginx.conf
sed -i "s/#pid/pid/g" /etc/nginx/nginx.conf
#sed -i "s/worker_connections  1024/worker_connections  65535/g" /etc/nginx/nginx.conf
sed -i '/worker_connections/ i use epoll;' /etc/nginx/nginx.conf
cd /etc/nginx/
ldconfig
/etc/init.d/nginx restart
# 配置测试站点
cd /root
cat << _EOF_ >"/etc/nginx/conf.d/${url}.conf"
server {
server_name ${url};
listen 80;
root /usr/www/${url}/public_html;
access_log /usr/www/${url}/logs/access.log;
error_log /usr/www/${url}/logs/error.log;
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
/etc/init.d/nginx restart
# 安装调试器
yum install -y gcc gcc-c++ autoconf automake
#pear config-set php_ini /etc/php.ini
pecl install Xdebug
cat << _EOF_ >>"/etc/php.ini"

[Xdebug]
zend_extension="xdebug.so"
xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9001
xdebug.profiler_enable=1
xdebug.profiler_output_dir="/tmp"
_EOF_
/etc/init.d/php-fpm restart
#cd /tmp
#wget 'http://downloads.zend.com/studio_debugger/2014_12_10/ZendDebugger-linux-x86_64.tar.gz'
#tar -zxf ZendDebugger-linux-x86_64.tar.gz
#mv ZendDebugger-linux-x86_64/php-5.6.x/ZendDebugger.so /usr/lib64/php/modules/
#cd ~
#cat << _EOF_ >>"/etc/php.ini"
#
#[Zend]
#zend_extension=ZendDebugger.so
#zend_debugger.allow_hosts=0.0.0.0
#zend_debugger.expose_remotely=allowed_host
#zend_debugger.tunnel_min_port=40000
#zend_debugger.tunnel_max_port=50000
#_EOF_
#/etc/init.d/php-fpm restart