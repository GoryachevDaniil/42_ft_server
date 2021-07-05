# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mturquin <mturquin@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/12/19 17:12:12 by mturquin          #+#    #+#              #
#    Updated: 2021/04/27 13:35:25 by mturquin         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
MAINTAINER MTURQUIN

#Install soft
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install nginx wget vim mariadb-server php7.3-fpm php7.3-mysql

#Install phpMyAdmin & Wordpress
WORKDIR ./var/www/html/
RUN wget https://ru.wordpress.org/latest-ru_RU.tar.gz
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-all-languages.tar.gz
RUN tar xvzf latest-ru_RU.tar.gz && tar xvzf phpMyAdmin-4.9.7-all-languages.tar.gz
RUN rm -rf *.tar.gz
RUN mv phpMyAdmin-4.9.7-all-languages phpmyadmin

#Copy configs
COPY ./srcs/config.inc.php ./phpmyadmin/
COPY ./srcs/wp-config.php ./wordpress/
WORKDIR ../../../../
COPY ./srcs/default /etc/nginx/sites-available/default
COPY ./srcs/sborka.sh ./

#Ports
EXPOSE 80 443

#Make ssl keys for ngnx
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes \
	-out /etc/nginx/ssl/ft_server.crt \
	-keyout /etc/nginx/ssl/ft_server.key \
	-subj "/C=RF/ST=RUSSIA/L=Russia/O=21 School/OU=mturquin/CN=ft_server"

CMD bash sborka.sh
