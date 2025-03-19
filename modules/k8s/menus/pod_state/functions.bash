#!/bin/bash
#Funcions
aplica_yml() {
	echo "Aplicant yml de $app"
	#Recorre directori per extreure "namespaces" i assignar a variable
	ymls=$(ls "$k8s_env_path"/"$env"/"$app"/)
	#Iniciem bucle per recorrer contingut arxiu entrada per entrada
	for yml in $ymls; do
		check_file=$(echo "${yml:0-4}")
		if [ "$check_file" = "yaml" ]; then
			echo "Aplicant: "$k8s_env_path"/"$env"/"$app"/$yml"
			kubectl --kubeconfig "$HOME"/.kube/$env apply -f $k8s_env_path/$env/$app/$yml
		else
			echo "No yaml"
			exit
		fi
	done
}
elimina_yml() {
	echo "Eliminant yml de $app"
	#Recorre directori per extreure "namespaces" i assignar a variable
	ymls=$(ls "$k8s_env_path"/"$env"/"$app"/)
	#Iniciem bucle per recorrer contingut arxiu entrada per entrada
	for yml in $ymls; do
		check_file=$(echo "${yml:0-4}")
		if [ "$check_file" = "yaml" ]; then
			echo "Aplicant: "$k8s_env_path"/"$env"/"$app"/$yml"
			kubectl --kubeconfig "$HOME"/.kube/$env delete -f $k8s_env_path/$env/$app/$yml
		else
			echo "No yaml"
			exit
		fi
	done
}
atura_yml() {
	echo "Aplicant yml de $app"
	#Recorre directori per extreure "namespaces" i assignar a variable
	ymls=$(ls "$k8s_env_path"/"$env"/"$app"/)
	#Iniciem bucle per recorrer contingut arxiu entrada per entrada
	for yml in $ymls; do
		check_file=$(echo "${yml:0-4}")
		if [ "$check_file" = "yaml" ]; then
			echo "Aturant: "$k8s_env_path"/"$env"/"$app"/$yml"
			kubectl --kubeconfig "$HOME"/.kube/$env scale -f $k8s_env_path/$env/$app/$yml --replicas=0
		else
			echo "No yaml"
			exit
		fi
	done
}
export aplica_yml
export elimina_yml
export atura_yml
