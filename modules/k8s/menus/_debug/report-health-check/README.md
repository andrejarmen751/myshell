# k8s

Para la creación del configmap se ha modificado de los scripts en "ScriptChequeo" lo siguiente:

 - El script stats.sh no pide parámetros. Se construye en un mismo script y la salida de los eventos pasa a ser tratado mediante archivos temporales. 

1. Deploy roles

Depende del entorno (Openshift o AKS) se tiene que desplegar yamls ubicados en la carpeta oc-role o aks-roles.

````
kubectl apply -f cluster-role.yaml
kubectl apply -f role-binding.yaml -n debug
````

2. Create Configmap

NOTA:
En el script aparece la URL descarga cliente oc, que pertenece a cada entorno, si se realiza deploy en un entorno OC hay que añadir dicha URL para correcto funcionamiento.

Se puede aplicar el manifiesto yaml configmap.yaml o bien si se hacen modificaciones en el script se tiene que generar usando:


````
kubectl create configmap health-check-scripts \
  --from-file=oneliner.sh \
  -n debug
````

Para obtener el yaml del configmap:

````
kubectl get configmap health-check-scripts -n debug -o yaml > configmap.yaml
````

3. Apply cronjob

````
kubectl apply -f cronjob.yaml -n debug
````