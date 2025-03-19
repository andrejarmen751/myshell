#!/bin/bash
cd $project_path/modules/docker/tomcat9
docker compose up -d --build --force-recreate
cd
