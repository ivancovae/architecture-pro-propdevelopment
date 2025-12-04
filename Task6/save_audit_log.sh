#!/bin/bash

minikube kubectl -- get pods -A 

mkdir -p ./logs
minikube logs | grep "audit.k8s.io/v1" >> ./logs/audit_minikube.log

kubectl logs kube-apiserver-minikube -n kube-system | grep audit.k8s.io/v1 >> ./logs/audit_kubectl.log

read -p "Press enter to continue"