FROM tutum/centos:centos6
MAINTAINER Puteulanus <ex@mple.com>
RUN yum update -y
ADD php.sh /tmp/php.sh
RUN /tmp/php.sh
ADD add-on.sh /tmp/add-on.sh
RUN /tmp/add-on.sh
#EXPOSE 22
#EXPOSE 80