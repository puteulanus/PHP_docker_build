FROM tutum/centos:centos6
MAINTAINER Puteulanus <ex@mple.com>
CMD yum update -y
ADD php.sh /tmp/php.sh
CMD /tmp/php.sh
ADD add-on.sh /tmp/add-on.sh
CMD /tmp/php.sh
#EXPOSE 22
#EXPOSE 80