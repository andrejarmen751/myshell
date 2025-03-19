#!/bin/bash
cd $project_path/modules/docker/mysql5
docker compose up -d --build --force-recreate
cd
