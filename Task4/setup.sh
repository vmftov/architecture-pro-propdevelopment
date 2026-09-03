#!/bin/bash

./1-create-users-and-namespaces.sh

kubectl apply -f ./2-create-roles.yaml
kubectl apply -f ./3-create-role-bindings.yaml