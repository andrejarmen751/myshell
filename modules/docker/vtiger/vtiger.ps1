Set-Location $PATH\Docker\vtiger\
$DOCKER_REGISTRY_CACHE = "docker.io"
docker login $DOCKER_REGISTRY_CACHE
docker network create develop
#Creació de la imatge
$nom_imatge="vtiger"
docker build --rm -t $nom_imatge -f $PWD\.Dockerfile .
#Càrrega del contenidor
$nom_contenidor="vtiger"
#docker run --name "$nom_contenidor" $nom_imatge
docker run -it --name "$nom_contenidor" -p 10010:80 --net develop -v $PWD"\tmp":/tmp  $nom_imatge /bin/bash
#Write-Host "https://localhost:9000/sample"
#docker exec -it "$nom_contenidor" /bin/bash
#Neteja
        Write-Output "Se elimina el container"
        docker stop "$nom_contenidor"
        docker rmi -f $nom_imatge
        docker container rm $nom_contenidor
#
Set-Location $HOME 