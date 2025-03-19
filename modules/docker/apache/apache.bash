#!/bin/bash
#!/bin/bash$
cd $HOME/Documents/bash-profile/Docker/apache
docker network create develop
nom_imatge="apache"
nom_contenidor="apache"
if [[ exists=$(docker ps -a | grep $nom_contenidor) ]]; then
	#Neteja
	echo "Se elimina el container"
	docker rm $nom_contenidor -f
	#
fi
docker build --rm -t $nom_imatge -f .Dockerfile .
docker run -it --name "$nom_contenidor" -p 1000:80 --net develop -v $PWD"\tmp":/tmp $nom_imatge /bin/bash
cd
