#!/bin/bash

./1-create-users.sh
kubectl apply -f ./2-create-namespaces.yaml
kubectl apply -f ./3-create-roles.yaml
kubectl apply -f ./4-create-role-bindings.yaml