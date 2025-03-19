#!/bin/bash
# 'Global variables'
total_clusters="${AWS_PROFILE}-total-clusters.json"

# List clusters and save the output to a file
aws ecs list-clusters >"${total_clusters}"

# Create the output file name based on the input file name
describe_clusters="${AWS_PROFILE}-cluster-description.json"
if [ -e "$describe_clusters" ]; then
	rm "$describe_clusters"
fi

# Start the JSON array
echo "[" >"$describe_clusters"

# Read the list of clusters from the JSON file and extract ARNs
clusters=$(jq -r '.clusterArns[]' "${total_clusters}")

# Loop through each cluster
for cluster in $clusters; do
	# Describe the cluster and save the output to a temporary variable
	cluster_description=$(aws ecs describe-clusters --clusters "$cluster")

	# Append the cluster description to the output file
	echo "$cluster_description," >>"$describe_clusters"
done

# Remove the trailing comma from the last entry
sed -i '$ s/,$//' "$describe_clusters"

# Close the JSON array
echo "]" >>"$describe_clusters"

#Env
echo -e "Working on" $AWS_PROFILE - $AWS_ROLE"\n"

echo "Services and tasks for each cluster"
for cluster in $clusters; do
	# Get the list of service ARNs
	service_arns=$(aws ecs list-services --cluster $cluster --query "serviceArns" --output text)
	# Count the number of services
	count_services=$(echo "$service_arns" | wc -w)

	task_arns=$(aws ecs list-tasks --cluster $cluster --query "taskArns" --output text)
	count_tasks=$(echo "$task_arns" | wc -w)

	# Extract the cluster name from the ARN
	cluster_name=${cluster##*:}

	echo "$cluster_name has $count_services services and $count_tasks tasks"

	# Loop through each service ARN to get the service names
	for service_arn in $service_arns; do
		# service_name=$(echo $service_arn | awk -F'/' '{print $3}')  # Extract the service name from the ARN
		# echo " - Service Name: $service_name"
		# Extract the service name
		service_name=$(echo $service_arn | awk -F'/' '{print $NF}')

		# Check if the service name includes the cluster name
		for cluster_name in "${cluster_names[@]}"; do
			if [[ $service_name == *"$cluster_name"* ]]; then
				service_name=""
				break
			fi
		done

		# Print the service name if it's not empty
		if [[ -n $service_name ]]; then
			echo " - Service Name: $service_name"
		fi

		# Get the tasks for the service
		task_arns=$(aws ecs list-tasks --cluster $cluster --service-name $service_name --query "taskArns" --output text)

		# Loop through each task ARN to get the task IDs
		for task_arn in $task_arns; do
			task_id=$(echo $task_arn | awk -F'/' '{print $3}') # Extract the task ID from the ARN
			echo "   - Task: $task_id"
		done
	done
done

echo -e "\n"
#Total clusters
count_clusters=$(jq '.clusterArns | length' "${total_clusters}")
echo -e "Total number of ECS clusters" $count_clusters "\n"

#-------------------------------------------------------------
echo -e "Working on" $AWS_PROFILE - $AWS_ROLE "for capacityProviders=FARGATE\n"
# get the status, clusterName, activeServicesCount, runningTasksCount and pendingTasksCount of each FARGATE
info=$(jq -r '.[] | .clusters[] | select(.capacityProviders | index("FARGATE")) | "status: \(.status)\nclusterName: \(.clusterName)\nactiveServicesCount: \(.activeServicesCount)\nrunningTasksCount: \(.runningTasksCount)\npendingTasksCount: \(.pendingTasksCount)\ncapacityProviders: \(.capacityProviders)\n"' "${describe_clusters}")
echo -e "\n$info"

cluster_not_capacityProviders_fargate=$(jq -r '.[] | .clusters[] | select(.capacityProviders | index("FARGATE") | not) | select(.capacityProviders | index("FARGATE_SPOT") | not) | "\(.clusterName)"' "${describe_clusters}")

for cluster in $cluster_not_capacityProviders_fargate; do
	service_arns=$(aws ecs list-services --cluster $cluster --query "serviceArns" --output text)
	count_services=$(echo "$service_arns" | wc -w)
	if [ $count_services -gt 0 ]; then
		printed_cluster=false # Flag to track if the cluster name has been printed
		for service_arn in $service_arns; do
			# Extract the service name
			service_name=$(echo $service_arn | awk -F'/' '{print $NF}')

			# Check if the service name includes the cluster name
			for cluster_name in "${cluster_names[@]}"; do
				if [[ $service_name == *"$cluster_name"* ]]; then
					service_name=""
					break
				fi
			done
			# Get the tasks for the service
			task_arns=$(aws ecs list-tasks --cluster $cluster --service-name $service_name --query "taskArns" --output text)
			# Loop through each task ARN to get the task IDs
			for task_arn in $task_arns; do
				task_id=$(echo $task_arn | awk -F'/' '{print $3}') # Extract the task ID from the ARN
				cluster_has_task_fargate_launch=$(aws ecs describe-tasks --cluster $cluster --tasks $task_id --output json | jq -r '.tasks[] | select(.launchType == "FARGATE") | .clusterArn' | awk -F'/' '{print $2}')
				# Check if we found a FARGATE task
				if [ ! -z "$cluster_has_task_fargate_launch" ] && [ "$printed_cluster" = false ]; then
					info=$(jq -r '.[] | .clusters[] | select(.clusterName | index("'$cluster'")) | "status: \(.status)\nclusterName: \(.clusterName)\nactiveServicesCount: \(.activeServicesCount)\nrunningTasksCount: \(.runningTasksCount)\npendingTasksCount: \(.pendingTasksCount)\ncapacityProviders: \(.capacityProviders)\n"' "${describe_clusters}")
					echo -e "\n$info"
					count=+1
					printed_cluster=true # Set the flag to true to prevent further printing
					break                # Exit the inner loop to prevent checking other tasks for this cluster
				fi
			done
			if [ "$printed_cluster" = true ]; then
				break # Exit the service loop if the cluster name has already been printed
			fi
		done
	fi
done

# Total clusters using FARGATE
count_clusters_fargate=$(jq '[.[] | .clusters[] | select(.capacityProviders | index("FARGATE"))] | length' "${describe_clusters}")
total=$((count + count_clusters_fargate))
echo -e "\nTotal number of FARGATE clusters or clusters with tasks launched with FARGATE" $total
#----------------------------------------------------------
# # Extract cluster names with FARGATE capacity provider
# cluster_names=$(jq -r '.[] | .clusters[] | select(.capacityProviders | index("FARGATE")) | .clusterName' "${describe_clusters}")

# # Loop through each cluster name
# for cluster_name in $cluster_names; do
#     # Execute the AWS command for each cluster name
#     aws cloudwatch get-metric-statistics --namespace AWS/ECS --metric-name MemoryUtilization --dimensions Name=ClusterName,Value="$cluster_name" --start-time 2024-07-01T00:00:00Z --end-time 2024-09-12T23:59:59Z --period 7200 --statistics Average
# done
