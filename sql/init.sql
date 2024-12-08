--SOLO TABLA DE LIBROS
-- Crear usuario y asignar privilegios
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON biblioteca.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;

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
    precio INT(12) NOT NULL,
    stock INT(12) NOT NULL
);


-- Insertar datos iniciales
INSERT INTO libros (tienda_id, nombre, descripcion, imagen, precio, stock) VALUES
(1, 'Antes de diciembre', 'Una novela romántica contemporánea.', 'Antes_de_diciembre.jpg', 5000, 20),
(1, 'Bravazo', 'Una colección de recetas modernas.', 'Bravazo.jpg', 4000, 15),
(2, 'Clean Code', 'Una guía para escribir código limpio.', 'Clean_Code.jpg', 6000, 10),
(2, 'Hábitos Atómicos', 'Cómo construir hábitos que cambien tu vida.', 'Habitos_Atomicos.webp', 4500, 25),
(3, 'No Me Puedes Lastimar', 'Una historia inspiradora de superación personal.', 'NO_ME_PUEDES_LASTIMAR.webp', 5500, 12),
(3, 'Psicología Oscura', 'Una exploración de la mente humana.', 'PSICOLOGIA_OSCURA.jpg', 5000, 18),
(4, 'Química Lumbreras', 'Guía práctica para estudiantes de química.', 'Quimica_Lumbreras.webp', 4000, 30),
(4, 'Romper el Círculo', 'Una novela sobre el amor y las segundas oportunidades.', 'ROMPER_EL_CIRCULO.webp', 4700, 22),
(5, 'The Notebook', 'Un clásico romántico lleno de emociones.', 'The_Notebook.jpg', 5200, 16),
(5, 'Padre Rico Padre Pobre', 'Lecciones sobre finanzas personales.', 'Padre_Rico_Padre_Pobre.jpg', 4800, 20);
