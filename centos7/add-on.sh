#!/bin/bash

sed -i '1 i\service nginx start' /run.sh
sed -i '1 i\service php-fpm start' /run.sh
