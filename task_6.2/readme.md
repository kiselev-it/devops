## Задача 1
```sh
version: '3.1'

volumes:
  data:
  dump:

services:
  pg_db:
    image: postgres
    restart: always
    volumes:
      - data:/home/work/sql/data
      - dump:/home/work/sql/dump
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: test_db
```

## Задача 2
итоговый список БД после выполнения пунктов выше
```sh
                           List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 postgres  | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
           |       |          |            |            | root=CTc/root
 template1 | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
           |       |          |            |            | root=CTc/root
 test_db   | root  | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

```
описание таблиц (describe)
```sh
      List of relations
 Schema |  Name   | Type  | Owner 
--------+---------+-------+-------
 public | clients | table | root
 public | orders  | table | root
(2 rows)
```
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```sh
select * from pg_shadow;
```
список пользователей с правами над таблицами test_db
```sh
                                       List of roles
    Role name     |                         Attributes                         | Memb
er of 
------------------+------------------------------------------------------------+-----
------
 root             | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test_admin_user  |                                                            | {}
 test_simple_user |                                                            | {}
```
## Задача 3
Инсерты  в таблицы:
```sh
insert into orders (наименование, цена) values ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000);
```
```sh
insert into clients (фамилия, страна) values ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia');
```
вычислите количество записей для каждой таблицы
orders
```sh
select count(*) from orders;
```
```sh
 count 
-------
     5
(1 row)
```
clients
```sh
select count(*) from clients;
```
```sh
 count 
-------
     5
(1 row)
```
## Задача 4
Приведите SQL-запросы для выполнения данных операций.
```sh
UPDATE clients SET заказ = 3 WHERE фамилия = 'Иванов Иван Иванович';
UPDATE clients SET заказ = 4 WHERE фамилия = 'Петров Петр Петрович';
UPDATE clients SET заказ = 5 where фамилия = 'Иоганн Себастьян Бах';
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```sh
select clients.фамилия, orders.наименование from clients
join orders on orders.id = clients.заказ;
```
```sh
      фамилия        | наименование 
----------------------+--------------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
```
## Задача 5
```sh
QUERY PLAN                               
-----------------------------------------------------------------------
 Hash Join  (cost=21.93..35.72 rows=300 width=236)
   Hash Cond: (clients."заказ" = orders.id)
   ->  Seq Scan on clients  (cost=0.00..13.00 rows=300 width=122)
   ->  Hash  (cost=15.30..15.30 rows=530 width=122)
         ->  Seq Scan on orders  (cost=0.00..15.30 rows=530 width=122)
(5 rows)
```
cost - приблизительное время запуска + приблизительное время выполнения  
rows - число записей, обработанных для получения выходных данных  
width - средний размер строк в байтах

## Задача 6
```sh
pg_dump test_db > /dump/first.dump
```










