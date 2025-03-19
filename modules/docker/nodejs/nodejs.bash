#!/bin/bash
cd $project_path/modules/docker/nodejs
docker compose up --build -d --force-recreate
cd
