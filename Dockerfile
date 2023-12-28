FROM registry.access.redhat.com/ubi8/ubi:8.0

MAINTAINER Red Hat Training <training@redhat.com>

LABEL io.k8s.description="A basic Apache HTTP Server" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

# DocumentRoot for Apache

ENV DOCROOT=/var/www/html

RUN yum install -y --disableplugin=subscription-manager httpd \
&& yum clean all --disableplugin=subscription-manager -y

RUN  echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

ONBUILD COPY src/ ${DOCROOT}/

# Allows child images to inject their own content into DocumentRoot

EXPOSE 8080

# This stuff is needed to ensure a clean start

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf \
&& sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" \
    /etc/httpd/conf/httpd.conf

RUN chgrp -R 0 /var/log/httpd /var/run/httpd \ 
&& chmod -R g=u /var/log/httpd /var/run/httpd

RUN rm -rf /run/httpd && mkdir /run/httpd

# Launch httpd

CMD /usr/sbin/httpd -DFOREGROUND
