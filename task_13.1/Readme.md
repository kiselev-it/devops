# Задание 1: подготовить тестовый конфиг для запуска приложения  

Конфиг back + front приложений:  

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
          env:
            - name: BASE_URL
              value: "http://localhost:8080"
        - name: back
          image: tomcat:8.5.38
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-tomcat
              containerPort: 8080
          env:
            - name: DATABASE_URL
              value: "postgres://postgres:postgres@db:5432/test"

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

Дб через statefulset:

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgresql-db
  namespace: stage
spec:
  serviceName: postgresql-db-service
  selector:
    matchLabels:
      app: postgresql-db
  replicas: 1
  template:
    metadata:
      labels:
        app: postgresql-db
    spec:
      containers:
        - name: postgresql-db
          image: postgres
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: postgresql-db-disk
              mountPath: /data
          env:
            - name: POSTGRES_PASSWORD
              value: "postgres"
            - name: PGDATA
              value: /data/pgdata
            - name: POSTGRES_USER
              value: "postgres"
            - name: POSTGRES_DB
              value: "test"

  volumeClaimTemplates:
    - metadata:
        name: postgresql-db-disk
      spec:
        storageClassName: "nfs"
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi

---
apiVersion: v1
kind: Service
metadata:
  name: postgres-db-service
  namespace: stage
spec:
  type: NodePort
  selector:
    app: postgresql-db
  ports:
  - name: for-postgresql 
    port: 5432
    targetPort: 5432
```
Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.1/png/1.PNG?raw=true)

Проверка доступности контейнеров (кластер равзвертывал в Яндекс облаке):

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.1/png/2.PNG?raw=true)

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.1/png/3.PNG?raw=true)


# Задание 2: подготовить конфиг для production окружения

Конфиг front приложения:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: front
  labels:
    app: front
  namespace: production 
spec:
  selector:
    matchLabels:
      app: front
  replicas: 1
  template:
    metadata:
      labels:
        app: front
    spec:
      containers:
        - name: front
          image: nginx
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-nginx
              containerPort: 80
          env:
            - name: BASE_URL
              value: "http://localhost:8080"

---
apiVersion: v1
kind: Service
metadata:
  name: front
  namespace: production 
spec:
  type: NodePort
  selector:
    app: front
  ports:
  - name: for-nginx
    protocol: TCP
    port: 80
    targetPort: 80
```

Конфиг back приложения:
```
apiVersion: v1
kind: Namespace
metadata:
  name: production 

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
  namespace: production 
spec:
  selector:
    matchLabels:
      app: back
  replicas: 1
  template:
    metadata:
      labels:
        app: back
    spec:
      containers:
        - name: back
          image: tomcat:8.5.38
          imagePullPolicy: IfNotPresent
          ports:
            - name: for-tomcat
              containerPort: 8080
          env:
            - name: DATABASE_URL
              value: "postgres://postgres:postgres@db:5432/test"

---
apiVersion: v1
kind: Service
metadata:
  name: back
  namespace: production 
spec:
  type: NodePort
  selector:
    app: back
  ports:
  - name: for-tomcat
    protocol: TCP
    port: 8080
    targetPort: 8080
```

Дб через statefulset:

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgresql-db
  namespace: production
spec:
  serviceName: postgresql-db-service
  selector:
    matchLabels:
      app: postgresql-db
  replicas: 1
  template:
    metadata:
      labels:
        app: postgresql-db
    spec:
      containers:
        - name: postgresql-db
          image: postgres
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: postgresql-db-disk
              mountPath: /data
          env:
            - name: POSTGRES_PASSWORD
              value: "postgres"
            - name: PGDATA
              value: /data/pgdata
            - name: POSTGRES_USER
              value: "postgres"
            - name: POSTGRES_DB
              value: "test"

  volumeClaimTemplates:
    - metadata:
        name: postgresql-db-disk
      spec:
        storageClassName: "nfs"
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi

---
apiVersion: v1
kind: Service
metadata:
  name: postgres-db-service
  namespace: production
spec:
  type: NodePort
  selector:
    app: postgresql-db
  ports:
  - name: for-postgresql 
    port: 5432
    targetPort: 5432
```

Проверка:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.1/png/4.PNG?raw=true)
