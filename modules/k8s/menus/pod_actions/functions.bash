#!/bin/bash
exe() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "On vols l'exe?"
	kubectl --kubeconfig "$HOME"/.kube/$env get pods -n $namespace
	read deployment
	kubectl --kubeconfig "$HOME"/.kube/$env exec -it -n $namespace $deployment -- /bin/sh
}
logs() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "De quin pod vols veure logs?"
	kubectl --kubeconfig "$HOME"/.kube/$env get pods -n $namespace
	read deployment
	kubectl --kubeconfig "$HOME"/.kube/$env logs -f -n $namespace $deployment
}
copy_from() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "De quin pod vols agafar arxiu?"
	kubectl --kubeconfig "$HOME"/.kube/$env get pods -n $namespace
	read deployment
	echo "Quin arxiu/path?"
	read arxiu
	kubectl --kubeconfig "$HOME"/.kube/$env cp -n $namespace $deployment:$arxiu /tmp/$arxiu
}
describe() {
	echo "Quin namespace?"
	kubectl --kubeconfig "$HOME"/.kube/$env get namespaces
	read namespace
	echo "Quin pod vols descriure?"
	kubectl --kubeconfig "$HOME"/.kube/$env get pods -n $namespace
	read deployment
	kubectl --kubeconfig "$HOME"/.kube/$env describe pods -n $namespace $deployment
}
export exe
export logs
export copy_from
export describe
