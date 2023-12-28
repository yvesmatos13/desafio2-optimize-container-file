FROM registry.access.redhat.com/ubi8/ubi:8.0

MAINTAINER Red Hat Training <training@redhat.com>



#SOLUCAO - ALTERADO
#LABEL em apenas única linha.você remove a palava label e coloca uma \ 
LABEL io.k8s.description="A basic Apache HTTP Server" \
      io.k8s.display-name="Apache HTTP Server" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache, httpd"

# DocumentRoot for Apache

ENV DOCROOT=/var/www/html

#SOLUCAO - ALTERADO
#RUN em apenas única linha. Troque a palavra RUN por &&
RUN yum install -y --disableplugin=subscription-manager httpd && yum clean all --disableplugin=subscription-manager -y

RUN  echo "Hello from the httpd-parent container!" > ${DOCROOT}/index.html

# Allows child images to inject their own content into DocumentRoot
#SOLUCAO - ALTERADO
ONBUILD COPY src /${DOCROOT}/

EXPOSE 8080

# This stuff is needed to ensure a clean start

#SOLUCAO - ALTERADO
#RUN em apenas única linha. Troque a palavra RUN por &&
RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf \
&& sed -i "s/#ServerName www.example.com:80/ServerName 0.0.0.0:8080/g" \
    /etc/httpd/conf/httpd.conf

RUN chgrp -R 0 /var/log/httpd /var/run/httpd \ 
&& chmod -R g=u /var/log/httpd /var/run/httpd \ 
&& rm -rf /run/httpd && mkdir /run/httpd

# Launch httpd

CMD /usr/sbin/httpd -DFOREGROUND
