#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
	echo "AWS CLI could not be found. Please install it."
	exit 1
fi

# List all task definitions
echo -e "Fetching all ECS task definitions...\n"

# Fetch task definitions and print each on a new line, stripping the ARN prefix
task_definitions=$(aws ecs list-task-definitions --query "taskDefinitionArns[]" --output text | tr '\t' '\n' | sed 's|arn:aws:ecs:[^:]*:[^:]*:task-definition/||')

for task_definition in $task_definitions; do
	echo "Checking task definition: $task_definition"

	# Describe the task definition
	logging_info=$(aws ecs describe-task-definition --task-definition "$task_definition" --query 'taskDefinition.containerDefinitions[0].logConfiguration' --output json)

	# Check if logging is configured
	if echo "$logging_info" | grep -q '"logDriver": "awslogs"'; then
		echo "Logging is enabled for task definition: $task_definition"
		echo "$logging_info" | jq '. | {awslogs_group: .options."awslogs-group", awslogs_region: .options."awslogs-region", awslogs_stream_prefix: .options."awslogs-stream-prefix"}'
	else
		echo "No logging option enabled for task definition: $task_definition"
	fi
done

# Task definitions being used
echo -e "\nTask definitions being used\n"

# Get all task definitions
task_definitions=$(aws ecs list-task-definitions --query "taskDefinitionArns[]" --output text)

# Get all clusters
clusters=$(aws ecs list-clusters --query "clusterArns[]" --output text)

# Loop through each cluster
for cluster in $clusters; do
	# Extract the cluster name from the ARN
	cluster_name=$(basename "$cluster")

	# List services in the cluster
	services=$(aws ecs list-services --cluster "$cluster" --query "serviceArns[]" --output text)

	# Loop through each service
	for service in $services; do
		# Describe the service to get the task definition
		current_task_definition=$(aws ecs describe-services --cluster "$cluster" --services "$service" --query "services[0].taskDefinition" --output text)

		# Loop through each task definition
		for task_definition in $task_definitions; do
			# Check if the current task definition matches the one we are looking for
			if [[ "$current_task_definition" == "$task_definition" ]]; then
				# Extract the task definition name from the ARN (excluding the revision)
				task_definition_name=$(basename "$task_definition")

				# Extract the service name (omit everything before "service/")
				service_name=${service##*/}

				# Echo the information for any cluster and service that matches
				echo "Task Definition: $task_definition_name"
				echo "  Cluster: $cluster_name"
				echo "  Service: $service_name"
			fi
		done
	done
done
