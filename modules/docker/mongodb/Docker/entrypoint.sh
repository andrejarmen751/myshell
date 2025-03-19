#!/bin/sh

rm -rf /data/db/*
chown -R mongouser:mongod /data/db
mongod --bind_ip 0.0.0.0

until mongosh --eval "print('waiting for connection')" > /dev/null 2>&1; do
  sleep 1
done

for file in /docker-entrypoint-initdb.d/*.js; do
  echo "Importing $file"
  mongosh "$file"
done

#while true; do sleep 30; done