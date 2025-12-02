#!/bin/bash

echo "Testing Pod Security Admission..."

# Test privileged pod
echo "1. Testing privileged pod (should fail):"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml --dry-run=server

# Test hostPath pod
echo "2. Testing hostPath pod (should fail):"
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml --dry-run=server

# Test root user pod
echo "3. Testing root user pod (should fail):"
kubectl apply -f insecure-manifests/03-root-user-pod.yaml --dry-run=server

# Test secure pods
echo "4. Testing secure pods (should pass):"
kubectl apply -f secure-manifests/ --dry-run=server

echo "Admission testing completed."
