Set-Location $PATH\Docker\rainloop\
$nom_imatge="rainloop"
$nom_contenidor="rainloop"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
docker compose up -d --build --force-recreate
Set-Location $HOME 