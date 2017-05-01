#!/bin/bash
set -e
# x - print executed commands; e - exit if a program fails


term_handler(){
    # stop service and clean up here
    echo "stopping apacheds"
    sudo -u ${APACHEDS_USER} bash -c "/opt/apacheds/bin/apacheds.sh ${APACHEDS_INSTANCE} stop"
    echo "apacheds stopped"
}
#trap signals and call the term handler
trap "term_handler" SIGHUP SIGINT SIGQUIT SIGTERM


if [ -n "$(ls -A ${APACHEDS_DATA})" ]
  then
    echo "existing installation found"
  else
    echo "preparing for first start ..."
    cp -R /tmpl/instances /opt/apacheds/
    #rename the instance
    mv ${APACHEDS_DATA}/default ${APACHEDS_DATA}/${APACHEDS_INSTANCE}

    #bootstrap from https://github.com/greggigon/apacheds/blob/master/apacheds.sh
    if [ -f /bootstrap/config.ldif ]; then
	echo "Using config file from /bootstrap/config.ldif"
	rm -rf ${APACHEDS_DATA}/${APACHEDS_INSTANCE}/conf/config.ldif

	cp /bootstrap/config.ldif ${APACHEDS_DATA}/${APACHEDS_INSTANCE}/conf/
	chown ${APACHEDS_USER} ${APACHEDS_DATA}/${APACHEDS_INSTANCE}/conf/config.ldif
    fi

fi

chown -R ${APACHEDS_USER} /opt/apacheds/
	
# Clean left over pid file
pidFile=${APACHEDS_DATA}/run/apacheds-${APACHEDS_INSTANCE}.pid
[[ -e $pidFile ]] && rm $pidFile

# Always repair because the data will be corrupted in case of improper shutdown
# sudo -u ${APACHEDS_USER} bash -c "/opt/apacheds/bin/apacheds.sh ${APACHEDS_INSTANCE} repair"


# Execute the server in background. If executed in foreground the trap doesn't get called for some reason
sudo -u ${APACHEDS_USER} bash -c "/opt/apacheds/bin/apacheds.sh ${APACHEDS_INSTANCE} start"


#wait forever
while true
do
  tail -f /dev/null & wait ${!}
done