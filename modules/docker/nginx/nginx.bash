#!/bin/bash
cd $project_path/modules/docker/nginx
docker compose up -d --build --force-recreate
cd
