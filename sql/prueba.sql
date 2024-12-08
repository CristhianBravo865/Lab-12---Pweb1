--
-- Ejemplo de insersión de datos de `tarjeta` y `usuario`
--

    --PRIMERO
-- TARJETAS:
INSERT INTO tarjeta (numero, caducidad, codigo, saldo)
VALUES ('1234-5678-9012-3456', '2024-12-31', 123, 1000);

INSERT INTO tarjeta (numero, caducidad, codigo, saldo)
VALUES ('9876-5432-1098-7654', '2024-12-30', 321, 1000);


    --SEGUNDO
-- USUARIOS:
INSERT INTO usuario (login_usuario, login_clave, nombreC, dni, celular, tipo_usuario, nombre_usuario, correo, tarjeta_id, pregunta1, pregunta2)
VALUES (
  'HernanCZU',
  '123456789',
  'Hernan Andy Choquehuanca Zapana',
  71647797,
  987654321,
  'usuario',
  'HernanCZ',
  'hchoquehuancaz@unsa.edu.pe',
  (SELECT id FROM tarjeta WHERE numero = '1234-5678-9012-3456'),
  'lia',
  'sol'
);

INSERT INTO usuario (login_usuario, login_clave, nombreC, dni, celular, nombre_usuario, correo, tarjeta_id, pregunta1, pregunta2)
VALUES (
  'BryanLRU',
  '12345',
  'Bryan Fernando Larico Rodriguez',
  87654321,
  912345678,
  'BryanLR',
  'blaricor@unsa.edu.pe',
  (SELECT id FROM tarjeta WHERE numero = '9876-5432-1098-7654'),
  'dog',
  'sch'
);

-- VENDEDORES:

INSERT INTO vendedor (login_usuario, login_clave, nombreC, dni, celular, tipo_usuario, nombre_usuario, correo, tarjeta_id, pregunta1, pregunta2)
VALUES (
  'HernanCZV',
  '123456789',
  'Hernan Andy Choquehuanca Zapana',
  71647797,
  987654321,
  'vendedor',
  'HernanCZ',
  'hchoquehuancaz@unsa.edu.pe',
  (SELECT id FROM tarjeta WHERE numero = '1234-5678-9012-3456'),
  'lia',
  'sol'
);
INSERT INTO vendedor (login_usuario, login_clave, nombreC, dni, celular, nombre_usuario, correo, tarjeta_id, pregunta1, pregunta2)
VALUES (
  'BryanLRV',
  '12345',
  'Bryan Fernando Larico Rodriguez',
  87654321,
  912345678,
  'BryanLR',
  'blaricor@unsa.edu.pe',
  (SELECT id FROM tarjeta WHERE numero = '9876-5432-1098-7654'),
  'dog',
  'sch'
);


    --TERCERO
-- PRODUCTO:

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Pepsi 500 mL',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/pepsi.jpg?raw=true',
    2.40,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Coca Cola 500ml',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/cocacola.jpg?raw=true',
    2.90, 
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Sprite 500ml',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/sprite.jpg?raw=true',
    2.50,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Inca Kola Sin Azucar 500ml',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/inkacola.jpg?raw=true',
    2.90,
    50
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Oreo Original 108g',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/oreo.jpg?raw=true',
    2.60,
    20
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Papas Nativas Inka Chips 135g',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/inka.jpg?raw=true',
    8.00,
    10
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'Chizitos Sabor Queso 190g',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/chizito.jpg?raw=true',
    6.90,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'Battimix Vainilla 146g',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/batimix.jpg?raw=true',
    4.60,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'Cono Frio Rico Choco Chips 130ml',+
    'https://github.com/Choflis/UNSASHOP/blob/main/img/friorico.jpg?raw=true',
    4.90,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'Tijeras Layconsa',+
    'https://github.com/Choflis/UNSASHOP/blob/main/img/tijeras.jpg?raw=true',
    4.90,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'Naranja',+
    'https://github.com/Choflis/UNSASHOP/blob/main/img/naranjas.jpg?raw=true',
    1.00,
    5
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'BryanLRV'),
    'hamburguesa de pollo',+
    'https://github.com/Choflis/UNSASHOP/blob/main/img/hamburguesas.jpg?raw=true',
    4.90,
    5
);
INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Gaseosas de china',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/gaseosas.jpg?raw=true',
    2.90,
    50
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Donas',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/donas.jpg?raw=true',
    2.90,
    50
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Cuadernos college',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/cuaderno.jpg?raw=true',
    2.90,
    50
);


INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Colores',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/colores.jpg?raw=true',
    2.90,
    50
);

INSERT INTO producto (vendedor_id, nombre, imagen, precio, stock)
VALUES (
    (SELECT id FROM vendedor WHERE login_usuario = 'HernanCZV'),
    'Calculadora',
    'https://github.com/Choflis/UNSASHOP/blob/main/img/calculadora.jpg?raw=true',
    2.90,
    50
);


