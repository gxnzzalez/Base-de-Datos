-- Batería de Consultas 1:
-- Para esta batería de preguntas está prohibido utilizar JOIN

-- 1. Muestra el nombre y el precio de aquellos artículos que sean, exactamente, elartículo más caro de su respectivo fabricante.

SELECT nombre, precio
FROM articulos a
WHERE precio = (
    SELECT MAX(precio)
    FROM articulos
    WHERE fabricante_id = a.fabricante_id)

-- 2. Muestra el nombre de los fabricantes que no tienen ningún artículo con un precio inferior o igual a la media general de precios de toda la tienda.

SELECT nombre
FROM fabricantes
WHERE id IN (SELECT fabricante_id
			FROM articulos
            WHERE precio > (SELECT AVG(precio)
							FROM articulos))

-- 3. Muestra la descripción y el coste de aquellas reparaciones cuyo coste sea estrictamente superior a la media de las reparaciones realizadas por su propio técnico.

SELECT descripcion_averia, coste_reparacion
FROM reparaciones r
WHERE coste_reparacion > (SELECT AVG(coste_reparacion) 
					        FROM reparaciones
                            WHERE r.tecnico_id=tecnico_id)

-- 4. Muestra el identificador y la especialidad de los técnicos cuya suma total del coste de las reparaciones que han realizado supere el doble de su propio salario.

SELECT id, especialidad, salario
FROM tecnicos
WHERE salario*2 < (SELECT SUM(coste_reparacion)
				FROM reparaciones
				ORDER BY tecnico_id)

-- 5. Muestra el nombre del fabricante (o fabricantes) que posee el mayor número de  artículos registrados en la base de datos.

                    
SELECT nombre
FROM fabricantes
WHERE id IN (SELECT fabricante_id
             FROM articulos
             GROUP BY fabricante_id
             HAVING COUNT(*) = (SELECT MAX(Articulitos)
                                FROM (SELECT COUNT(*) AS Articulitos
                                      FROM articulos
                                      GROUP BY fabricante_id) AS Articulos_totales))

-- 6. Muestra el nombre de los técnicos que han realizado alguna reparación, pero que nunca han realizado ninguna reparación cuyo coste haya superado los 100.00 euros.

SELECT nombre
FROM tecnicos
WHERE id NOT IN (SELECT tecnico_id
			FROM reparaciones
			WHERE coste_reparacion > 100.00)

-- 7. Muestra el nombre y el salario de los técnicos cuyo salario sea inferior a la media salarial de su propia especialidad.

SELECT nombre, salario
FROM tecnicos t
WHERE salario < (SELECT AVG(salario)
				FROM tecnicos
                 WHERE especialidad = t.especialidad)

-- 8. Muestra el nombre de los fabricantes cuyo país coincide con el país del fabricante que produce el artículo más caro de toda la tienda.

 SELECT nombre
 FROM fabricantes
 WHERE pais = (SELECT pais
			   FROM fabricantes
               WHERE id = (SELECT fabricante_id
							   FROM articulos
                               WHERE precio = (SELECT MAX(precio)
											   FROM articulos)))

-- 9. Muestra el nombre y el precio del artículo más barato de entre todos los fabricantes  que son originarios de 'Estados Unidos'.

SELECT nombre, precio
FROM articulos
WHERE precio = (SELECT MIN(precio)
				FROM articulos
                WHERE fabricante_id IN (SELECT id
									   FROM fabricantes
                                       WHERE LOWER(pais) = 'estados unidos'))

-- 10. Muestra el identificador del técnico (tecnico_id) que ha acumulado el mayor  coste total en reparaciones.

SELECT tecnico_id
FROM reparaciones
GROUP BY tecnico_id
HAVING SUM(coste_reparacion) = (SELECT MAX(total_coste)
								FROM (SELECT SUM(coste_reparacion) AS total_coste
									  FROM reparaciones
                                      GROUP BY tecnico_id) AS totales)

-- Batería de Consultas 2:
-- Para esta batería de preguntas está permitido utilizar JOIN y todo lo estudiado.


-- 1. Muestra el nombre de cada artículo junto con el nombre de su fabricante, pero únicamente para aquellos artículos cuyo precio sea superior a 100.00 euros.

SELECT a.nombre, f.nombre
FROM articulos a
JOIN fabricantes f ON a.fabricante_id = f.id
WHERE a.precio > 100;

-- 2. Muestra el nombre de todos los fabricantes de la base de datos y, al lado, el nombre de sus artículos. Asegúrate de que aparezcan los fabricantes que no tienen ningún artículo registrado.

SELECT f.nombre, a.nombre
FROM articulos a
RIGHT JOIN fabricantes f ON a.fabricante_id = f.id
ORDER BY f.nombre

-- 3. Muestra el nombre del fabricante y la media de los precios de sus artículos, pero solo para aquellos fabricantes cuya media de precios supere los 150.00 euros.

SELECT f.nombre, AVG(a.precio) AS precio_medio
FROM fabricantes f
JOIN articulos a ON a.fabricante_id = f.id
GROUP BY f.nombre
HAVING AVG(a.precio) > 150;


-- 4. Muestra la descripción de la avería, el coste de la reparación y el nombre del técnico que la ha llevado a cabo, ordenado por el coste de mayor a menor.

SELECT r.descripcion_averia, r.coste_reparacion, t.nombre
FROM reparaciones r 
JOIN tecnicos t ON t.id = r.tecnico_id
ORDER BY coste_reparacion DESC

-- 5. Muestra el nombre de aquellos técnicos que no han realizado ninguna reparación, utilizando obligatoriamente un cruce externo de tablas.

SELECT t.nombre
FROM tecnicos t
JOIN reparaciones r ON r.tecnico_id = t.id
WHERE t.id NOT IN (SELECT tecnico_id
				  FROM reparaciones)

-- 6. Muestra el nombre del técnico y la suma total del dinero recaudado con sus reparaciones, filtrando únicamente aquellos técnicos cuya recaudación total supere los 100.00 euros.

SELECT t.nombre, SUM(r.coste_reparacion) as suma_dinero
FROM tecnicos t
JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.nombre
HAVING SUM(r.coste_reparacion) > 100

-- 7. Muestra el nombre de los artículos y el nombre de su respectivo fabricante, pero filtrando exclusivamente aquellos artículos cuyos fabricantes sean originarios de 'Estados Unidos' o 'Taiwán' .

SELECT a.nombre, f.nombre
FROM articulos a
JOIN fabricantes f ON f.id = a.fabricante_id
WHERE LOWER(f.pais) = 'estados unidos'
OR 'taiwan'

-- 8. Muestra el nombre de todos los técnicos y, al lado, el número total de reparacionesque ha realizado cada uno de ellos.

SELECT t.nombre, COUNT(r.tecnico_id) as numero_reparaciones
FROM tecnicos t
LEFT JOIN reparaciones r ON t.id = r.tecnico_id
GROUP BY t.nombre, t.id
ORDER BY numero_reparaciones

-- 9. Muestra el nombre del fabricante y el número total de artículos que produce, pero solo de aquellos fabricantes que tengan un número de artículos mayor o igual a 2.

SELECT f.nombre, COUNT(a.id) as numero_articulos
FROM fabricantes f 
JOIN articulos a ON a.fabricante_id = f.id
GROUP BY f.nombre, f.id
HAVING numero_articulos >= 2

-- 10. Muestra el nombre del técnico, su especialidad y la descripción de la reparación más costosa que ha realizado cada uno de ellos

SELECT t.nombre, t.especialidad, MAX(r.coste_reparacion) as reparacion_mas_costosa
FROM tecnicos t 
JOIN reparaciones r ON r.tecnico_id = t.id
GROUP BY t.nombre, t.id, t.especialidad