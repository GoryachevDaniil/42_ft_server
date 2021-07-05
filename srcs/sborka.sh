#!/bin/bash

#Start servises
service nginx start
service php7.3-fpm start
service mysql start

#Make MySQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

sleep 10000 #Для работы в фоне без флагов
#bash       #Для работы через флаги 
