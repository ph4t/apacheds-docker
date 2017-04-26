#todo oracle jdk7 recommended at http://directory.apache.org/apacheds/basic-ug/1.3-installing-and-starting.html
FROM java:7-alpine
LABEL original-author="Michael Riedmann @ https://www.github.com/mriedmann" maintainer="https://github.com/ph4t/apacheds-docker"

ENV APACHEDS_VERSION 2.0.0-M23
ENV APACHEDS_MD5 1b380b7eace07e338578a66a4c625d61
ENV APACHEDS_DATA /opt/apacheds/instances
ENV APACHEDS_INSTANCE default
ENV APACHEDS_USER apacheds
ENV APACHEDS_GROUP apachedsdocker build

RUN apk --no-cache add bash tar sudo

RUN cd /tmp/ && \
    wget http://www.eu.apache.org/dist/directory/apacheds/dist/${APACHEDS_VERSION}/apacheds-${APACHEDS_VERSION}.tar.gz && \
	echo "$APACHEDS_MD5  apacheds-${APACHEDS_VERSION}.tar.gz" > MD5SUM && md5sum -c MD5SUM && \
	mkdir -p /opt/apacheds && \
	mkdir -p /tmpl && \
	cd /opt/apacheds/ && \
    tar --strip-components=1 -vxzf /tmp/apacheds-${APACHEDS_VERSION}.tar.gz && \
	mv $APACHEDS_DATA /tmpl/ && \
    rm -Rf /tmp/apacheds*
	
ADD run.sh /run.sh

RUN adduser -S apacheds -h /opt/apacheds -H && \
	chown ${APACHEDS_USER} /run.sh && \
    chmod u+rx /run.sh

VOLUME /opt/apacheds/instances

EXPOSE 10389 10636

#use entrypoint instead of CMD so that run.sh is PID1 which will receive SIGTERM. Otherwise 'docker stop' will always forcefully terminate the container
#see https://medium.com/@gchudnov/trapping-signals-in-docker-containers-7a57fdda7d86 & https://docs.docker.com/engine/reference/builder/#exec-form-entrypoint-example
ENTRYPOINT ["/run.sh"]
