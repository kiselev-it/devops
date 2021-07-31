## Задача 1
```sh
mysql  Ver 8.0.26 for Linux on x86_64 (MySQL Community Server - GPL)
```
```sh
mysql> show tables;
+----------------+
| Tables_in_test |
+----------------+
| orders         |
+----------------+
1 row in set (0.00 sec)
```
```sh
mysql> select count(*) from orders where price>300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```
## Задача 2
```sh
alter user 'test'@'localhost' PASSWORD EXPIRE INTERVAL 180 DAY;
alter user 'test'@'localhost' with MAX_QUERIES_PER_HOUR 100;
alter user 'test'@'localhost' with MAX_USER_CONNECTIONS 3;
```
```sh
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES;
+------------------+-----------+-----------+
| USER             | HOST      | ATTRIBUTE |
+------------------+-----------+-----------+
| root             | %         | NULL      |
| test             | %         | NULL      |
| mysql.infoschema | localhost | NULL      |
| mysql.session    | localhost | NULL      |
| mysql.sys        | localhost | NULL      |
| root             | localhost | NULL      |
| test             | localhost | NULL      |
+------------------+-----------+-----------+
7 rows in set (0.00 sec)
```
## Задача 3
```sh
mysql> show create table orders;
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                                              |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| orders | CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```
```sh
mysql> show create table orders;
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table  | Create Table                                                                                                                                                                                                                              |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| orders | CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci |
+--------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```
```sh
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------+
| Query_ID | Duration   | Query                                  |
+----------+------------+----------------------------------------+
|        1 | 0.00033000 | show create table orders               |
|        2 | 0.00012400 | SET profiling = 1                      |
|        3 | 0.01451275 | alter table orders engine=MyISAM       |
|        4 | 0.00016000 | show create table orders               |
+----------+------------+----------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```
## Задача 4
```sh
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
innodb_buffer_pool_size = 1G
innodb_log_file_size = 512M
innodb_log_buffer_size = 1M
innodb_log_buffer_size = 100M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
max_binlog_size = 100M
ROW_FORMAT = COMPRESSED

```


