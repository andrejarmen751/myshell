Set-Location $PATH\Docker\httpd\
$DOCKER_REGISTRY_CACHE = "docker.io"
docker login $DOCKER_REGISTRY_CACHE
docker network create develop
$nom_imatge="httpd"
#Càrrega del contenidor
$nom_contenidor="httpd"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
#Creació de la imatge
docker build --rm -t $nom_imatge -f $PWD\.Dockerfile .
#docker run --name "$nom_contenidor" $nom_imatge
docker run -it --name "$nom_contenidor" -p 1000:80 --net develop -v $PWD"\tmp":/tmp  $nom_imatge /bin/bash
#Write-Host "https://localhost:9000/sample"
#docker exec -it "$nom_contenidor" /bin/bash
Set-Location $HOME 