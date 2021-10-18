# 1 Опишите основные плюсы и минусы pull и push систем мониторинга
Push-модель  
Плюсы: упрощение репликации данных и их резервные копии, гибкая настройка отправки метрик, менее затратное подключение по UDP.   
Минусы: Негорантированная доставка данных и их очередности (изза UDP)

Pull-модель  
Плюсы: легче контролировать подлинность данных, единый прокси до всех агентов с TLS, простота отладка получения данных с агентов.   
Минусы: использование агентов, отсутствие шифрования
# 2 Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?
- Prometheus - pull
- TICK - push
- Zabbix - push + pull
- VictoriaMetrics - push + pull
- Nagios - pull
# 3 Склонируйте себе репозиторий и запустите TICK-стэк, используя технологии docker и docker-compose
 curl http://localhost:8086/ping  
 ```sh

 ```
 curl http://localhost:8888
```sh
<!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.3dbae016.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.fab22342.js"></script> </body></html>
 ```
 curl http://localhost:9092/kapacitor/v1/ping
 ```sh

 ```
![alt text](https://github.com/kiselev-it/devops/blob/main/task_10.02/1.png?raw=true)

# 4 Перейдите в веб-интерфейс Chronograf (http://localhost:8888) и откройте вкладку Data explorer

![alt text](https://github.com/kiselev-it/devops/blob/main/task_10.02/2.png?raw=true)

# 5 Изучите список telegraf inputs. Добавьте в конфигурацию telegraf следующий плагин - docker

![alt text](https://github.com/kiselev-it/devops/blob/main/task_10.02/3.png?raw=true)