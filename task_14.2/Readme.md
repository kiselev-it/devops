# Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в яндекс облаке:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/11.PNG?raw=true)

Получить значение внутреннего IP пода:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/12.PNG?raw=true)

Запустить второй модуль для использования в качестве клиента и установил доп пакеты (`dnf -y install`, `pip
pip install hvac`)  
Запускаю скрипт, но ничего не происходит! Возможно из-за того, что делал не в миникубе, а в Яндекс облаке с двумя воркер нодами

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/13.PNG?raw=true)

Voult поднят. Я долго пытался решить проблему, но так и не понял что не так.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/14.PNG?raw=true)

# Задание по репозиторию

Создал ресурсу из манифестов https://gitlab.com/k11s-os/k8s-lessons/-/tree/main/Vault/manifests :

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/1.PNG?raw=true)

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/2.PNG?raw=true)


Установил бинарь Vault, экспортировал переменные VAULT_ADDR и VAULT_TOKEN. Затем добавил секретные данные:

Но сначал добавил kv хранилище secrets через UI. Т.к. если этого не сделать, то будет выйдет ошибка:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/3.PNG?raw=true)

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/4.PNG?raw=true)

Создал политику для роли:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/5.PNG?raw=true)

Создал роль:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/6.PNG?raw=true)

Получил RoleID:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/7.PNG?raw=true)

Далее запускаю ConfigMap и Deployment. И смотрю логи контейнера go-vault-approle:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/8.PNG?raw=true)

В Leases можно посмотреть сколько токенов было отдано приложению:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_14.2/png/9.PNG?raw=true)