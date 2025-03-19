#!/bin/bash
api() {
	TOKEN=$(kubectl --kubeconfig "$HOME"/.kube/$env describe secret -n kube-system $(kubectl --kubeconfig "$HOME"/.kube/$env get secrets -n kube-system | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | tr -d " ")
	APISERVER=$(kubectl --kubeconfig "$HOME"/.kube/$env config view | grep https | cut -f 2- -d ":" | tr -d " ")
	cat ~/.kube/"$env" | yq .clusters[0].cluster.certificate-authority-data | base64 -d - >~/.kube/"$env"-encoded-ca
	cat ~/.kube/"$env" | yq .users[0].user.client-certificate-data | base64 -d - >~/.kube/"$env"-encoded-cert
	cat ~/.kube/"$env" | yq .users[0].user.client-key-data | base64 -d - >~/.kube/"$env"-encoded-key
	curl "$APISERVER""$1" --cert ~/.kube/"$env"-encoded-cert --key ~/.kube/"$env"-encoded-key --cacert ~/.kube/"$env"-encoded-ca
}
export api
#api /healthz;api /livez;api /readyz
#api /apis/apps/v1/
#api /apis/apps/v1/deployments
#Core group (/api/v1)
# Named group - /apis/$NAME/$VERSION
# $VERSION :
# Alpha level - it may be dropped at any point in time, without notice. For example, /apis/batch/v2alpha1.
# Beta level - it is well-tested, but the semantics of objects may change in incompatible ways in a subsequent beta or stable release. For example, /apis/certificates.k8s.io/v1beta1.
# Stable level - appears in released software for many subsequent versions. For example, /apis/networking.k8s.io/v1.

# System-wide - This group consists of system-wide API endpoints, like /healthz, /logs, /metrics, /ui, etc.
