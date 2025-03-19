#!/bin/bash
source "$mod_colors"
num_imatges_docker=$(docker images | wc -l)
#echo $((num_imatges_docker-1))
if [ $num_imatges_docker -gt 1 ]; then
	cyan
	echo "Eliminar containers.."
	nocolor
	docker rm $(docker ps -a -q) -f
fi
if [ $num_imatges_docker -gt 1 ]; then
	cyan
	echo "Eliminar imatges.."
	nocolor
	docker rmi $(docker images -a -q) -f
fi
cyan
echo "Delete volumes..."
nocolor
docker volume ls -q | grep -q . && docker volume rm $(docker volume ls -q)
cyan
echo "Delete networks..."
nocolor
docker network prune --force
# cyan
# echo "Docker prune..."
# nocolor
# docker system prune -a --volumes -f
