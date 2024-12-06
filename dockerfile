# Usa una imagen base de Debian para instalar Apache y Perl
FROM debian:latest

# Instala Apache, Perl y módulos necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2enmod cgi

# Crear directorio para HTML
RUN mkdir -p /var/www/html

# Dar permisos a la carpeta /var/www/html para copiar archivos
RUN chmod -R 755 /var/www/html

# Crea el directorio CGI y da permisos
RUN mkdir -p /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin

# Copia los scripts Perl en el directorio CGI
COPY cgi-bin/*.pl /usr/lib/cgi-bin/
RUN chmod +x /usr/lib/cgi-bin/*.pl

# Copia los archivos HTML, CSS, e imágenes
COPY html/ /var/www/html/
COPY css/ /var/www/html/css/
COPY images/ /var/www/html/images/

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
