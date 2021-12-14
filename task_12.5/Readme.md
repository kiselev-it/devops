# Задание 1: установить в кластер CNI плагин Calico

1. Создал 3 виртуалки в Яндекс облаке и через кубспрей создла кластер:

```
all:
  hosts:
    master1:
      ansible_host: 62.84.113.170
      ip: 10.128.0.25
      access_ip: 10.128.0.25
    node1:
      ansible_host: 51.250.15.118
      ip: 10.128.0.14
      access_ip: 10.128.0.14
    node2:
      ansible_host: 62.84.116.77
      ip: 10.128.0.32
      access_ip: 10.128.0.32
  children:
    kube_control_plane:
      hosts:
        master1:
    kube_node:
      hosts:
        master1:
        node1:
        node2:
    etcd:
      hosts:
        master1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/1.PNG?raw=true)

2. Создал два deploymets И services (backend и frontend) из учебного репозитория. 

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/2.PNG?raw=true)

Проверил доступность курлом:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/3.PNG?raw=true)

3. Включаем запрещающую политику на вход сервисов frontend и backend:

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```
Проверка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/4.PNG?raw=true)

Как видно на оба сервиса курл теперь не проходит.

Теперь включил доступность сервиса frontend на вход:

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
    - Ingress
  ingress:
    - from:
      - podSelector:
          matchLabels:
            app: backend
      ports:
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443
```
![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/5.PNG?raw=true)

Как видно, теперь с сервиса backend можно "достучаться" до frontend. Но наоборот все еще нельзя, т.к. были открыты порты на вход только для frontend.

# Задание 2: изучить, что запущено по умолчанию

1. Получаем список нод - calicoctl get nodes

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/6.PNG?raw=true)

2. Получаем существующий пул адресов для подов - calicoctl get ipPool

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/7.PNG?raw=true)

3. calicoctl get profile

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.5/png/8.PNG?raw=true)