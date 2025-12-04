#!/bin/bash

AUDIT_LOG="logs/audit_kubectl.log"
OUTPUT_JSON="out/audit-extract.json"

echo "----------------------------------------------------------"
echo "Log: $AUDIT_LOG"
echo "Output: $OUTPUT_JSON"
echo "----------------------------------------------------------"

> "$OUTPUT_JSON"
# Фильтруем события по ключевым словам
jq '
   select(
      ((.user.username|startswith("system:")|not) and
      (.user.username!="kubernetes-admin") and
      (.user.username!="kubernetes-super-admin") and
      (.user.username!="minikube")) and
      ((.objectRef.resource=="secrets" and (.verb=="get" or .verb=="list")) or
      (.objectRef.resource=="pods" and (.requestObject.spec.containers[]?.securityContext?.privileged // false)) or
      (.objectRef.subresource=="exec" and .verb=="create") or
      (.objectRef.name=="audit-policy.yaml") or
      (.verb=="create") and (.objectRef.resource=="rolebindings" or .objectRef.resource=="clusterrolebindings"))
    )' $AUDIT_LOG > $OUTPUT_JSON

echo "Выжимка сохранена в $OUTPUT_JSON"