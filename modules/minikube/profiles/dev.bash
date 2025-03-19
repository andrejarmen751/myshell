#!/bin/bash
minikube -p dev delete
minikube start --addons=metrics-server,ingress,dashboard --apiserver-port=8443 --cni=calico --container-runtime=containerd --cpus=3 --memory=4g --driver=docker --kubernetes-version=v1.24.7 --profile dev
minikube profile list
minikube -p dev dashboard --url &
sleep 1
kubectl config use-context dev
#
minikube -p dev kubectl -- create -f $project_path/modules/minikube/apps/minio/pvc.yaml
minikube -p dev kubectl -- create -f $project_path/modules/minikube/apps/minio/minio.yaml
minikube -p dev kubectl -- get pods -A
