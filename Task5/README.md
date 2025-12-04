# architecture-propdevelopment

## Управление трафиком внутри кластера Kubertnetes

Запуск front-end сервиса:
```shell
kubectl run front-end-app --image=nginx --labels role=front-end --expose --port 80
```

Запуск back-end-api сервиса:
```shell
kubectl run back-end-api-app --image=nginx --labels role=back-end-api --expose --port 80
```

Запуск admin-front-end сервиса:
```shell
kubectl run admin-front-end-app --image=nginx --labels role=admin-front-end --expose --port 80
```

Запуск admin-back-end-api сервиса:
```shell
kubectl run admin-back-end-api-app --image=nginx --labels role=admin-back-end-api --expose --port 80
```

Применяем сетевые политики:
```shell
kubectl apply -f non-admin-api-allow.yaml
```
