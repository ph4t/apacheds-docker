FROM java:7-alpine
MAINTAINER Michael Riedmann @ https://www.github.com/mriedmann

ENV APACHEDS_VERSION 2.0.0-M23
ENV APACHEDS_MD5 1b380b7eace07e338578a66a4c625d61
ENV APACHEDS_DATA /opt/apacheds/instances
ENV APACHEDS_INSTANCE default
ENV APACHEDS_USER apacheds
ENV APACHEDS_GROUP apacheds

ADD http://www.eu.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/apacheds-${APACHEDS_VERSION}.tar.gz /tmp/
RUN cd /tmp && echo "$APACHEDS_MD5  apacheds-${APACHEDS_VERSION}.tar.gz" > MD5SUM && md5sum -c MD5SUM

RUN tar vxzf /tmp/apacheds-${APACHEDS_VERSION}.tar.gz -C /opt/ && \
    ln -s /opt/apacheds-${APACHEDS_VERSION} /opt/apacheds && \
	rm /tmp/apacheds*

ADD run.sh /run.sh

RUN adduser -S apacheds -h /opt/apacheds -H && \
	chown -R ${APACHEDS_USER} /opt/apacheds/ && \
	chown ${APACHEDS_USER} /run.sh && \
    chmod u+rx /run.sh
	
USER apacheds

VOLUME /opt/apacheds-${APACHEDS_VERSION}/instances
EXPOSE 10389 10636 60088 60464 8080 8443

CMD ["/run.sh"]
