#!/bin/bash

echo 'options timeout:1 attempts:1 rotate' > /etc/resolv.conf
echo 'nameserver 114.114.114.114' >> /etc/resolv.conf
echo 'nameserver 114.114.115.115' >> /etc/resolv.conf

cp /etc/yum.conf /etc/yum.conf.bak
echo 'proxy=http://:' >> /etc/yum.conf
echo 'proxy_username=' >> /etc/yum.conf
echo 'proxy_password=' >> /etc/yum.conf

bash /tmp/php.sh
bash /tmp/startup.sh

rm /etc/yum.conf -f
cp /etc/yum.conf.bak /etc/yum.conf