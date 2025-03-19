# Cal executar manualment des de node0!!!
docker exec -it cockroach0 cockroach init --insecure
# Llavors es pot connectar contra consola sql:
docker exec -it cockroach0 cockroach sql --insecure
Show databases;