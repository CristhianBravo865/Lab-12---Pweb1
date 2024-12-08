CREATE DATABASE IF NOT EXISTS usuarios_info;
USE usuarios_info;

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    login_correo VARCHAR(255) NOT NULL, 
    login_clave VARCHAR(255) NOT NULL, 
    nombre VARCHAR(255) NOT NULL, 
    tarjeta_id BIGINT(16) NULL
);
