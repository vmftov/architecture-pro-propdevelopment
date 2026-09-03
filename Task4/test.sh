#!/bin/bash

echo "security -------------------------------------"

echo "expecting: yes"
kubectl auth can-i get secrets --context=ivan-context --all-namespaces

echo "expecting: yes"
kubectl auth can-i list pods --context=ivan-context --all-namespaces

echo "expecting: no"
kubectl auth can-i create pods --context=ivan-context -n clients

echo "dev-ops in clients ns -----------------------"

echo "expecting: yes"
kubectl auth can-i create secrets --context=petr-context -n clients

echo "expecting: yes"
kubectl auth can-i delete pods --context=petr-context -n clients

echo "expecting: no"
kubectl auth can-i get pods --context=petr-context -n tenant

echo "ops in tenant ns ----------------------------"

echo "expecting: yes"
kubectl auth can-i create pods --context=masha-context -n tenant

echo "expecting: no"
kubectl auth can-i get secrets --context=masha-context -n tenant

echo "expecting: no"
kubectl auth can-i get pods --context=masha-context -n clients

echo "developers in accountant ns -----------------"

echo "expecting: yes"
kubectl auth can-i list pods --context=varvara-context -n accountant

echo "expecting: no"
kubectl auth can-i create pods --context=varvara-context -n accountant

echo "expecting: no"
kubectl auth can-i list pods --context=varvara-context -n data