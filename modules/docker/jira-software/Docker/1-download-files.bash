#!/bin/bash
if [ "$(hostname)" = "jira-ops-dev-0" ]; then
	if [ ! -d "$JIRA_SHARED_HOME/cargaCSV" ]; then
		mkdir "$JIRA_SHARED_HOME/cargaCSV"
	fi
	download_file1=file1_"$(date +%Y-%m-%d_%H-%M)"
	download_file2=file2_"$(date +%Y-%m-%d_%H-%M)"
	curl -o $JIRA_SHARED_HOME/cargaCSV/$download_file1.md https://raw.githubusercontent.com/docker-library/hello-world/master/README.md
	curl -o $JIRA_SHARED_HOME/cargaCSV/$download_file2.md https://raw.githubusercontent.com/docker-library/hello-world/master/README.md
fi
