--TABLA INICIAL PARA LIBROS
-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- Crear tabla de libros
CREATE TABLE libros (
    id INT(12) AUTO_INCREMENT PRIMARY KEY,
    tienda_id INT(12) NOT NULL,
    nombre VARCHAR(32) NOT NULL,
    descripcion VARCHAR(64),
    imagen VARCHAR(32),
    precio DECIMAL(10,2) NOT NULL,
    stock INT(12) NOT NULL
);

-- Insertar datos iniciales
INSERT INTO libros (tienda_id, nombre, descripcion, imagen, precio, stock) VALUES
(1, 'Antes de diciembre', 'Una novela romantica contemporanea.', 'Antes_de_diciembre.jpg', 50.00, 20),
(1, 'Bravazo', 'Una coleccion de recetas modernas.', 'Bravazo.jpg', 40.00, 15),
(2, 'Clean Code', 'Una guia para escribir codigo limpio.', 'Clean_Code.jpg', 60.00, 10),
(2, 'Habitos Atomicos', 'Como construir habitos que cambien tu vida.', 'Habitos_Atomicos.webp', 45.00, 25),
(3, 'No Me Puedes Lastimar', 'Una historia inspiradora de superacion personal.', 'NO_ME_PUEDES_LASTIMAR.webp', 55.00, 12),
(3, 'Psicologia Oscura', 'Una exploracion de la mente humana.', 'PSICOLOGIA_OSCURA.jpg', 50.00, 18),
(4, 'Quimica Lumbreras', 'Guia practica para estudiantes de quimica.', 'Quimica_Lumbreras.webp', 40.00, 30),
(4, 'Romper el Circulo', 'Una novela sobre el amor y las segundas oportunidades.', 'ROMPER_EL_CIRCULO.webp', 47.00, 22),
(5, 'The Notebook', 'Un clasico romantico lleno de emociones.', 'The_Notebook.jpg', 52.00, 16),
(5, 'Padre Rico Padre Pobre', 'Lecciones sobre finanzas personales.', 'Padre_Rico_Padre_Pobre.jpg', 48.00, 20);
