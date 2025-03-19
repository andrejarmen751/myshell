#!/bin/bash
#-----------------------------------------------------------------
#Còpia arxius configuració
cp /tmp/configs/$ENVIRONMENT/db.cnf /etc/mysql/conf.d/db.cnf -f
cp /tmp/configs/General/general.cnf /etc/mysql/conf.d/general.cnf -f
#Còpia certificats i permisos
mkdir -p /etc/mysql/ssl
cp /tmp/configs/$ENVIRONMENT/ca.crt /etc/mysql/ssl/
cp /tmp/configs/$ENVIRONMENT/cert.crt /etc/mysql/ssl/
cp /tmp/configs/$ENVIRONMENT/key.key /etc/mysql/ssl/
chown -R mysql:mysql /etc/mysql/ssl/
chmod -R 700 /etc/mysql/ssl/
#Permisos per servei
chown -R mysql:mysql /var/run/mysqld/
chmod -R 700 /var/run/mysqld/
#Inici servei
mysqld