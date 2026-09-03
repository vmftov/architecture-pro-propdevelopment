#!/bin/bash
set -e

# Пользователи и группы ###########################################################

export OPENSSL_CONF=$(cygpath -w /usr/ssl/openssl.cnf)
CA_CRT=$(cygpath -w "$HOME/.minikube/ca.crt")
CA_KEY=$(cygpath -w "$HOME/.minikube/ca.key")

create_user() {
    local username=$1
    local groupname=$2

    echo "Creating user $username in group $groupname"

    export MSYS_NO_PATHCONV=1

    openssl genrsa -out "${username}.key" 2048
    openssl req -new -key "${username}.key" -out "${username}.csr" -subj "/CN=${username}/O=${groupname}"
    openssl x509 -req -in "${username}.csr" -CA "$CA_CRT" -CAkey "$CA_KEY" -CAcreateserial -out "${username}.crt" -days 365

    kubectl config set-credentials "$username" \
        --client-certificate="${username}.crt" \
        --client-key="${username}.key" \
        --embed-certs=true

    kubectl config set-context "${username}-context" --cluster=minikube --user="$username"

    echo "User $username created with context ${username}-context"
    echo ""
}

create_user "ivan" "security-spec-group"
create_user "petr" "clients-dev-ops-group"
create_user "masha" "tenant-ops-group"
create_user "varvara" "accountant-developers-group"
echo ""

# Пространства имён ###############################################################

kubectl get ns clients >/dev/null 2>&1 || kubectl create namespace clients
kubectl get ns tenant >/dev/null 2>&1 || kubectl create namespace tenant
kubectl get ns accountant >/dev/null 2>&1 || kubectl create namespace accountant
kubectl get ns data >/dev/null 2>&1 || kubectl create namespace data
