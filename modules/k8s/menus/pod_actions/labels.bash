#!/bin/bash
script_path=$(dirname $0)
source ""$script_path"/functions.bash"
#Main
echo "kubectl --kubeconfig "$HOME"/.kube/$env get pod -L app,tier -A"
echo "kubectl --kubeconfig "$HOME"/.kube/$env get pod -l tier=frontal -A"
