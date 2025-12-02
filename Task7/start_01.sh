#!/bin/bash

minikube start --vm-driver=docker
kubectl apply -f 01-create-namespace.yaml
kubectl get ns audit-zone --show-labels