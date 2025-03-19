https://milindchawre.github.io/site/blog/k3s-upgrade-a-simplified-guide/

kubectl apply -f https://raw.githubusercontent.com/rancher/system-upgrade-controller/master/manifests/system-upgrade-controller.yaml


kubectl get all -n system-upgrade

kubectl apply -f plans.yaml


kubectl -n system-upgrade get plans -o yaml
kubectl -n system-upgrade get jobs -o yaml

kubectl get nodes