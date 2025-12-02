#!/bin/bash
minikube stop
minikube delete --all --purge
# Создаем директорию для конфигураций аудита
mkdir -p C:/Users/Ivancov/.minikube/files/etc/ssl/certs
# Создаем audit policy
cat > C:/Users/Ivancov/.minikube/files/etc/ssl/certs/audit-policy.yaml << EOF
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: RequestResponse
    verbs: ["create", "delete", "update", "patch", "get", "list"]
    resources:
      - group: ""
        resources: ["pods", "secrets", "configmaps", "serviceaccounts", "roles", "rolebindings"]
  - level: Metadata
    resources:
      - group: ""
        resources: ["*"]
EOF
read -p "Press enter to continue"
