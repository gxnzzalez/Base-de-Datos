show grants for 'soporte'@'localhost';

CREATE USER 'soporte'@'localhost' IDENTIFIED BY 'soporte';

GRANT SELECT ON Tienda_de_informatica_y_reparaciones.articulos TO 'soporte'@'localhost';

GRANT SELECT, INSERT, UPDATE ON Tienda_de_informatica_y_reparaciones.* TO 'soporte'@'localhost';

REVOKE UPDATE ON Tienda_de_informatica_y_reparaciones.articulos FROM 'soporte'@'localhost';

DROP USER IF EXISTS 'soporte'@'localhost';