-- Tabla para Inventario
CREATE TABLE inventario (
    inventario_id INT(12) AUTO_INCREMENT PRIMARY KEY,
    tienda_id INT(12) NOT NULL,
    libro_id INT(12) NOT NULL,
    stock INT(12) NULL,
    FOREIGN KEY (tienda_id) REFERENCES tienda(id),
    FOREIGN KEY (libro_id) REFERENCES libros(id)
);

-- Insertar datos iniciales en Inventario
INSERT INTO inventario (tienda_id, libro_id, stock) VALUES
(1, 1, 20), -- Tienda1, Antes de diciembre
(1, 2, 15), -- Tienda1, Bravazo
(1, 3, 10), -- Tienda1, Clean Code
(2, 4, 25), -- Tienda2, Hábitos Atómicos
(2, 5, 12), -- Tienda2, No Me Puedes Lastimar
(2, 6, 18), -- Tienda2, Psicología Oscura
(1, 7, 30), -- Tienda1, Química Lumbreras
(2, 8, 22), -- Tienda2, Romper el Círculo
(1, 9, 16), -- Tienda1, The Notebook
(2, 10, 20); -- Tienda2, Padre Rico Padre Pobre
