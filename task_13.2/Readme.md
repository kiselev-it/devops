# Установка nfs--provisioner

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.2/png/1.PNG?raw=true)

# Задание 1: подключить для тестового конфига общую папку

Манифест front-back приложения с volume:
```
apiVersion: v1
kind: Namespace
metadata:
  name: stage

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-front
  labels:
    app: backend-front
  namespace: stage
spec:
  selector:
    matchLabels:
      app: test
  replicas: 1
  template:
    metadata:
      labels:
        app: test
    spec:
      containers:
        - name: front
          image: nginx
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-nginx
              containerPort: 80
          volumeMounts:
            - mountPath: "/static"
              name: volume-test

        - name: back
          image: tomcat
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-tomcat
              containerPort: 8080
          volumeMounts:
            - mountPath: "/tomcat/static"
              name: volume-test
      volumes:
        - name: volume-test
          emptyDir: {}

---
apiVersion: v1
kind: Service
metadata:
  name: backend-front
  namespace: stage
spec:
  type: NodePort
  selector:
    app: test
  ports:
  - name: for-nginx
    protocol: TCP
    port: 80
    targetPort: 80
  - name: for-tomcat
    protocol: TCP
    port: 8080
    targetPort: 8080
```
#### Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.2/png/2.PNG?raw=true)

