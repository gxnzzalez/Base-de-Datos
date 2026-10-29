show grants for 'soporte'@'localhost';

CREATE USER 'soporte'@'localhost' IDENTIFIED BY 'soporte';

GRANT SELECT ON tienda_informatica.articulos TO 'soporte'@'localhost';

GRANT SELECT, INSERT, UPDATE ON tienda_informatica.* TO 'soporte'@'localhost';

REVOKE UPDATE ON tienda_informatica.articulos FROM 'soporte'@'localhost';

DROP USER IF EXISTS 'soporte'@'localhost';