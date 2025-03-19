#!/bin/bash
PS3="Select the operation: "
select opt in dev quit; do
	case $opt in
	dev)
		"$project_path"/modules/minikube/profiles/dev.bash
		;;
	quit)
		break
		;;
	*)
		echo "Invalid option $REPLY"
		;;
	esac
done
