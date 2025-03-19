#!/bin/bash
repos=$(aws codecommit list-repositories --query 'repositories[*].repositoryName' --output text)
for repo in $repos; do
	git clone ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/$repo
done
