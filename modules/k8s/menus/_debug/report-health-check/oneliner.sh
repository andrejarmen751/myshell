#!/bin/sh
##################################################### Parameters #####################################################
parameter_yq_version=$1
parameter_oc_client_pre=$2
parameter_oc_client_pre=$3
parameter_events_ignore_string=$4
parameter_certificates_evade_subjects=$5
##################################################### END Parameters #####################################################

##################################################### Files #####################################################
file_checkapihealth="/tmp/checkapihealth.txt"
if [ -f "/tmp/checkapihealth.txt" ]; then rm /tmp/checkapihealth.txt; else touch /tmp/checkapihealth.txt;fi
file_checknodes="/tmp/checknodes.txt"
if [ -f "/tmp/checknodes.txt" ]; then rm /tmp/checknodes.txt; else touch /tmp/checknodes.txt;fi
file_checkpods="/tmp/checkpods.txt"
if [ -f "/tmp/checkpods.txt" ]; then rm /tmp/checkpods.txt; else touch /tmp/checkpods.txt;fi
file_checkpvcs="/tmp/checkpvcs.txt"
if [ -f "/tmp/checkpvcs.txt" ]; then rm /tmp/checkpvcs.txt; else touch /tmp/checkpvcs.txt;fi
file_checkevents="/tmp/checkevents.txt"
if [ -f "/tmp/checkevents.txt" ]; then rm /tmp/checkevents.txt; else touch /tmp/checkevents.txt;fi
file_checkcertificates="/tmp/checkcertificates.txt"
if [ -f "/tmp/checkcertificates.txt" ]; then rm /tmp/checkcertificates.txt; else touch /tmp/checkcertificates.txt;fi
file_tls_cert="/tmp/tls.crt"
if [ -f "/tmp/tls.crt" ]; then rm /tmp/tls.crt; else touch /tmp/tls.crt;fi
# Specific for oc env
file_clusteroperator="/tmp/clusteroperator.txt"
if [ -f "/tmp/clusteroperator.txt" ]; then rm /tmp/clusteroperator.txt; else touch /tmp/clusteroperator.txt;fi
##################################################### END files #####################################################

##################################################### Functions #####################################################
check_api_health() {
    local max_attempts=40
    local attempt=0

    until kubectl get --raw '/livez?verbose' > /dev/null 2>&1; do
        if [ $attempt -ge $max_attempts ]; then
            return 1
        fi
        sleep 5
        attempt=$((attempt + 1))
    done
}
##################################################### END functions #####################################################

##################################################### Needed Software #####################################################
curl -L -o "/tmp/yq" "https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64"
chmod +x /tmp/yq
export PATH="$PATH:/tmp/"

check_api_health
if kubectl api-resources | grep -q "operator.openshift.io"; then
    if curl -L -o /tmp/oc.tar $parameter_oc_client_pre; then
        :
    else
        curl -L -o /tmp/oc.tar $parameter_oc_client_pre
    fi
    tar -xvf /tmp/oc.tar -C /tmp
    chmod +x /tmp/oc
    export PATH="$PATH:/tmp/"
fi
##################################################### END Needed Software #####################################################

##################################################### API #####################################################
echo "[DEBUG] Inciando comprobación de salud."

echo "[DEBUG] Iniciando módulo checkApiHealth.sh."
echo ""
# Comprueba los endpoints de salud del apiserver.
check_api_health
LIVE_CHECK=$(kubectl get --raw '/livez?verbose')
check_api_health
HEALTH_CHECK=$(kubectl get --raw '/readyz?verbose')

INDIVIDUAL_LIVE_CHECKS=$(printf '%s' "$LIVE_CHECK" | grep -E '^\[\+\].+')
OVERALL_LIVE_CHECK=$(printf '%s' "$LIVE_CHECK" | tail -n 1)

INDIVIDUAL_HEALTH_CHECKS=$(printf '%s' "$HEALTH_CHECK" | grep -E '^\[\+\].+')
OVERALL_HEALTH_CHECK=$(printf '%s' "$HEALTH_CHECK" | tail -n 1)

# comprobación de live check individuales
while read -r live_line
do
  ITEM=$(printf '%s' "$live_line" | cut -d " " -f 1 | cut -d "]" -f 2)
  STATUS=$(printf '%s' "$live_line" | cut -d " " -f 2)

  if test "$STATUS" != "ok"
  then
    echo "[CRITICAL] Live check de $ITEM en estado $STATUS."
    echo "[CRITICAL] Live check de $ITEM en estado $STATUS." >> $file_checkapihealth
  fi
done <<-EOF
$INDIVIDUAL_LIVE_CHECKS
EOF

# comprobación de live check general
if test "$OVERALL_LIVE_CHECK" = "livez check passed"
then
  echo "[INFO] $OVERALL_LIVE_CHECK."
  echo "[INFO] $OVERALL_LIVE_CHECK." >> $file_checkapihealth
else
  echo "[CRITICAL] $OVERALL_LIVE_CHECK."
  echo "[CRITICAL] $OVERALL_LIVE_CHECK." >> $file_checkapihealth
fi

# comprobación de health check individuales
while read -r ready_line
do
  ITEM=$(printf '%s' "$ready_line" | cut -d " " -f 1 | cut -d "]" -f 2)
  STATUS=$(printf '%s' "$ready_line" | cut -d " " -f 2)

  if test "$STATUS" != "ok"
  then
    echo "[CRITICAL] Ready check de $ITEM en estado $STATUS."
    echo "[CRITICAL] Ready check de $ITEM en estado $STATUS." >> $file_checkapihealth
  fi
done <<-EOF
$INDIVIDUAL_HEALTH_CHECKS
EOF

# comprobación de ready check general
if test "$OVERALL_HEALTH_CHECK" = "readyz check passed"
then
  echo "[INFO] $OVERALL_HEALTH_CHECK."
  echo "[INFO] $OVERALL_HEALTH_CHECK." >> $file_checkapihealth
else
  echo "[CRITICAL] $OVERALL_HEALTH_CHECK."
  echo "[CRITICAL] $OVERALL_HEALTH_CHECK." >> $file_checkapihealth
fi
echo ""
echo ""
echo ""
##################################################### END API #####################################################

##################################################### NODES #####################################################
echo "[DEBUG] Iniciando módulo checkNodes.sh."
echo ""
# Módulo que comprueba la salud de los nodos

# Porcentaje de uso de recursos
CPU_WARN=80
CPU_CRIT=90
MEM_WARN=80
MEM_CRIT=90

check_api_health
LISTA_NODOS=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')
check_api_health
if kubectl api-resources | grep -q "operator.openshift.io"; then
  # Lista de condiciones y sus expected values en OpenShift
  CONDITION_LIST=$(cat <<EOF
  {
    "MemoryPressure"              : {"expected": "False", "severity": "CRITICAL"},
    "DiskPressure"                : {"expected": "False", "severity": "CRITICAL"},
    "PIDPressure"                 : {"expected": "False", "severity": "WARNING"},
    "Ready"                       : {"expected": "True" , "severity": "CRITICAL"}
  }
EOF
  )
else
  # Lista de condiciones y sus expected values
  CONDITION_LIST=$(cat <<EOF
  {
    "FrequentKubeletRestart"      : {"expected": "False", "severity": "CRITICAL"},
    "KernelDeadlock"              : {"expected": "False", "severity": "CRITICAL"},
    "ReadonlyFilesystem"          : {"expected": "False", "severity": "CRITICAL"},
    "ContainerRuntimeProblem"     : {"expected": "False", "severity": "CRITICAL"},
    "FrequentDockerRestart"       : {"expected": "False", "severity": "CRITICAL"},
    "KubeletProblem"              : {"expected": "False", "severity": "CRITICAL"},
    "VMEventScheduled"            : {"expected": "False", "severity": "CRITICAL"},
    "FrequentContainerdRestart"   : {"expected": "False", "severity": "CRITICAL"},
    "FilesystemCorruptionProblem" : {"expected": "False", "severity": "CRITICAL"},
    "FrequentUnregisterNetDevice" : {"expected": "False", "severity": "CRITICAL"},
    "MemoryPressure"              : {"expected": "False", "severity": "CRITICAL"},
    "DiskPressure"                : {"expected": "False", "severity": "CRITICAL"},
    "PIDPressure"                 : {"expected": "False", "severity": "WARNING"},
    "Ready"                       : {"expected": "True" , "severity": "CRITICAL"}
  }
EOF
  )
fi
# Sirve para detectar si hay o no alertas
NO_ALERTS=0

for node in $LISTA_NODOS
do
  # Comprobación de uso de nodos.
  check_api_health
  NODE_STATUS_LINE="$(kubectl top nodes "$node" --no-headers | tr -s " " | tr -d %)"
  NODE_CPU_PERCENT=$(printf '%s' "$NODE_STATUS_LINE" | cut -d " " -f 3)
  NODE_MEM_PERCENT=$(printf '%s' "$NODE_STATUS_LINE" | cut -d " " -f 5)

  if test "$NODE_CPU_PERCENT" -ge "$CPU_CRIT" || test "$NODE_MEM_PERCENT" -ge "$MEM_CRIT"
  then
    echo "[CRITICAL] Nodo $node CPU: $NODE_CPU_PERCENT, MEM: $NODE_MEM_PERCENT"
    echo "[CRITICAL] Nodo $node CPU: $NODE_CPU_PERCENT, MEM: $NODE_MEM_PERCENT" >> $file_checknodes
    NO_ALERTS=1
  elif test "$NODE_CPU_PERCENT" -ge "$CPU_WARN" || test "$NODE_MEM_PERCENT" -ge "$MEM_WARN"
  then
    echo "[WARNING] Nodo $node CPU: $NODE_CPU_PERCENT, MEM: $NODE_MEM_PERCENT"
    echo "[WARNING] Nodo $node CPU: $NODE_CPU_PERCENT, MEM: $NODE_MEM_PERCENT" >> $file_checknodes
    NO_ALERTS=1
  fi

  # Comprobar conditions del nodo
  check_api_health
  CONDITIONS=$(kubectl get node "$node" -o jsonpath='{.status.conditions}')

  LISTA_COND=$(printf '%s' "$CONDITION_LIST" | jq -r 'keys | join(" ")')

  for condition in $LISTA_COND
  do
    CONDITION_OBJ=$(printf '%s' "$CONDITIONS" | jq ".[] | select(.type == \"$condition\")")
    STATUS=$(printf '%s' "$CONDITION_OBJ" | jq -r ".status")
    EXPECTED=$(printf '%s' "$CONDITION_LIST" | jq -r ".[\"$condition\"].expected")
    SEVERITY=$(printf '%s' "$CONDITION_LIST" | jq -r ".[\"$condition\"].severity")

    if test "$STATUS" = "$EXPECTED"
    then
      echo "[INFO] Condición $condition en $node en estado esperado"
      echo "[INFO] Condición $condition en $node en estado esperado" >> $file_checknodes
    else
      echo "[$SEVERITY] Condición $condition en $node en estado $STATUS, comprobar salud del nodo."
      echo "[$SEVERITY] Condición $condition en $node en estado $STATUS, comprobar salud del nodo." >> $file_checknodes
      NO_ALERTS=1
    fi

  done
done

# Comprobación de estado de nodos
if test $NO_ALERTS -eq 0
then
  echo "[INFO] Los nodos están en estado correcto."
fi
##################################################### END NODOS #####################################################

##################################################### PODS #####################################################
echo ""
echo ""
echo ""
echo "[DEBUG] Iniciando módulo checkPods.sh"
echo ""

check_api_health

PODS_INFO_PER_LINE=$(kubectl get po -A -o json | jq -j '.items[] | "[\(.metadata),\(.status)]\n"')

# Recorrer todos los pods
while read -r pod_line; do
    NAME=$(printf '%s' "$pod_line" | jq -r .[0].name)
    NAMESPACE=$(printf '%s' "$pod_line" | jq -r .[0].namespace)
    CONDITIONS=$(printf '%s' "$pod_line" | jq -r '.[1].conditions[] | "\(.type):\(.status)"')
    PHASE=$(printf '%s' "$pod_line" | jq -r '.[1].phase')
    HEALTHY=0

    # Check Phase
    if test "$PHASE" = "Failed"; then
        echo "[CRITICAL] El pod $NAME del namespace $NAMESPACE está en estado $PHASE."
        echo "[CRITICAL] El pod $NAME del namespace $NAMESPACE está en estado $PHASE." >> $file_checkpods
        HEALTHY=1
    elif test "$PHASE" = "Pending" || test "$PHASE" = "Unknown"; then
        echo "[WARNING] El pod $NAME del namespace $NAMESPACE está en estado $PHASE."
        echo "[CRITICAL] El pod $NAME del namespace $NAMESPACE está en estado $PHASE." >> $file_checkpods
        HEALTHY=1
    elif test "$PHASE" = "Succeeded" || test "$PHASE" = "Completed"; then
        continue
    fi

    # Check Conditions
    for condition in $CONDITIONS; do
        CONDITION_STATUS=$(printf '%s' "$condition" | cut -d ":" -f 2)
        CONDITION_NAME=$(printf '%s' "$condition" | cut -d ":" -f 1)
        if test "$CONDITION_STATUS" != "True" && test "$CONDITION_NAME" = "Ready"; then
            echo "[WARNING] El pod $NAME del namespace $NAMESPACE tiene la condición $CONDITION_NAME en estado $CONDITION_STATUS."
            echo "[WARNING] El pod $NAME del namespace $NAMESPACE tiene la condición $CONDITION_NAME en estado $CONDITION_STATUS." >> $file_checkpods
            HEALTHY=1
        elif test "$CONDITION_STATUS" != "True"; then
            echo "[CRITICAL] El pod $NAME del namespace $NAMESPACE tiene la condición $CONDITION_NAME en estado $CONDITION_STATUS."
            echo "[CRITICAL] El pod $NAME del namespace $NAMESPACE tiene la condición $CONDITION_NAME en estado $CONDITION_STATUS." >> $file_checkpods
            HEALTHY=1
        fi
    done

    if test "$HEALTHY" -eq 0; then
        echo "[INFO] Las condiciones del pod $NAME del namespace $NAMESPACE están correctas."
        echo "[INFO] Las condiciones del pod $NAME del namespace $NAMESPACE están correctas." >> $file_checkpods
    fi
done <<-EOF
$PODS_INFO_PER_LINE
EOF
##################################################### END PODS #####################################################

##################################################### PVC/PV #####################################################
echo ""
echo ""
echo ""
echo "[DEBUG] Iniciando módulo checkPvcs.sh"
echo ""
check_api_health
PVC_PER_LINE=$(kubectl get pvc -A -o json | jq -r '.items[] | "\(.)"')

check_api_health
PV_PER_LINE=$(kubectl get pv -o json | jq -r '.items[] | "\(.)"')



# Check PVCs
while read -r pvc_line
do
  NAME=$(printf '%s' "$pvc_line" | jq -r '.metadata.name')
  NAMESPACE=$(printf '%s' "$pvc_line" | jq -r '.metadata.namespace')
  PHASE=$(printf '%s' "$pvc_line" | jq -r '.status.phase')

  if test "$PHASE" != "Bound" && test "$PHASE" != ""
  then
    echo "[WARNING] PVC $NAME del namespace $NAMESPACE está en estado $PHASE."
    echo "[WARNING] PVC $NAME del namespace $NAMESPACE está en estado $PHASE." >> $file_checkpvcs
  elif test "$PHASE" != ""
  then
    echo "[INFO] PVC $NAME del namespace $NAMESPACE está bound."
    echo "[INFO] PVC $NAME del namespace $NAMESPACE está bound." >> $file_checkpvcs
  fi
done <<-EOF
$PVC_PER_LINE
EOF


# Check de PVs
while read -r pv_line
do
  NAME=$(printf '%s' "$pv_line" | jq -r '.metadata.name')
  PHASE=$(printf '%s' "$pv_line" | jq -r '.status.phase')

  IS_HEALTHY=0

  # Phase check
  if test "$PHASE" = 'Failed'
  then
    echo "[CRITICAL] PV $NAME esta en estado $PHASE."
    echo "[CRITICAL] PV $NAME esta en estado $PHASE." >> $file_checkpvcs
    IS_HEALTHY=1
  elif test "$PHASE" = 'Available'
  then
    echo "[NOTICE] PV $NAME no está asociado con ningún Claim, estado $PHASE."
    echo "[NOTICE] PV $NAME no está asociado con ningún Claim, estado $PHASE." >> $file_checkpvcs
  fi


  if test "$IS_HEALTHY" -eq 0
  then
    echo "[INFO] PV $NAME ok."
    echo "[INFO] PV $NAME ok."  >> $file_checkpvcs
  fi

done <<-EOF
$PV_PER_LINE
EOF
##################################################### END PVC/PV #####################################################

##################################################### EVENTS #####################################################
echo ""
echo ""
echo ""
echo "[DEBUG] Iniciando módulo checkEvents.sh"
echo ""

# Chequeo de eventos
check_api_health

kubectl get events -A -o json | /tmp/yq -r '.items[]' | while IFS= read -r event; do
    NAME=$(echo "$event" | /tmp/yq -r '.involvedObject.name')
    NAMESPACE=$(echo "$event" | /tmp/yq -r '.involvedObject.namespace')
    REPORTING_COMPONENT=$(echo "$event" | /tmp/yq -r '.reportingComponent')
    DATE=$(echo "$event" | /tmp/yq -r '.firstTimestamp')
    REASON=$(echo "$event" | /tmp/yq -r '.reason')
    MESSAGE=$(echo "$event" | /tmp/yq -r '.message')
    TYPE=$(echo "$event" | /tmp/yq -r '.type')
    
    if [ "$TYPE" != "Normal" ]; then
        echo "[WARNING] Evento $NAME en namespace $NAMESPACE de $REPORTING_COMPONENT en $DATE. $REASON: $MESSAGE."
        if echo "$MESSAGE" | grep -q -E "$parameter_events_ignore_string"; then
                continue
        fi
        echo "[WARNING] Evento $NAME en namespace $NAMESPACE de $REPORTING_COMPONENT en $DATE. $REASON: $MESSAGE." >> $file_checkevents
    fi
done
##################################################### END EVENTS #####################################################

##################################################### CERTS #####################################################
echo ""
echo ""
echo ""
echo "[DEBUG] Iniciando módulo checkCertificates.sh"
echo ""

# Get all namespaces
check_api_health
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

for namespace in $namespaces; do
    check_api_health
    secrets=$(kubectl get secrets -n "$namespace" -o jsonpath='{.items[*].metadata.name}')
    
    for secret in $secrets; do
        check_api_health
        cert_data=$(kubectl get secret "$secret" -n "$namespace" -o jsonpath='{.data.tls\.crt}')
        
        echo "$cert_data" | base64 --decode > $file_tls_cert 2>/dev/null
        
        openssl x509 -in $file_tls_cert -text -noout >/dev/null 2>&1
        if [ $? -ne 0 ]; then continue; fi
        
        not_before=$(openssl x509 -in $file_tls_cert -text -noout | grep 'Not Before' | awk -F': ' '{print $2}')
        not_after=$(openssl x509 -in $file_tls_cert -text -noout | grep 'Not After' | awk -F': ' '{print $2}')
        subject=$(openssl x509 -in $file_tls_cert -text -noout | grep 'Subject:' | awk -F': ' '{print $2}' | awk -F'=' '{print $2}' | sed 's/, CN//')

        formatted_not_before=$(date -d "$not_before" +"%s" 2>/dev/null)
        formatted_not_after=$(date -d "$not_after" +"%s" 2>/dev/null)
        
        current_date=$(date +"%s")
        
        if [ "$current_date" -ge "$formatted_not_after" ]; then
            echo "[CRITICAL] El certificado '$secret' del namespace '$namespace' está expirado."
            echo "[CRITICAL] El certificado '$secret' del namespace '$namespace' está expirado." >> $file_checkcertificates
        elif [ $((formatted_not_after - current_date)) -lt $((30*86400)) ]; then
            time_until_expiration=$((formatted_not_after - current_date))
            days=$((time_until_expiration / 86400))
            hours=$(( (time_until_expiration % 86400) / 3600 ))
            minutes=$(( (time_until_expiration % 3600) / 60 ))

            item_to_check=$(echo "$subject" | sed "s/^ *//;s/ *$//")

            match_found=false
            for evade_subject in $parameter_certificates_evade_subjects; do
                trimmed_evade_subject=$(echo "$evade_subject" | sed "s/^ *//;s/ *$//")
                if [ "$item_to_check" = "$trimmed_evade_subject" ] || [ "${item_to_check#"$trimmed_evade_subject"}" != "$item_to_check" ]; then
                    match_found=true
                    break
                fi
            done

            if [ "$match_found" = true ]; then
                :
            else
                if [ "$time_until_expiration" -ge 86400 ]; then
                    echo "[WARNING] El certificado '$secret' del namespace '$namespace' va a expirar en $days días, $hours horas y $minutes minutos. Issuer es '$subject'"
                    echo "[WARNING] El certificado '$secret' del namespace '$namespace' va a expirar en $days días, $hours horas y $minutes minutos." >> $file_checkcertificates
                fi
            fi
        fi
    done
done
rm $file_tls_cert
##################################################### END CERTS #####################################################

##################################################### CLUSTEROPERATOR #####################################################
check_api_health
if kubectl api-resources | grep -q "operator.openshift.io"; then
  echo ""
  echo ""
  echo ""
  echo "[DEBUG] Iniciando módulo OC"
  echo ""
  oc get clusteroperator > $file_clusteroperator
  cat $file_clusteroperator
fi

echo ""
echo ""
echo ""
##################################################### END CLUSTEROPERATOR #####################################################

##################################################### statistics #####################################################
INFOS=$(grep -o "\[INFO\]" $file_checkapihealth $file_checknodes $file_checkpods $file_checkpvcs $file_checkevents $file_checkcertificates | wc -l)
NOTICES=$(grep -o "\[NOTICES\]" $file_checkapihealth $file_checknodes $file_checkpods $file_checkpvcs $file_checkevents $file_checkcertificates | wc -l)
WARNINGS=$(grep -o "\[WARNING\]" $file_checkapihealth $file_checknodes $file_checkpods $file_checkpvcs $file_checkevents $file_checkcertificates | wc -l)
CRITICALS=$(grep -o "\[CRITICAL\]" $file_checkapihealth $file_checknodes $file_checkpods $file_checkpvcs $file_checkevents $file_checkcertificates | wc -l)
printf '\n######## RESUMEN ###################\n'
printf '\e[94m INFOS:     %s\e[0m\n' "$INFOS"
printf '\e[96m NOTICES:   %s\e[0m\n' "$NOTICES"
printf '\e[93m WARNINGS:  %s\e[0m\n' "$WARNINGS"
printf '\e[91m CRITICALS: %s\e[0m\n' "$CRITICALS"
printf '####################################\n'
##################################################### END statistics #####################################################

##################################################### final report #####################################################
echo ""
echo ""
echo ""
echo "Las alertas a reportar son las que aparecen a continuación:"
echo ""
echo ""
echo '######## NOTICES ##################'
printf '\e[96m'
for file in "$file_checkapihealth" "$file_checknodes" "$file_checkpods" "$file_checkpvcs" "$file_checkevents" "$file_checkcertificates"; do
    grep '^\[NOTICE\]' "$file"
done
printf '\e[0m'
echo ''

echo '######## WARNINGS ##################'
printf '\e[93m'
for file in "$file_checkapihealth" "$file_checknodes" "$file_checkpods" "$file_checkpvcs" "$file_checkevents" "$file_checkcertificates"; do
    grep '^\[WARNING\]' "$file" | grep -v 'health-check-cronjob.*namespace debug'
done 
printf '\e[0m'

echo ''
echo '######## CRITICALS #################'
printf '\e[91m'
for file in "$file_checkapihealth" "$file_checknodes" "$file_checkpods" "$file_checkpvcs" "$file_checkevents" "$file_checkcertificates"; do
    grep '^\[CRITICAL\]' "$file" | grep -v 'health-check-cronjob.*namespace debug'
done
if [ -f "/tmp/clusteroperator.txt" ]; then awk 'NR > 1 && $3 != "True" {printf "[CLUSTEROPERATOR] %s %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6}' $file_clusteroperator
printf '\e[0m';fi


rm "$file_checkapihealth" "$file_checknodes" "$file_checkpods" "$file_checkpvcs" "$file_checkevents" "$file_checkcertificates" 
check_api_health
if kubectl api-resources | grep -q "operator.openshift.io"; then
    rm "$file_clusteroperator"
fi
##################################################### END final report #####################################################

##################################################### pod exit #####################################################
if [ "$WARNINGS" -ge 1 ] || [ "$CRITICALS" -ge 1 ]; then
    exit 1  # Exit with a non-zero status to crash the pod
else
    echo "Pod completed successfully."
    exit 0  # Exit with zero status to indicate success
fi
##################################################### END pod exit #####################################################