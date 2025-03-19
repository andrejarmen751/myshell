#!/bin/bash
cd $project_path/modules/docker/mongodb
docker compose up -d --build --force-recreate
cd
