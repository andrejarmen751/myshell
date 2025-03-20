#!/bin/bash
cd $project_path/modules/docker/maven
docker compose up -d --build --force-recreate
cd
