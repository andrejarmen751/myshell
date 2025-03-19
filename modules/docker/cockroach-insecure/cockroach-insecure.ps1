Set-Location $PATH\Docker\cockroach-insecure\
$nom_contenidor="cockroach-insecure"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
docker compose up -d --build --force-recreate
Set-Location $HOME 