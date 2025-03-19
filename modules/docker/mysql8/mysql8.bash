#!/bin/bash
cd $project_path/modules/docker/mysql8
docker compose up -d --build --force-recreate
cd
