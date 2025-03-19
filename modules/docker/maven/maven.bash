#!/bin/bash
cd $project_path/modules/docker/maven
docker compose up --build --force-recreate
cd
