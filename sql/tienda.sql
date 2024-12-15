-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- Tabla para Tiendas
CREATE TABLE tienda (
    id INT(12) AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(32) NOT NULL,
    ruc VARCHAR(16) NOT NULL
);

-- Insertar datos iniciales en Tiendas
INSERT INTO tienda (nombre, ruc) VALUES
('Tienda1', '12345678901'),
('Tienda2', '98765432109');
