USE usuarios_info;

CREATE TABLE tarjeta (
    id INT AUTO_INCREMENT PRIMARY KEY,          -- Identificador único de la tarjeta
    numero VARCHAR(16) NOT NULL,                -- Número de la tarjeta (16 dígitos típicamente)
    tipo ENUM('Crédito', 'Débito') NOT NULL,    -- Tipo de tarjeta
    fecha_expiracion DATE NOT NULL,             -- Fecha de expiración
    cvv VARCHAR(4) NOT NULL,                    -- Código de seguridad
    usuario_id INT NOT NULL,                    -- Relación con el usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE 
);