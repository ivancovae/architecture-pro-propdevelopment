#!/bin/bash

echo "Validating security policies..."

# Check namespace labels
echo "1. Checking namespace labels:"
kubectl get namespace audit-zone -o jsonpath='{.metadata.labels}' | jq .

# Check Gatekeeper constraints
echo "2. Checking Gatekeeper constraints:"
kubectl get constraints -n audit-zone

# Check running pods security contexts
echo "3. Checking running pods:"
kubectl get pods -n audit-zone -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.securityContext}{"\n"}{end}'

echo "Security validation completed."
