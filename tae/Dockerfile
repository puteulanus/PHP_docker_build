# 编写你的Dockerfile 
RUN yum update -y
ADD php.sh /tmp/php.sh
ADD startup.sh /tmp/startup.sh
ADD remi-release-7.rpm /tmp/remi-release-7.rpm
ADD proxy.sh /tmp/proxy.sh
RUN bash /tmp/proxy.sh
# ADD add-on.sh /tmp/add-on.sh
# RUN bash /tmp/add-on.sh
EXPOSE 22
EXPOSE 80