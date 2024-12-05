# Usa una imagen base de Debian para instalar Apache y Perl
FROM debian:latest

# Instala Apache, Perl y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crear directorios para HTML y CGI
RUN mkdir -p /var/www/html && mkdir -p /usr/lib/cgi-bin

# Dar permisos a los directorios necesarios
RUN chmod -R 755 /var/www/html && chmod +x /usr/lib/cgi-bin

# Copiar archivos HTML y CSS al directorio del servidor web
COPY ./html/ /var/www/html/
COPY ./css/ /var/www/html/css/

# Copiar scripts CGI al directorio CGI
COPY ./cgi-bin/ /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*

# Copiar archivo de configuración de Apache
COPY ./config/000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
