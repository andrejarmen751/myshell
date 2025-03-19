#!/bin/bash
cd $project_path/modules/docker/nexus
docker compose up --build --force-recreate
cd
