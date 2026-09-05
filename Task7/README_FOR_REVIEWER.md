# Подготовка

Запустите minikube:

```
minikube start
```

# Проверка PodSecurity Admission

Чтобы проверить PodSecurity Admission, перейдите в директорию `Task7` и выполните скрипт:

```
./verify/verify-admission.sh
```

Скрипт:

1. Cоздаст пространство имён с PodSecurity Admission

2. Попытается создать поды из insecure-manifests

    Создание подов завершится ошибками. В терминале появятся стандартные ошибки от PodSecurity Admission:

    ```
    Запуск подов из insecure-manifests
    Error from server (Forbidden): error when creating "./insecure-manifests/01-privileged-pod.yaml": pods "pod-privileged" is forbidden: violates PodSecurity "restricted:latest": privileged (container "nginx" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
    Error from server (Forbidden): error when creating "./insecure-manifests/02-hostpath-pod.yaml": pods "pod-hostpath" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), restricted volume types (volume "host-root" uses restricted volume type "hostPath"), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
    Error from server (Forbidden): error when creating "./insecure-manifests/03-root-user-pod.yaml": pods "pod-root-user" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (container "nginx" must not set securityContext.runAsNonRoot=false), runAsUser=0 (container "nginx" must not set runAsUser=0), seccompProfile (pod or container "nginx" must set securityContext.seccompProfile.type to "RuntimeDefault" or "Localhost")
    ```

    После создания будут выполнены проверки наличия подов. В терминале появятся сообщения об отсутствии подов:

    ```
    Проверка подов
    Под pod-privileged не создан
    Под pod-hostpath не создан
    Под pod-root-user не создан
    ```

    **Данная ситуация говорит о том, что PodSecurity Admission включён и действует.**

3. Успешно создаст поды из secure-manifests

    Манифесты создания подов успешно выполнятся. В терминале появятся соответствующие сообщения.

    ```
    Запуск подов из secure-manifests
    pod/pod-secure-1 created
    configmap/config-secure-2-index created
    pod/pod-secure-2 created
    pod/pod-secure-3 created
    ```

    После создания будут выполнены проверки наличия подов. В терминале появятся сообщения о наличии подов:

    ```
    Проверка подов
    Под pod-secure-1 создан. Статус пода: Pending
    Под pod-secure-2 создан. Статус пода: Pending
    Под pod-secure-3 создан. Статус пода: Pending
    ```

    **Данная ситуация говорит о том, что PodSecurity Admission включён, а манифесты удовлетворяют всем его требованиям.**

4. Удалит все созданные ресурсы

# Проверка ограничений Gatekeeper

Чтобы проверить работу ограничений Gatekeeper, перейдите в директорию `Task7` и выполните скрипт:

```
./verify/validate-security.sh
```

Скрипт:

1. Cоздаст пространство имён без PodSecurity Admission

2. Инициализирует Gatekeeper

3. Создаст шаблоны и ограничения Gatekeeper

4. Попытается создать поды из insecure-manifests

    Создание подов завершится ошибками. В терминале появятся ошибки от кастомных правил Gatekeeper. Ошибки будут соответствовать типу нарушения:

    ```
    Запуск подов из insecure-manifests
    Error from server (Forbidden): error when creating "./insecure-manifests/01-privileged-pod.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [disable-privileged] Container nginx must not be privileged
    Error from server (Forbidden): error when creating "./insecure-manifests/02-hostpath-pod.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [disable-host-path] Container nginx must have readOnlyRootFilesystem setting
    [disable-host-path] hostPath volume host-root is not allowed
    Error from server (Forbidden): error when creating "./insecure-manifests/03-root-user-pod.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [disable-root-user] Container nginx must run as non-root user
    ```

    После создания будут выполнены проверки наличия подов. В терминале появятся сообщения об отсутствии подов:

    ```
    Проверка подов
    Под pod-privileged не создан
    Под pod-hostpath не создан
    Под pod-root-user не создан
    ```

    **Данная ситуация говорит о том, что Gatekeeper активно применяет ограничения.**

5. Успешно создаст поды из secure-manifests

    Манифесты создания подов успешно выполнятся. В терминале появятся соответствующие сообщения.

    ```
    Запуск подов из secure-manifests
    pod/pod-secure-1 created
    configmap/config-secure-2-index created
    pod/pod-secure-2 created
    pod/pod-secure-3 created
    ```

    После создания будут выполнены проверки наличия подов. В терминале появятся сообщения о наличии подов:

    ```
    Проверка подов
    Под pod-secure-1 создан. Статус пода: Pending
    Под pod-secure-2 создан. Статус пода: Pending
    Под pod-secure-3 создан. Статус пода: Pending
    ```

    **Данная ситуация говорит о том, что манифесты удовлетворяют всем требованиям Gatekeeper.**

6. Удалит все созданные ресурсы
