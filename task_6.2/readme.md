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

