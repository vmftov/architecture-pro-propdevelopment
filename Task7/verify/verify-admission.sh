#!/bin/bash

check_pod_exists() {
    local pod_name=$1
    local status

    if kubectl get pod "$pod_name" -n audit-zone &>/dev/null; then
        status=$(kubectl get pod "$pod_name" -n audit-zone -o jsonpath='{.status.phase}')
        echo -e "Под $pod_name создан. Статус пода: $status"
    else
        echo -e "Под $pod_name не создан"
    fi
}

###

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.." || exit 1
echo "Текущая директория: $(pwd)"

###

echo -e "\nСоздание пространства имён"
kubectl apply -f ./01-create-namespace.yaml

###

echo -e "\nЗапуск подов из insecure-manifests"
kubectl apply -f ./insecure-manifests/01-privileged-pod.yaml
kubectl apply -f ./insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f ./insecure-manifests/03-root-user-pod.yaml

sleep 2

echo -e "\n\nПроверка подов"
check_pod_exists "pod-privileged"
check_pod_exists "pod-hostpath"
check_pod_exists "pod-root-user"

echo -e "\nУдаление подов из insecure-manifests"
kubectl delete -f ./insecure-manifests/01-privileged-pod.yaml
kubectl delete -f ./insecure-manifests/02-hostpath-pod.yaml
kubectl delete -f ./insecure-manifests/03-root-user-pod.yaml

###

echo -e "\nЗапуск подов из secure-manifests"
kubectl apply -f ./secure-manifests/01-secure.yaml
kubectl apply -f ./secure-manifests/02-secure.yaml
kubectl apply -f ./secure-manifests/03-secure.yaml

sleep 2

echo -e "\nПроверка подов"
check_pod_exists "pod-secure-1"
check_pod_exists "pod-secure-2"
check_pod_exists "pod-secure-3"

echo -e "\nУдаление подов из secure-manifests"
kubectl delete -f ./secure-manifests/01-secure.yaml
kubectl delete -f ./secure-manifests/02-secure.yaml
kubectl delete -f ./secure-manifests/03-secure.yaml

###

echo -e "\nУдаление пространства имён"
kubectl delete -f ./01-create-namespace.yaml
