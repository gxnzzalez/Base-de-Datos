-- PRÁCTICA 1 - Creacion de bbdd y Consultas 

-- Parte 1 - Script

DROP DATABASE IF EXISTS Tienda_de_informatica_y_reparaciones;
CREATE DATABASE Tienda_de_informatica_y_reparaciones;

USE Tienda_de_informatica_y_reparaciones;


CREATE TABLE fabricantes (
    id INT PRIMARY KEY,
    nombre VARCHAR(20) UNIQUE NOT NULL,
    pais VARCHAR(30)
);


CREATE TABLE articulos (
    id INT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL,
    precio DECIMAL(7,2) NOT NULL,
    fabricante_id INT,
    FOREIGN KEY (fabricante_id) REFERENCES fabricantes(id)
    );


CREATE TABLE tecnicos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especialidad VARCHAR(50),
    salario DECIMAL(8,2) NOT NULL
    );


    CREATE TABLE reparaciones (
        id INT PRIMARY KEY,
        descripcion_averia VARCHAR(100) NOT NULL,
        coste_reparacion DECIMAL(8,3),
        tecnico_id INT,
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
        );


USE Tienda_de_informatica_y_reparaciones;


INSERT INTO fabricantes (id, nombre, pais)
VALUES
    (1, 'Kingston', 'Estados Unidos'),
    (2, 'Asus', 'Taiwan'),
    (3, 'Samsung', 'Corea del Sur'),
    (4, 'Logitech', 'Suiza'),
    (5, 'Intel', 'Estados Unidos');

INSERT INTO articulos (id, nombre, precio, fabricante_id)
VALUES
    (1, 'Memoria RAM 16GB DDR4', 45.50, 1),
    (2, 'SSD NVMe 1TB', 79.99, 1),
    (3, 'Placa Base ROG Strix', 185.00, 2),
    (4, 'Monitor 27" IPS 144Hz', 249.00, 2),
    (5, 'Monitor 32" Curved', 320.00, 3),
    (6, 'Ratón Óptico Inalámbrico', 29.99, 4),
    (7, 'Teclado Mecánico RGB', 89.90, 4),
    (8, 'Procesador Core i7', 310.00, 5);


INSERT INTO tecnicos (id, nombre, especialidad, salario)
VALUES
    (1, 'Carlos Pérez', 'Hardware', 1800.00),
    (2, 'Ana Gómez', 'Redes y Servidores', 2100.00),
    (3, 'Luis Martinez', 'Portátiles', 1650.00),
    (4, 'Marta Ruiz', 'Movilidad y Tablets', 1750.00);

INSERT INTO reparaciones (id, descripcion_averia, coste_reparacion, tecnico_id)
VALUES
    (1, 'Sustitución de pantalla rota', 120.50, 3),
    (2, 'Cambio de fuente de
alimentación', 65.00, 1),
    (3, 'Recuperación de datos en disco
dañado', 150.00, 2),
    (4, 'Limpieza interna y cambio de
pasta térmica', 45, 1),
    (5, 'Sustitución de conector de carga', 50, 3),
    (6, 'Ampliación de RAM y formateo', 80, 4);

-- Parte 2 - Consultas

-- 1. Consulta 1: Muestra el nombre y el precio de todos los artículos ordenados de forma descendente por su precio.

SELECT nombre, precio
FROM articulos
order by precio DESC;


-- 2. Consulta 2: Muestra los nombres de los fabricantes cuyo país sea "Estados Unidos".

SELECT nombre
FROM fabricantes
WHERE pais = 'Estados Unidos'


-- 3. Consulta 3: Muestra todos los datos de aquellos artículos cuyo precio sea mayor o igual a 100 y menor o igual a 300.

SELECT * 
FROM articulos
WHERE precio > 100
AND precio <= 300



-- 4. Consulta 4: Calcula el precio medio de todos los artículos almacenados en la tabla articulos.

SELECT AVG(precio)
FROM articulos


-- 5. Consulta 5: Muestra el identificador del fabricante y el número de artículos que tiene cada uno.

SELECT fabricante_id, COUNT(*) AS numero_articulos
FROM articulos
GROUP BY fabricante_id



-- 6. Consulta 6: Muestra los tecnico_id que han realizado más de una reparación.

SELECT fabricante_id, COUNT(*) AS numero_articulos
FROM articulos
GROUP BY fabricante_id
HAVING COUNT(*) > 1


-- 7. Consulta 7: Muestra el nombre y el precio de los artículos fabricados por empresas de 'Taiwán' .

SELECT NOMBRE, PRECIO
FROM articulos
WHERE fabricante_id = (SELECT id
                       FROM fabricantes
                       WHERE pais = 'Taiwan')


-- 8. Consulta 8: Muestra la descripción y el coste de la reparación más cara registrada.

SELECT descripcion_averia, coste_reparacion
FROM reparaciones
ORDER BY coste_reparacion DESC
LIMIT 1



-- 9. Consulta 9: Muestra el nombre de los técnicos y el importe resultante de sumar a su salario actual un 10% de subida.

SELECT nombre, salario * 1.1 AS salario_10
FROM tecnicos


-- 10. Consulta 10: Muestra el nombre de los técnicos que no han realizado ninguna reparación.

SELECT nombre
FROM tecnicos
WHERE id NOT IN (SELECT tecnico_id
                FROM reparaciones)
