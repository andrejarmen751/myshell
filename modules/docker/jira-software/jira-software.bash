#!/bin/bash
cd $project_path/modules/docker/jira-software
docker compose up --build --force-recreate
cd
