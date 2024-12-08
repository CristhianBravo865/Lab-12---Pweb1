--SOLO TABLA DE LIBROS
-- Crear usuario y asignar privilegios
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON biblioteca.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;


