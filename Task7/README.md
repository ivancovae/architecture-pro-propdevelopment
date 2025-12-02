## Задание 7. Аудит и обеспечение соответствия политике безопасности контейнеров (PSP / PodSecurity / OPA Gatekee

# Структура решения
- `01-create-namespace.yaml` - namespace с политикой restricted
- `insecure-manifests/` - примеры нарушающих политику подов
- `secure-manifests/` - исправленные безопасные манифесты
- `gatekeeper/` - политики OPA Gatekeeper
- `verify/` - скрипты проверки
- `audit-policy.yaml` - политика аудита Kubernetes


--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> sh .\start_01.sh
😄  minikube v1.37.0 on Microsoft Windows 10 Pro 10.0.19045.6332 Build 19045.6332
✨  Using the docker driver based on user configuration
📌  Using Docker Desktop driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.48 ...
🔥  Creating docker container (CPUs=2, Memory=8100MB) ... 
❗  Failing to connect to https://registry.k8s.io/ from both inside the minikube container and host machine
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.34.0 on Docker 28.4.0 ... 
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass

❗  C:\Program Files\Docker\Docker\resources\bin\kubectl.exe is version 1.32.2, which may have incompatibilities with Kubernetes 1.34.0.
    ▪ Want kubectl v1.34.0? Try 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
namespace/audit-zone created
NAME         STATUS   AGE   LABELS
audit-zone   Active   1s    kubernetes.io/metadata.name=audit-zone,pod-security.kubernetes.io/audit=restricted,pod-security.kubernetes.io/enforce-version=latest,pod-security.kubernetes.io/enforce=restricted,pod-security.kubernetes.io/warn=restricted
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 


--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f insecure-manifests/
Error from server (Forbidden): error when creating "insecure-manifests\\01-privileged-pod.yaml": pods "pod-privileged" is forbidden: violates PodSecurity "restricted:latest": privileged (container "nginx" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
Error from server (Forbidden): error when creating "insecure-manifests\\02-hostpath-pod.yaml": pods "hostpath-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), restricted volume types (volume "host-vol" uses restricted volume type "hostPath"), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
Error from server (Forbidden): error when creating "insecure-manifests\\03-root-user-pod.yaml": pods "root-user-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), runAsUser=0 (container "nginx" must not set runAsUser=0), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f secure-manifests/
pod/secure-privileged-pod created
pod/secure-hostpath-pod created
pod/secure-root-user-pod created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get pods -n audit-zone
NAME                    READY   STATUS              RESTARTS   AGE
secure-hostpath-pod     1/1     Running             0          10s
secure-privileged-pod   0/1     ContainerCreating   0          10s
secure-root-user-pod    0/1     ContainerCreating   0          10s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7>

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.21.0/deploy/gatekeeper.yaml
namespace/gatekeeper-system created
resourcequota/gatekeeper-critical-pods created
Warning: unrecognized format "int64"
customresourcedefinition.apiextensions.k8s.io/assign.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignimage.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/assignmetadata.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/configpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/connectionpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/connections.connection.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplate.expansion.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/expansiontemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/modifyset.mutations.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/mutatorpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/providerpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/providers.externaldata.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/syncsets.syncset.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
poddisruptionbudget.policy/gatekeeper-controller-manager created
mutatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-mutating-webhook-configuration created
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get pods -n gatekeeper-system
NAME                                             READY   STATUS    RESTARTS      AGE
gatekeeper-audit-7cb59c798f-knt8s                1/1     Running   2 (27s ago)   41s
gatekeeper-controller-manager-8589dd6558-2lkbx   1/1     Running   0             41s
gatekeeper-controller-manager-8589dd6558-hpv2x   1/1     Running   0             41s
gatekeeper-controller-manager-8589dd6558-lbmth   1/1     Running   0             41s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7>

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7>
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraint-templates/privileged.yaml
constrainttemplate.templates.gatekeeper.sh/k8sprivileged created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraints/privileged.yaml
k8sprivileged.constraints.gatekeeper.sh/disallow-privileged created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constrainttemplates
NAME            AGE
k8sprivileged   13s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constraints
NAME                  ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
disallow-privileged   deny
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7>

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraint-templates/hostpath.yaml  
constrainttemplate.templates.gatekeeper.sh/k8shostpath created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraints/hostpath.yaml
k8shostpath.constraints.gatekeeper.sh/disallow-hostpath created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constrainttemplates
NAME            AGE
k8shostpath     38s
k8sprivileged   2m13s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constraints
NAME                                                      ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8shostpath.constraints.gatekeeper.sh/disallow-hostpath   deny

NAME                                                          ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8sprivileged.constraints.gatekeeper.sh/disallow-privileged   deny                 0
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7>

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraint-templates/runasnonroot.yaml
constrainttemplate.templates.gatekeeper.sh/k8srunasnonroot created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f gatekeeper/constraints/runasnonroot.yaml
k8srunasnonroot.constraints.gatekeeper.sh/require-runasnonroot created
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constrainttemplates
NAME              AGE
k8shostpath       108s
k8sprivileged     3m23s
k8srunasnonroot   22s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get constraints
NAME                                                      ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8shostpath.constraints.gatekeeper.sh/disallow-hostpath   deny                 0

NAME                                                          ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8sprivileged.constraints.gatekeeper.sh/disallow-privileged   deny                 0

NAME                                                             ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8srunasnonroot.constraints.gatekeeper.sh/require-runasnonroot   deny
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f insecure-manifests/ --namespace=audit-zone
Error from server (Forbidden): error when creating "insecure-manifests\\01-privileged-pod.yaml": pods "pod-privileged" is forbidden: violates PodSecurity "restricted:latest": privileged (container "nginx" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
Error from server (Forbidden): error when creating "insecure-manifests\\02-hostpath-pod.yaml": pods "hostpath-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), restricted volume types (volume "host-vol" uses restricted volume type "hostPath"), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
Error from server (Forbidden): error when creating "insecure-manifests\\03-root-user-pod.yaml": pods "root-user-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), runAsUser=0 (container "nginx" must not set runAsUser=0), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl apply -f secure-manifests/ --namespace=audit-zone
pod/secure-privileged-pod configured
pod/secure-hostpath-pod configured
pod/secure-root-user-pod configured
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> kubectl get pods -n audit-zone
NAME                    READY   STATUS    RESTARTS   AGE
secure-hostpath-pod     1/1     Running   0          6m22s
secure-privileged-pod   1/1     Running   0          6m22s
secure-root-user-pod    1/1     Running   0          6m22s
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> sh .\verify\validate-security.sh
Validating security policies...
1. Checking namespace labels:
{
  "kubernetes.io/metadata.name": "audit-zone",
  "pod-security.kubernetes.io/audit": "restricted",
  "pod-security.kubernetes.io/enforce": "restricted",
  "pod-security.kubernetes.io/enforce-version": "latest",
  "pod-security.kubernetes.io/warn": "restricted"
}
2. Checking Gatekeeper constraints:
NAME                                                      ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8shostpath.constraints.gatekeeper.sh/disallow-hostpath   deny                 0

NAME                                                          ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8sprivileged.constraints.gatekeeper.sh/disallow-privileged   deny                 0

NAME                                                             ENFORCEMENT-ACTION   TOTAL-VIOLATIONS
k8srunasnonroot.constraints.gatekeeper.sh/require-runasnonroot   deny                 0
3. Checking running pods:
secure-hostpath-pod     {"runAsNonRoot":true,"runAsUser":101}
secure-privileged-pod   {"runAsNonRoot":true,"runAsUser":101}
secure-root-user-pod    {"runAsNonRoot":true,"runAsUser":101}
Security validation completed.
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 


--- 

PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> sh .\verify\verify-admission.sh 
Testing Pod Security Admission...
1. Testing privileged pod (should fail):
Error from server (Forbidden): error when creating "insecure-manifests/01-privileged-pod.yaml": pods "pod-privileged" is forbidden: violates PodSecurity "restricted:latest": privileged (container "nginx" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
2. Testing hostPath pod (should fail):
Error from server (Forbidden): error when creating "insecure-manifests/02-hostpath-pod.yaml": pods "hostpath-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), restricted volume types (volume "host-vol" uses restricted volume type "hostPath"), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
3. Testing root user pod (should fail):
Error from server (Forbidden): error when creating "insecure-manifests/03-root-user-pod.yaml": pods "root-user-pod" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (pod or container "nginx" must set securityContext.runAsNonRoot=true), runAsUser=0 (container "nginx" must not set runAsUser=0), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
4. Testing secure pods (should pass):
pod/secure-privileged-pod configured (server dry run)
pod/secure-hostpath-pod configured (server dry run)
pod/secure-root-user-pod configured (server dry run)
Admission testing completed.
PS D:\w\YaProjects\architecture-pro-propdevelopment\Task7> 

--- 