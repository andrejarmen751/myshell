#!/bin/bash
checks() {
	echo -e "config \n"
	kubectl --kubeconfig "$HOME"/.kube/$env config view
	echo -e "\n\n"
	echo -e "API call \n"
	kubectl --kubeconfig "$HOME"/.kube/$env get pods -v8
	echo -e "\n\n"
	TOKEN=$(kubectl --kubeconfig "$HOME"/.kube/$env describe secret -n kube-system $(kubectl --kubeconfig "$HOME"/.kube/$env get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
	APISERVER=$(kubectl --kubeconfig "$HOME"/.kube/$env config view | grep https | cut -f 2- -d ":" | tr -d " ")
	cat ~/.kube/"$env" | yq .clusters[0].cluster.certificate-authority-data | base64 -d - >~/.kube/"$env"-encoded-ca
	cat ~/.kube/"$env" | yq .users[0].user.client-certificate-data | base64 -d - >~/.kube/"$env"-encoded-cert
	cat ~/.kube/"$env" | yq .users[0].user.client-key-data | base64 -d - >~/.kube/"$env"-encoded-key
	echo -e "\nhealthz status"
	curl "$APISERVER"/healthz --cert ~/.kube/"$env"-encoded-cert --key ~/.kube/"$env"-encoded-key --cacert ~/.kube/"$env"-encoded-ca
	echo -e "\nlivez status"
	curl "$APISERVER"/livez --cert ~/.kube/"$env"-encoded-cert --key ~/.kube/"$env"-encoded-key --cacert ~/.kube/"$env"-encoded-ca
	echo -e "\nreadyz status"
	curl "$APISERVER"/readyz --cert ~/.kube/"$env"-encoded-cert --key ~/.kube/"$env"-encoded-key --cacert ~/.kube/"$env"-encoded-ca
	echo -e "\n\nversion"
	kubectl --kubeconfig "$HOME"/.kube/$env version --short
}
export checks
