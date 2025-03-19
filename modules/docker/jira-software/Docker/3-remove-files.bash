#!/bin/bash
if [ "$(hostname)" = "jira-ops-dev-0" ]; then
	rm $JIRA_SHARED_HOME/cargaCSV/*
fi
