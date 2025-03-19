#!/bin/bash
#INFO
export RELEASE=0.0.0
export APPLICATION_VERSION=testing
export BRANCA=testing
export NAPLICACIO=testing
export MOMENTINICI=$(date +"%d-%m-%Y--%H:%M")
mkdir /usr/local/tomcat/webapps/info
echo $NAPLICACIO de $BCNACT_ENTORN Compilacio $BRANCA $RELEASE Iniciat el $MOMENTINICI >/usr/local/tomcat/webapps/info/index.html
#CONFIGURACIO KEYSTORE
keytool -genkey -noprompt \
	-alias AP000 \
	-dname "CN=localhost:4443, OU=SSI, O=BA, L=Barcelona, S=Catalunya, C=ES" \
	-storetype PKCS12 \
	-keyalg RSA \
	-keysize 2048 \
	-keystore /home/AP000.jks \
	-storepass 1nternet! \
	-keypass 1nternet!

keytool -certreq -noprompt \
	-keyalg RSA \
	-keysize 2048 \
	-alias AP000 \
	-file /home/AP000.csr \
	-keystore /home/AP000.jks \
	-storepass 1nternet! \
	-keypass 1nternet!

#SETTINGS
#cp -f /tmp/entorns/$BCNACT_ENTORN/index.html /usr/local/tomcat/webapps/ROOT/index.html
#cp -f /tmp/entorns/$BCNACT_ENTORN/context.xml /usr/local/tomcat/conf/context.xml
#cp -f /tmp/entorns/$BCNACT_ENTORN/web.xml /usr/local/tomcat/conf/
cp -f /tmp/entorns/$BCNACT_ENTORN/catalina.sh /usr/local/tomcat/bin/
#cp -f /tmp/entorns/$BCNACT_ENTORN/config.properties /usr/local/tomcat/webapps/piu/WEB-INF/classes/config/
#cp -f /tmp/entorns/$BCNACT_ENTORN/log4j.properties /usr/local/tomcat/webapps/piu/WEB-INF/classes/log4j/

#INICI SERVEI AMB SAMPLE
/usr/local/tomcat/bin/catalina.sh run
rm -rf /usr/local/tomcat/webapps/*.war
