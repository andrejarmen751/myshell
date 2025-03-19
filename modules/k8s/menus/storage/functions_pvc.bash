#!/bin/bash
pvc() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "Aquests son els pvc del namespace $namespace i el seu estat"
	kubectl --kubeconfig "$HOME"/.kube/$env get pvc -n $namespace
	echo "Selecciona un per tal de tenir més informació"
	read pvc
	kubectl --kubeconfig "$HOME"/.kube/$env describe pvc -n $namespace $pvc
}
pvc_elimina() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "Aquests son els pvc del namespace $namespace i el seu estat"
	kubectl --kubeconfig "$HOME"/.kube/$env get pvc -n $namespace
	echo "Introdueix pvc que vols eliminar"
	read pvc_elimina
	k3stegit=$(kubectl --kubeconfig config_k3s describe pvc -n $namespace $pvc_elimina | grep Finalizers)
	if [ "kubectl --kubeconfig "$HOME"/.kube/$envtegit" = "Finalizers:    [kubernetes.io/pvc-k3stection]" ]; then
		echo "k3stegit"
		kubectl --kubeconfig config_k3s patch pvc -n $namespace $pvc_elimina -p '{"metadata":{"finalizers": []}}' --type=merge
		kubectl --kubeconfig "$HOME"/.kube/$env delete pvc -n $namespace $pvc_elimina
	else
		echo "No k3stegit"
		kubectl --kubeconfig "$HOME"/.kube/$env delete pvc -n $namespace $pvc_elimina
	fi
}
#
export pvc
export pvc_elimina
