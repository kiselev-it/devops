# Задание 1: Подготовить инвентарь kubespray
Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. Требования к инвентарю:

- подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды;
- в качестве CRI — containerd;
- запуск etcd производить на мастере.  

Сделал кластер из 1 мастер и 2 воркер нод на Яндекс облаке.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.4/png/1.PNG?raw=true)

Ноды:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.4/png/2.PNG?raw=true)

Для проверки создал деплой:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.4/png/3.PNG?raw=true)

в качестве CRI — containerd:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.4/png/4.PNG?raw=true)

Запуск etcd производить на мастере (в секции etcd: -> hosts: указываем только мастер ноду master1:):

```
all:
  hosts:
    master1:
      ansible_host: 51.250.7.240
      ip: 10.128.0.29
      access_ip: 10.128.0.29
    node1:
      ansible_host: 51.250.12.193
      ip: 10.128.0.4
      access_ip: 10.128.0.4
    node2:
      ansible_host: 51.250.15.191
      ip: 10.128.0.15
      access_ip: 10.128.0.15
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
