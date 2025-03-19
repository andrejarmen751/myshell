#!/bin/bash
source "$mod_colors"
clear
cyan
echo "gcloud"
nocolor
yellow
echo "Init account to use"
nocolor
echo "gcloud init --no-launch-browser - done"
echo "gcloud config configurations list"
echo "gcloud config configurations activate PROFILE_NAME"
echo "gcloud config configurations delete PROFILE_NAME"
yellow
echo "Cambiar de proyecto "
nocolor
echo "gcloud config set project project-name"
yellow
echo "Display current gcloud tool environment details "
nocolor
echo "gcloud info"
yellow
echo "List images"
nocolor
echo "gcloud compute images list"
yellow
echo "List compute zones"
nocolor
echo "gcloud compute zones list"
yellow
echo "List machine types"
nocolor
echo "gcloud compute machine-types list"
yellow
echo "List DNS zones"
nocolor
echo "gcloud dns --project=mm-dns-prod managed-zones list | grep guuk"
yellow
echo "List DNS zones"
nocolor
echo "gcloud dns --project=mm-dns-prod managed-zones describe guuk-com-private"
yellow
echo "List DNS entries"
nocolor
echo 'gcloud dns record-sets list --zone=guuk-com-private --project=mm-dns-prod --format="table(NAME,FQDN,TYPE,RRDATA)"'
echo 'gcloud dns record-sets list --zone=guuk-eus-private --project=mm-dns-prod --format="json"'
yellow
echo "Add DNS"
nocolor
echo "gcloud dns record-sets transaction start --zone=guuk-eus-private --project=mm-dns-prod"
echo 'gcloud dns record-sets transaction add "34.36.89.127" --name=pago-pre.guuk.eus. --ttl=3600 --type=A --zone=guuk-eus-private'
echo "gcloud dns record-sets transaction execute --zone=guuk-eus-private --project=mm-dns-prod"
yellow
echo "Modify DNS"
nocolor
echo "gcloud dns record-sets update pago-pre.guuk.eus. --type=A --zone=guuk-eus-private --rrdatas=34.36.89.127 --ttl=60 --project=mm-dns-prod"
yellow
echo "GKE"
nocolor
echo "gcloud container clusters get-credentials mm-k8s-md-it-infra --zone europe-southwest1"
