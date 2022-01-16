# Задание 1: подготовить helm чарт для приложения
## 1. Каждый компонент приложения деплоится отдельным deployment’ом/statefulset’ом
Директория helmtest/ лежит здесь в репо.

deployment.yaml:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-front-app
  labels:
    app: {{ .Release.Name }}-front-app
  namespace: {{ .Values.namespace }}
spec:
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  replicas: {{ .Values.replicaCount }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: {{ .Release.Name }}-front-app
          image: {{ .Values.containers.image }}
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-front-app
              containerPort: {{ .Values.frontAppPort }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
```
services.yaml:

```
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-front-services
  namespace: {{ .Values.namespace }}
spec:
  type: {{ .Values.service.type }}
  selector:
    app: {{ .Release.Name }}
  ports:
  - name: for-nginx
    protocol: TCP
    port: {{ .Values.service.port }}
    targetPort: {{ .Values.service.targetPort }}

```

namespace.yaml:

```
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.namespace }}
```
values.yaml:

```
namespace: test

frontAppPort: 80

replicaCount: 2

containers:
  image: nginx

service:
  type: NodePort
  port: 80
  targetPort: 80

resources:
   limits:
     cpu: 200m
     memory: 256Mi
   requests:
     cpu: 100m
     memory: 128Mi

```

Проверка:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.4/png/1.PNG?raw=true)

## 2. В переменных чарта измените образ приложения для изменения версии  

Обновляем helm-релиз командой `helm upgrade front --set containers.image=tomcat:8.5.38 helm-test/` чтобы поменять image:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.4/png/2.PNG?raw=true)

И проверка поменялся ли образ:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.4/png/3.PNG?raw=true)

# Задание 2: запустить 2 версии в разных неймспейсах
Подготовив чарт, необходимо его проверить. Попробуйте запустить несколько копий приложения:
- одну версию в namespace=app1;
- вторую версию в том же неймспейсе;
- третью версию в namespace=app2.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.4/png/4.PNG?raw=true)


При попытке деплоя второй версии в том же namespace выходит ошибка (на скрине видно):

```
Error: INSTALLATION FAILED: rendered manifests contain a   resource that already exists. Unable to continue with   install: Namespace "app1" in namespace "" exists and cannot   be imported into the current release: invalid ownership   metadata; annotation validation error: key   "meta.helm.sh/release-name" must equal "test3": current   value is "test1"
```
Так и не понял почему не получается, хотя смотрел видео и там получилось сделать (https://www.youtube.com/watch?v=-lLT0vlaBpk&list=PLg5SS_4L6LYvN1RqaVesof8KAf-02fJSi&index=12).  
Возмодно разные версии helm/kubernetes.

Может тут как раз что-то с аннотациями, на предыдущей лекции вы вроде упоминали, что иногда возникают проблемы и их необходимо менять.