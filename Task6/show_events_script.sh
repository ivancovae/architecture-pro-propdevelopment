#!/bin/bash

AUDIT_LOG="logs/audit_kubectl.log"
OUTPUT="out/audit-extract.json"

echo "----------------------------------------------------------"
echo "Log: $AUDIT_LOG"
echo "Output: $OUTPUT"
echo "----------------------------------------------------------"

> "$OUTPUT"

START_TIME=$(date +%s)
COUNT=0
COUNT_LINES=100
ALL_LINES="$(wc -l < $AUDIT_LOG)"
echo "$ALL_LINES lines in $AUDIT_LOG"

while IFS= read -r LINE; do
    COUNT=$((COUNT + 1))

    # Каждые 100 строк – выводим прогресс
    if (( COUNT % ${COUNT_LINES} == 0 )); then
        CURRENT_TIME=$(date +%s)
        ELAPSED=$((CURRENT_TIME - START_TIME))
        SPEED=$((COUNT / (ELAPSED + 1)))
        echo "[ $COUNT / $ALL_LINES ] elapsed ${ELAPSED}s, ~${SPEED} lines/sec"
    fi

    #### 1. Доступ к secrets от system:serviceaccount:monitoring. ####
    if echo "$LINE" | jq -e '
        .verb=="get"
    ' >/dev/null 2>&1 &&
       echo "$LINE" | jq -e '.objectRef.resource == "secrets"' >/dev/null 2>&1; then
        echo "$LINE" >> "$OUTPUT"
        continue
    fi

    #### 2. Создание привилегированного пода ####
    if echo "$LINE" | jq -e '
        .objectRef.resource == "pods"
        and (.requestObject.spec.containers[]?.securityContext.privileged == true)
    ' >/dev/null 2>&1; then
        echo "$LINE" >> "$OUTPUT"
        continue
    fi

    #### 3. Использование kubectl exec в чужом поде ####
    if echo "$LINE" | jq -e '
        select(.verb=="create" and .objectRef.subresource=="exec")
    ' >/dev/null 2>&1; then
        echo "$LINE" >> "$OUTPUT"
        continue
    fi

    #### 4. Удаление audit-policy ####
    if echo "$LINE" | jq -e '
        .verb == "delete"
        and (
            .objectRef.name == "audit-policy.yaml"
            or (.requestURI | contains("audit-policy.yaml"))
        )
    ' >/dev/null 2>&1; then
        echo "$LINE" >> "$OUTPUT"
        continue
    fi

    #### 5. Создание RoleBinding без согласования ####
    if echo "$LINE" | jq -e '
        .verb == "create"
        and .objectRef.resource == "rolebindings"
    ' >/dev/null 2>&1; then
        echo "$LINE" >> "$OUTPUT"
        continue
    fi

done < "$AUDIT_LOG"

END_TIME=$(date +%s)
ELAPSED_TOTAL=$((END_TIME - START_TIME))

echo "----------------------------------------------------------"
echo "Done. Total processed: $COUNT lines"
echo "Total time: ${ELAPSED_TOTAL}s"
echo "Extract saved to: $OUTPUT"
