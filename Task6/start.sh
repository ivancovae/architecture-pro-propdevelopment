#!/bin/bash
minikube start --vm-driver=docker --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=-
minikube kubectl -- get pods -A
read -p "Press enter to continue"