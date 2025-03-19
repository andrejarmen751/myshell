#!/bin/bash
CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF-8 -Djava.locale.providers=JRE,COMPAT,CLDR -Djava.net.preferIPv4Stack=true"
CATALINA_OPTS="${CATALINA_OPTS} ${LIFERAY_JVM_OPTS}"
