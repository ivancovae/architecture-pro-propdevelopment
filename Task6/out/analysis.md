# Отчёт по результатам анализа Kubernetes Audit Log

## Подозрительные события

1. Доступ к секретам:
   - Кто: system:apiserver
   - Где: ns=—, ресурс=secrets, имя=—
   - Почему подозрительно: попытка чтения secrets.

2. Привилегированные поды:
   - Кто: system:serviceaccount:kube-system:daemon-set-controller
   - Где: ns=kube-system, ресурс=pods, имя=—
   - Комментарий: создан под с privileged=true.

3. Использование kubectl exec в чужом поде:
   - Не обнаружено.

4. Создание RoleBinding с правами cluster-admin:
   - Не обнаружено.

5. Удаление audit-policy.yaml:
   - Не обнаружено.

## Вывод

- Всего подозрительных событий: 10
- Статистика: {"secrets": 8, "privileged-pod": 2, "cross-exec": 0, "cluster-admin": 0, "audit-policy-delete": 0}
- Основные ошибки RBAC: слишком широкие права на pods, secrets и RoleBinding.

### Активность пользователей:
- minikube-user: 5
- system:apiserver: 2
- kubernetes-admin: 2
- system:serviceaccount:kube-system:daemon-set-controller: 1