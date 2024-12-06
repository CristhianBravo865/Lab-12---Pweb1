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
CREATE TABLE IF NOT EXISTS libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    sucursal_id INT NOT NULL,
    nuevo TINYINT(1) NOT NULL
);

-- Insertar datos iniciales
INSERT INTO libros (nombre, descripcion, sucursal_id, nuevo) VALUES
('El Señor de los Anillos', 'Una novela épica de fantasía.', 1, 1),
('Cien Años de Soledad', 'Una obra maestra de Gabriel García Márquez.', 2, 0),
('1984', 'Una novela distópica de George Orwell.', 1, 1),
('El Principito', 'Un clásico de Antoine de Saint-Exupéry.', 3, 1),
('Don Quijote de la Mancha', 'Una obra de Miguel de Cervantes.', 2, 0);
