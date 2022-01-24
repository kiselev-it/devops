# Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

### Как создать секрет?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/1.PNG?raw=true)

### Как просмотреть список секретов?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/2.PNG?raw=true)

### Как просмотреть секрет?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/3.PNG?raw=true)

### Как получить информацию в формате YAML и/или JSON?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/4.PNG?raw=true)

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/5.PNG?raw=true)

### Как выгрузить секрет и сохранить его в файл?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/6.PNG?raw=true)

### Как удалить секрет?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/7.PNG?raw=true)

### Как загрузить секрет из файла?

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/8.PNG?raw=true)

# Задача 2 (*): Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность как в виде переменных окружения, так и в виде примонтированного тома:  

манифест секрета:

```
apiVersion: v1
kind: Secret
metadata:
  name: test-secret
type: Opaque
stringData:
  username: admin
  password: pass
```

Манифест пода:

```
apiVersion: v1
kind: Pod
metadata: 
  name: test-pod-secret
spec:
  containers:
    - name: test-container
      image: nginx
      command: ["/bin/sh", "-c", "env"]
      envFrom:
        - secretRef: 
            name: test-secret
```

Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/9.PNG?raw=true)


Манифест пода с томом:

```
apiVersion: v1
kind: Pod
metadata: 
  name: test-pod-secret
spec:
  containers:
    - name: test-container
      image: nginx
      volumeMounts:
        - name: volume
          mountPath: "/etc/volume"
          readOnly: true
          
  volumes:
    - name: volume
      secret:
        secretName: test-secret
```
Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.1/png/10.PNG?raw=true)

