# architecture-propdevelopment

## Управление кластером Kubertnetes

Запуск:

```shell
minikube start --vm-driver=docker --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=-
```

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6> minikube start --vm-driver=docker --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=-       
😄  minikube v1.37.0 on Microsoft Windows 10 Pro 10.0.19045.6332 Build 19045.6332
✨  Using the docker driver based on user configuration
📌  Using Docker Desktop driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.48 ...
💾  Downloading Kubernetes v1.34.0 preload ...
    > preloaded-images-k8s-v18-v1...:  337.07 MiB / 337.07 MiB  100.00% 32.94 M
🔥  Creating docker container (CPUs=2, Memory=8100MB) ...
❗  Failing to connect to https://registry.k8s.io/ from both inside the minikube container and host machine
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.34.0 on Docker 28.4.0 ...
    ▪ apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml
    ▪ apiserver.audit-log-path=-
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass

❗  C:\Program Files\Docker\Docker\resources\bin\kubectl.exe is version 1.32.2, which may have incompatibilities with Kubernetes 1.34.0.
    ▪ Want kubectl v1.34.0? Try 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6>
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6>
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6>
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6>
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6> minikube kubectl -- get pods -A
    > kubectl.exe.sha256:  64 B / 64 B [---------------------] 100.00% ? p/s 0s
    > kubectl.exe:  59.26 MiB / 59.26 MiB [--------] 100.00% 77.81 MiB p/s 1.0s
NAMESPACE     NAME                               READY   STATUS    RESTARTS       AGE
kube-system   coredns-66bc5c9577-mtfb5           1/1     Running   0              9m30s
kube-system   etcd-minikube                      1/1     Running   0              9m37s
kube-system   kube-apiserver-minikube            1/1     Running   0              9m37s
kube-system   kube-controller-manager-minikube   1/1     Running   0              9m37s
kube-system   kube-proxy-x9782                   1/1     Running   0              9m31s
kube-system   kube-scheduler-minikube            1/1     Running   0              9m37s
kube-system   storage-provisioner                1/1     Running   1 (9m9s ago)   9m34s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task6> 

```shell
sh .\simulate-incident.sh
```

Error from server (AlreadyExists): namespaces "secure-ops" already exists
Context "minikube" modified.
error: failed to create serviceaccount: serviceaccounts "monitoring" already exists
Error from server (AlreadyExists): pods "attacker-pod" already exists
yes
Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:secure-ops:monitoring" cannot list resource "secrets" in API group "" in the namespace "kube-system"
pod/privileged-pod unchanged
OCI runtime exec failed: exec failed: unable to start container process: exec: "cat": executable file not found in $PATH: unknown
command terminated with exit code 127
error: the path "D:/Program Files/Git/Git/etc/kubernetes/audit-policy.yaml" does not exist
rolebinding.rbac.authorization.k8s.io/escalate-binding unchanged
Press enter to continue



Подготовка:
```shell
sh .\prepere_start.sh
```


Запуск:
```shell
sh .\start.sh
```

Симуляция:
```shell
sh .\simulate-incident.sh
```

Аудит логов:
```shell
sh .\save_audit_log.sh
```

Парсинг логов:
```shell
python analyze_audit_log.py --log logs\audit_kubectl.log --out out
```