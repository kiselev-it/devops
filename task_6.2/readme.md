## Задача 1
sh```
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
