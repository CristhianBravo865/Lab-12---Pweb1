Mini Wikipedia

Descripción

Proyecto desarrollado para el curso Programación Web I, cuyo objetivo es crear una página web similar a Wikipedia.

Funcionalidades
Visualizar páginas en formato Markdown.
Crear, editar y eliminar páginas dinámicas.

Autores
Mark Hancco Vargas
Cristhian Bravo Arredondo






COMANDOS CONSTRUCCION DOCKER:

docker build -f Dockerfile.web -t server-web .
docker run -d -p 8112:80 --name server-web server-web


docker build -f .\Dockerfile.db -t biblioteca-db .
docker run -d --name biblioteca-db -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=biblioteca -p 3307:3306 biblioteca-db


Red:
docker network create biblioteca-network
docker network connect biblioteca-network server-web
docker network connect biblioteca-network biblioteca-db

Bash para ambos

docker exec -it biblioteca-db /bin/bash
