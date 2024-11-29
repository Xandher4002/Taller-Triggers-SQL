/*
	CREATE TRIGGER nombre{BEFORE|AFTER} {UPDATE|DELETE} ON nombre_tabla
		FOR EACH ROW
			BEGIN
            END;
hola
*/

DROP DATABASE IF EXISTS tecSucre;
CREATE DATABASE tecSucre;
USE tecSucre;

-- CREAMOS LA TABLA CLIENTE
	CREATE TABLE IF NOT EXISTS cliente(
		id INT NOT NULL AUTO_INCREMENT,
		nombre VARCHAR(50),
		apellido VARCHAR(50),
		seccion VARCHAR(60),
		PRIMARY KEY(id),
		KEY(nombre)
	) ENGINE=INNODB;

-- INSERTAMOS REGISTROS
	INSERT INTO cliente(nombre, apellido, seccion) VALUES
		('José', 'Pérez', 'Base de datos'),
		('Luisa', 'Gonzales', 'Informática'),
		('Pedro', 'Pérez', 'Dasarrollo Web'),
		('Carla', 'Gutierrez', 'Sistemas'),
		('Albert', 'Mendez', 'Redes');

-- VISUALIZAMOS
	SELECT * FROM cliente;
    
-- CREAMOS LA TABLA AUDITORÍA
	CREATE TABLE IF NOT EXISTS auditoria_cliente(
		id INT NOT NULL AUTO_INCREMENT,
        nombre VARCHAR(50),
        apellido VARCHAR(50),
        anterior_seccion VARCHAR(60),
        usuario VARCHAR(40),
        modificado DATETIME,
        PRIMARY KEY(id)
    ) ENGINE=INNODB;
    
-- DISPARADOR DE ACTUALIZACIÓN
	CREATE TRIGGER T1_AUP AFTER UPDATE ON cliente
		FOR EACH ROW
			INSERT INTO auditoria_cliente(nombre, apellido, anterior_seccion, usuario, modificado)
			VALUES (OLD.nombre, OLD.apellido, OLD.seccion, CURRENT_USER(), NOW());
        
-- VERIFICAMOS QUE FUNCIONE
	UPDATE cliente SET seccion = 'Telecomunicaciones' WHERE id = 4;
    SELECT * FROM cliente;
    SELECT * FROM auditoria_cliente;
    
    
-- CREAMOS OTRA TABLA DE AUDITORÍA PARA VER CÓMO FUNCIONA, PORQUE REALMENTE CON UNA ES SUFICIENTE
	CREATE TABLE auditoria_clienteI(
		id INT NOT NULL AUTO_INCREMENT,
        usuario VARCHAR(30),
        modificado DATETIME,
        id_cliente INT(4),
        PRIMARY KEY(id)
    ) ENGINE=INNODB;

-- DISPARADOR DE ACTUALIZACIÓN
	CREATE TRIGGER T2_AINS AFTER INSERT ON cliente
		FOR EACH ROW
			INSERT INTO auditoria_clienteI(usuario, modificado, id_cliente) VALUES (CURRENT_USER(), NOW(), NEW.ID);

-- VERIFICAMOS QUE FUNCIONE            
	INSERT INTO cliente(nombre, apellido, seccion) VALUES ('Marcos', 'Martinez', 'Electrónica');
	SELECT * FROM cliente;
	SELECT * FROM auditoria_clienteI;

	INSERT INTO cliente(nombre, apellido, seccion) VALUES
			('Elimar', 'Pérez', 'Base de datos'),
			('Elias', 'Gonzales', 'Informática'),
			('Carlos', 'Pérez', 'Dasarrollo Web'),
			('Julian', 'Gutierrez', 'Sistemas'),
			('Alfonso', 'Mendez', 'Redes');
	SELECT * FROM cliente;
   	SELECT * FROM auditoria_clienteI;
    
-- CREAMOS OTRA TABLA DE AUDITORÍA PARA VER CÓMO FUNCIONA, PORQUE REALMENTE CON UNA ES SUFICIENTE
	CREATE TABLE IF NOT EXISTS auditoria_clienteD(
		id INT NOT NULL AUTO_INCREMENT,
        nombre_d VARCHAR(50),
        apellido_d VARCHAR(50),
        seccion_d VARCHAR(40),
        id_d INT,
        usuario VARCHAR(30),
        fecha_d DATETIME,
        PRIMARY KEY(id)
    ) ENGINE=INNODB;
    
-- DISPARADOR DE BORRADO DE DATOS
	CREATE TRIGGER T3_ADEL AFTER DELETE ON CLIENTE
		FOR EACH ROW
			INSERT INTO auditoria_clienteD(nombre_d, apellido_d, seccion_d, id_d, usuario, fecha_d)
            VALUES(OLD.nombre, OLD.apellido, OLD.seccion, OLD.id, CURRENT_USER(), NOW());
            
-- VERIFICAMOS QUE FUNCIONE            
	DELETE FROM cliente WHERE id=4;
    SELECT * FROM auditoria_clienteD;
    SELECT * FROM cliente;

-- CREAMOS OTRA TABLA DE AUDITORÍA PARA VER CÓMO FUNCIONA, PORQUE REALMENTE CON UNA ES SUFICIENTE
	CREATE TABLE IF NOT EXISTS auditoria_clienteU(
		id INT NOT NULL AUTO_INCREMENT,
        nombre_nuevo VARCHAR(50),
        apellido_nuevo VARCHAR(50),
        seccion_nueva VARCHAR(60),
        usuario VARCHAR(30),
        fecha_modificado DATETIME,
        id_actual INT(4),
        PRIMARY KEY(id)
    ) ENGINE=INNODB;
    
-- DISPARADOR DE ACTUALIZACIÓN ANTES 
	CREATE TRIGGER T4_BUPT BEFORE UPDATE ON cliente
		FOR EACH ROW
			INSERT INTO auditoria_clienteU(nombre_nuevo, apellido_nuevo, seccion_nueva, usuario, fecha_modificado, id_actual)
            VALUES(NEW.nombre, NEW.apellido, NEW.seccion, CURRENT_USER(), NOW(), NEW.id);
            
-- VERIFICAMOS QUE FUNCIONE
    UPDATE cliente SET seccion = 'Telecomunicaciones' WHERE id = 7;
    SELECT * FROM cliente;
    SELECT * FROM auditoria_clienteU;
