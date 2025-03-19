#!/bin/bash
Clear-Host
#docker login rancher-sic-local.$domain_stg_ba:8090
docker login docker-privat.$domain_intra_ba
Write-Host "Imatges disponibles en local" -ForegroundColor DarkCyan
docker images
#
Write-Host "Quina imatge vols seleccionar?" -ForegroundColor DarkCyan
Write-Host "Introdueix nom_imatge:tag" -ForegroundColor DarkCyan
$nom_imatge_local = Read-Host
#docker images --filter "reference=$nom_imatge*"
#
Write-Host "Aquesta imatge es pujarà a al bucket 'proves'" -ForegroundColor DarkCyan
Write-Host "Amb quin nom de imatge el vols pujar?" -ForegroundColor DarkCyan
Write-Host "Introdueix nom_imatge:tag" -ForegroundColor DarkCyan
$nom_imatge_nexus = Read-Host
docker tag $nom_imatge_local docker-privat.$domain_intra_ba/proves/$nom_imatge_nexus
docker push docker-privat.$domain_intra_ba/proves/$nom_imatge_nexus
