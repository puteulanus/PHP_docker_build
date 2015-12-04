FROM tutum/centos:6.5
MAINTAINER Puteulanus <ex@mple.com>
RUN yum update -y
ADD php.sh /root/php.sh
RUN bash /root/php.sh