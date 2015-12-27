FROM centos:centos7

# Add scripts
ADD script /tmp/script

# Update sources
RUN bash /tmp/script/source-update.sh

# Install MariaDB
RUN bash /tmp/script/mariadb-install.sh

# Install PHP
RUN bash /tmp/script/php-install.sh

# Install Nginx
RUN bash /tmp/script/nginx-install.sh

# Setup Startup
RUN bash /tmp/script/run-when-start.sh

# Expose Volumes

# Expose Ports
EXPOSE 80
EXPOSE 443

# RUN
CMD ["supervisord", "-nc", "/etc/supervisord.conf"]
