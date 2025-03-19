#!/bin/bash
source "$mod_colors"
echo "Quin entorn vols?"
ls $k8s_env_path
read env
## Aquest script crea user, namespace i claus per user que ho treu d'un llistat .txt
## dona acces total al seu namespace.
## Necessari per executar aquest script:
## · Tenir aquest script en qualsevol "pwd"
## · En el mateix path s'ha de tenir un file amb el nom "users.txt"
##     · El format per a cada user ha de ser "nom-cognom" o "nomcognom"
#
#
#Crear directory per emmagatzemar les claus
mkdir -p "$project_path"/modules/k8s/env/"$env"/rbac/rbac-users
directory="$project_path"/modules/k8s/env/"$env"/rbac/rbac-users
if [ -e "$project_path"/modules/k8s/menus/rbac/users.txt ]; then
	#Inicialitzem variable file amb users.txt
	#I variable users amb el contingut del .txt
	file=""$project_path"/modules/k8s/menus/rbac/users.txt"
	users=$(cat $file)
	#Iniciem bucle per recorrer contingut file entrada per entrada
	for user in $users; do
		#Creació directory per user
		echo "Configuració de" $user
		echo "$user"
		mkdir -p $directory/$user
		#Creacio clau per user
		openssl req -new -newkey rsa:4096 -nodes \
			-keyout $directory/$user/"$user.key" \
			-out $directory/$user/"$user.csr" \
			-subj "/CN=$user/O=$env"
		#Creacio yml que conte la clau user
		user_request=$(cat $directory/$user/"$user.csr" | base64 | tr -d '\n')
		touch $directory/$user/"$user-csr.yaml"
		echo "apiVersion: certificates.k8s.io/v1beta1" >>$directory/$user/"$user-csr.yaml"
		echo "kind: CertificateSigningRequest" >>$directory/$user/"$user-csr.yaml"
		echo "metadata:" >>$directory/$user/"$user-csr.yaml"
		echo "  name: $user" >>$directory/$user/"$user-csr.yaml"
		echo "spec:" >>$directory/$user/"$user-csr.yaml"
		echo "  groups:" >>$directory/$user/"$user-csr.yaml"
		echo "  - system:authenticated" >>$directory/$user/"$user-csr.yaml"
		echo "  request: $user_request" >>$directory/$user/"$user-csr.yaml"
		echo "  usages:" >>$directory/$user/"$user-csr.yaml"
		echo "  - client auth" >>$directory/$user/"$user-csr.yaml"
		kubectl --kubeconfig "$HOME"/.kube/$env apply -f $directory/$user/"$user-csr.yaml"
		#Output dels csr de k8s
		kubectl --kubeconfig "$HOME"/.kube/$env get csr | grep $user
		#Aprovació accés a user
		kubectl --kubeconfig "$HOME"/.kube/$env certificate approve "$user"
		#Output dels csr de k8s
		kubectl --kubeconfig "$HOME"/.kube/$env get csr | grep $user
		#Clau user en format base64
		kubectl --kubeconfig "$HOME"/.kube/$env get csr "$user" \
			-o jsonpath='{.status.certificate}' | base64 --decode >$directory/$user/"$user.crt"
		#Clau publica servidor en format base64
		kubectl --kubeconfig "$HOME"/.kube/$env config view \
			-o jsonpath='{.clusters[0].cluster.certificate-authority-data}' \
			--raw | base64 --decode - >$directory/$env.crt
		#Creació kubeconfig user
		kubectl --kubeconfig "$HOME"/.kube/$env config set-cluster $(kubectl --kubeconfig "$HOME"/.kube/$env config view -o jsonpath='{.clusters[0].name}') \
			--server=$(kubectl --kubeconfig "$HOME"/.kube/$env config view -o jsonpath='{.clusters[0].cluster.server}') \
			--certificate-authority=$directory/$env.crt \
			--kubeconfig=$directory/$user/"$user-config" --embed-certs
		#Creació credencials user en K8S
		kubectl --kubeconfig "$HOME"/.kube/$env config set-credentials $user \
			--client-certificate=$directory/$user/"$user.crt" \
			--client-key=$directory/$user/"$user.key" \
			--embed-certs --kubeconfig=$directory/$user/"$user-config"
		#Creació context
		kubectl --kubeconfig "$HOME"/.kube/$env config set-context $user \
			--cluster=$(kubectl --kubeconfig "$HOME"/.kube/$env config view -o jsonpath='{.clusters[0].name}') \
			--namespace=$user \
			--user=$user \
			--kubeconfig=$directory/$user/"$user-config"
		#Creació namespace
		kubectl --kubeconfig "$HOME"/.kube/$env create ns $user
		#Creacio rol tipus admin per al user al seu namespace
		kubectl --kubeconfig "$HOME"/.kube/$env create rolebinding $user --namespace=$user --clusterrole=admin --user=$user
	done
	echo "El que cal fer ara en el user-config generat es:"
	echo "  · Modificar entrada server per entrada dns API"
	echo "  · Establir current context amb el nom del user"
	echo "cat $directory/$user/$user-config"
else
	red
	echo "File "$project_path"/modules/k8s/menus/rbac/users.txt not found"
	nocolor
fi
