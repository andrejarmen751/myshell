#!/bin/bash
echo "Quin entorn vols?"
ls $k8s_env_path
read env
echo "Nom user a eliminar"
read user
directory="$project_path"/modules/k8s/env/"$env"/rbac-users
echo "Eliminar role user"
kubectl --kubeconfig "$HOME"/.kube/$env delete rolebinding $user --namespace $user
#echo "Revocat certificat user"
kubectl --kubeconfig "$HOME"/.kube/$env delete csr $user
echo "Eliminar NS"
kubectl --kubeconfig "$HOME"/.kube/$env delete namespace $user
echo "Eliminar directori i claus user"
rm -rf $directory/$user/
##
##
