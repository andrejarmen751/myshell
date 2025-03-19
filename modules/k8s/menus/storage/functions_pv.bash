#!/bin/bash
pv_released() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "Aquests son els pv del namespace $namespace que estan 'Released'"
	kubectl --kubeconfig "$HOME"/.kube/$env get pv -n $namespace -o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name,STATUS:.status.phase | grep Released
	echo "Eliminar? y/n"
	read pv_released
	if [ "$pv_released" = "y" ]; then
		kubectl --kubeconfig "$HOME"/.kube/$env get pv -n $namespace -o custom-columns=NAME:.metadata.name,CLAIM:.spec.claimRef.name,STATUS:.status.phase | grep Released >released.txt
		releaseds=$(awk '{print $1}' released.txt)
		for released in $releaseds; do
			echo "Eliminat $released"
			kubectl --kubeconfig "$HOME"/.kube/$env delete pv -n $namespace $released
		done
	else
		echo "Passi-ho bé."
	fi
}
pv_elimina() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "Aquests son els pvc del namespace $namespace i el seu estat"
	kubectl --kubeconfig "$HOME"/.kube/$env get pv -n $namespace
	echo "Introdueix pvc que vols eliminar"
	read pv_elimina
	kubectl --kubeconfig "$HOME"/.kube/$env patch pv $pv_elimina -p '{"metadata":{"finalizers":null}}'
	kubectl --kubeconfig "$HOME"/.kube/$env delete pv -n $namespace $pv_elimina
}
#
export pv_released
export pv_elimina
