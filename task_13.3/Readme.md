# Задание 1: проверить работоспособность каждого компонента

Манифесты взяты из дз 13.1 (https://github.com/kiselev-it/devops/tree/main/task_13.1).  
Пробросил порты:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/1.PNG?raw=true)

front:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/2.PNG?raw=true)

back:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/3.PNG?raw=true)

Проверка через exec:  
ip подов:  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/4.PNG?raw=true)

C фронта на бэк:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/5.PNG?raw=true)

С бэка на фронт:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/6.PNG?raw=true)

Как на бед сделать запрос для проверки не знаю. Проверил просто работоспособность контейнера:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.3/png/7.PNG?raw=true)

# Задание 2: ручное масштабирование

Скеил до 3 реплик фронта и бэка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.5/png/8.PNG?raw=true)

Обратное сокразение до 1 реплик:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.5/png/9.PNG?raw=true)

На каких нодах оказались копии видно через : `kubectl --namespace=production get po -o wide`