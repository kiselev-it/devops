# Основная часть
1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте какое значение имеет факт some_fact для указанного хоста при выполнении playbook'a.  

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/1.PNG?raw=true)

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/2.PNG?raw=true)

3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/3.PNG?raw=true)

5. Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились следующие значения: для deb - 'deb default fact', для el - 'el default fact'.
6. Повторите запуск playbook на окружении prod.yml.   Убедитесь, что выдаются корректные значения для всех хостов.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/5.PNG?raw=true)

7. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/6.PNG?raw=true)

8. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/7.PNG?raw=true)
9. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.  
10. prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.  
11. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь что факты some_fact для каждого из хостов определены из верных group_vars.

![alt text](https://github.com/kiselev-it/devops/blob/main/task_08.01/8.PNG?raw=true)

12. Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.
