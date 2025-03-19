Set-Location $PATH\Docker\syslog\
$nom_imatge="syslog"
$nom_contenidor="syslog"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
docker compose up  -d --build --force-recreate
Set-Location $HOME 