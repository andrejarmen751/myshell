Set-Location $PATH\Docker\liferay-7.3.5-ga6\
$nom_imatge="liferay-7.3.5-ga6"
$nom_contenidor="liferay-7.3.5-ga6"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
docker compose up  -d --build --force-recreate
Set-Location $HOME 