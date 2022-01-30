#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><a href="https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg" allign=center>https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg</a><p allign=center><img src="https://storage.yandexcloud.net/test-bucket-kiselev/1.jpg"> </html>" > index.html