FROM tutum/centos:centos6
MAINTAINER Puteulanus <ex@mple.com>
RUN yum update -y
ADD php.sh /root/php.sh
RUN bash /root/php.sh
EXPOSE 22
EXPOSE 80