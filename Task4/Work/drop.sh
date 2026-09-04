#!/bin/bash

kubectl delete -f ./4-create-role-bindings.yaml
kubectl delete -f ./3-create-roles.yaml
kubectl delete -f ./2-create-namespaces.yaml

kubectl config delete-context ivan-context
kubectl config delete-context petr-context
kubectl config delete-context masha-context
kubectl config delete-context varvara-context

kubectl config delete-user ivan
kubectl config delete-user petr
kubectl config delete-user masha
kubectl config delete-user varvara

rm *.key *.crt *.csr