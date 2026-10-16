FROM centos:7
RUN sed -i -e 's/^mirrorlist/#mirrorlist/' -e 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|' \
    /etc/yum.repos.d/CentOS-*.repo && yum -y update
RUN yum -y install httpd
COPY ./web /var/www/html
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]