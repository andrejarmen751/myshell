Set-Location $PATH\Docker\cockroach\
$nom_contenidor="cockroach"
if (docker ps -a | Select-String $nom_contenidor) {
        #Neteja
        Write-Output "Se elimina el container"
        docker rm $nom_contenidor -f
        #
}
docker compose up --no-start
docker compose start cockroach-cert
sleep 5
docker compose start cockroach0
sleep 5
docker compose start cockroach1
docker compose start cockroach2
docker compose start lb
sleep 5
docker compose start roach-init
Set-Location $HOME 