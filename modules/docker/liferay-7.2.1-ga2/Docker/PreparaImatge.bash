#!/bin/bash
apt-get update &&
	apt-get upgrade -y &&
	apt-get install openssl tzdata curl wget zip tree dos2unix -y &&
	cp -r -f /usr/share/zoneinfo/Europe/Madrid /etc/localtime
openssl req \
	-new \
	-newkey rsa:4096 \
	-days 3650 \
	-nodes \
	-x509 \
	-subj "/C=EU/ST=CA/L=CPD/O=BcnAct/CN=localhost" \
	-keyout /tmp/localhost-rsa-key.pem \
	-out /tmp/localhost-rsa-cert.pem && chown liferay:liferay /tmp/*.pem

#Noves entrades de configuració
#-- Creem una variable d'entorn per disposar de la versió de release actual.
#export RELEASE=`cat /etc/RELEASE.txt`
#export BRANCA=`cat /etc/BRANCA.txt`
#-----------------------------------------------------------------
#-- Creem una variable d'entorn per disposar del nom d'aplicacio.
export NAPLICACIO='Liferay'
export MOMENTINICI=$(date +"%d-%m-%Y--%H:%M")
#----------------------------------------------------------------
#-- Creem una plana html amb les dades d'inici del contenidor
mkdir /opt/liferay/tomcat/webapps/info -p
echo $NAPLICACIO de $BCNACT_ENTORN Compilacio $BRANCA $RELEASE Iniciat el $MOMENTINICI >/opt/liferay/tomcat/webapps/info/index.html

#-- >  aqui cal actualitzar els permisos i el propietari de les carpetes que son Dades permanents
#chmod 774 /opt/liferay/data -R
#chmod 774 /mnt/liferay/deploy -R
#chown liferay:liferay /mnt/liferay/deploy -R
#chown liferay:liferay /opt/liferay/deploy -R
#chown liferay:liferay /opt/liferay/data -R
#chown liferay:liferay /opt/liferay/tomcat/conf/localhost-rsa-cert.pem
#chown liferay:liferay /opt/liferay/tomcat/conf/localhost-rsa-key.pem
#chown liferay:liferay /opt/liferay/tomcat/conf/server.xml
