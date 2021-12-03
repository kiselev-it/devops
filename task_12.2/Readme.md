# Задание 1: Запуск пода из образа в деплойменте

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/1.PNG?raw=true)

# Задание 2: Просмотр логов для разработки

1. Создал namespace

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/2.PNG?raw=true)

2. Создание закрытого ключа для пользователя developer (Использую openssl через git bash на windows)

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/3.PNG?raw=true)

3. Создание запроса сертификата developer.crt 

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/4.PNG?raw=true)

4. Создан сертификат developer.crt, одобрив запрос на подпись сертификата developer.csr, сделанный ранее. Однобрение происходит своим центром сертификации кластера Kubernetes (В случае Minikube это будет ~/.minikube/)

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/5.PNG?raw=true)

5. Добавил пользователя с созданным ранне сертификатом. Добавил новый контекст с новыми учетными данными для minikube кластера Kubernetes. 

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/6.PNG?raw=true)

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/7.PNG?raw=true)

Теперь при попытке использовать kubectl с этим конфигурационным файлом мы будем получать отказ в доступе. Это ожидаемое поведение, поскольку мы не определили никаких разрешенных операций для только что созданного пользователя.

6. Созжад файл (также лежит в репозитории) developer_role.yaml для создания роли, описывающее правила, которые позволяют пользователю выполнять определенные действия.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_12.2/8.PNG?raw=true)

7. Установка связи пользователь-роль. Создал файл rolebinding-deploper.yaml (лежит в репозитории). В этом файле привязывается Role deploper к субъекту User Account developer внутри пространства имен app-namespace:

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/9.PNG?raw=true)

8. Тестирование политик RBAC

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/11.PNG?raw=true)

Т.е. ошибки с просмотром pods уже нет. Подов нет, так как не создавал в namespace app-namespace.
В дефолтном namespace видим ранее созданные два пода.
Проверяю возможность ппросмотра deployments и ожидаемо получаю ошибку (т.к. в рамках дх нужно было только дать доступ к русурсу под)

# Задание 3: Изменение количества реплик

![alt text](https://github.com/kiselev-it/devops/blob/main/png/task_12.2/12.PNG?raw=true)


