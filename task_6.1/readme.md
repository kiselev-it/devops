# 6.1. Типы и структура СУБД
## 1 задание
-	Электронные чеки в json виде –
Документная база данных - база данных не предписывает опредёленный формат или схему. 
-	Склады и автомобильные дороги для логистической компании –
Графовая база данных – т.к. нет четкой структуры данных между складами и автомобильными дорогами
-	Генеалогические деревья – 
Сетевые базы данных - информация организована в виде древовидной структуры с отношениями «предок-потомок».
-	Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации – 
Базы данных временных рядов - ориентированы на запись; предназначены для обработки постоянного потока входных данных.
- Отношения клиент-покупка для интернет-магазина –
Реляционные БД – надежность, высокоорганизованная структура и гибкость.

## 2 задание
CAP-теорема
Данные записываются на все узлы с задержкой до часа (асинхронная запись) - AP.
При сетевых сбоях, система может разделиться на 2 раздельных кластера - AP.
Система может не прислать корректный ответ или сбросить соединение - CP.

PACELC-теорема
Данные записываются на все узлы с задержкой до часа (асинхронная запись) - PA/EL.
При сетевых сбоях, система может разделиться на 2 раздельных кластера – PA/EL.
Система может не прислать корректный ответ или сбросить соединение – CP/EC.

## 3 задание
Нет, т.к. данные принципы противоположны.

## 4 задание
Redice

Минусы - отсутствует контроль доступа; размер ограничен оперативной памятью; шардинг (техника масштабирования) ведет к увеличению задержки.
