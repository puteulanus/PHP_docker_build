FROM tutum/centos:centos6
MAINTAINER Puteulanus <ex@mple.com>
RUN yum update -y
ADD php.sh /tmp/php.sh
RUN bash /tmp/php.sh
ADD add-on.sh /tmp/add-on.sh
RUN bash /tmp/add-on.sh
CMD /run.sh
EXPOSE 22
EXPOSE 80