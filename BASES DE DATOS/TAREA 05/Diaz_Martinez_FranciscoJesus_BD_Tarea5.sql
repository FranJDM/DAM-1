-- APARTADO B: Utilizando sentencias SQL en la herramienta MySQL Workbench, debes realizar las siguientes operaciones indicando la sentencia que ejecutarías para realizar cada uno de los subapartados:
-- 1.- Insertar los siguientes datos en la tabla CITA teniendo en cuenta que debes insertar sólo los valores necesarios en los campos correspondientes.
-- 1.A

INSERT INTO cita VALUES('00008', '78036851V', 'no', '00:45', '2023-01-27', '20:15', null);

-- 1.B

UPDATE CITA 
SET duracion =null, fecha= '2023-01-29', hora='16:00',precio='20.60'
where numero_fisio = '00006' 
AND DNI_cliente = '27569874M';

-- 1.C

INSERT INTO cita VALUES('00003','73256987D',null,'01:00','2023-02-02','12:00','40');

-- 2.- Incrementar un 15% el precio de todos los productos que sean vendajes (da igual el tipo de vendaje). (Debes hacerlo con una única sentencia).

UPDATE productos
SET precio = precio * 1.15
WHERE nombre LIKE 'VENDAJES%';

-- 3.- Eliminar las citas cuyo precio sea menor de 25 y estén asignadas a fisioterapeutas que no estén trabajando actualmente. (Debes hacerlo con una única sentencia).
-- (Personalmente en este apartado, interpreto que solo se atañe a los que estan contratados actualmente, y por ello
-- no tengo en cuenta a los que su estado es 'Despedidos' para la clausula WHERE)

DELETE FROM CITA 
WHERE precio < 25
AND numero_fisio IN (
    SELECT numero_trabajador
    FROM profesionales
    WHERE estado NOT IN ('TRABAJANDO')
);

-- 4.- Incrementa en 5 unidades el descuento de los clientes que han tenido 3 o más citas en 2022, siempre y cuando no tengan ya un descuento superior a 60. (Debes hacerlo con una única sentencia).
-- He hecho un SELECT para identificar a los usuarios que se van a ver afectados por las condiciones impuestas.
-- En teoría debería de mostrar la información del cliente que es beneficiario del descuento junto a la acumulación de sus citas.

SELECT c.DNI_cliente, cl.nombre, cl.apellidos, COUNT(*) AS 'Cantidad de citas'
FROM cita c
JOIN cliente cl ON c.DNI_cliente = cl.DNI
WHERE YEAR(c.fecha) = 2022
GROUP BY c.DNI_cliente, cl.nombre, cl.apellidos
HAVING COUNT(DNI_cliente) >= 3;

-- Una vez realizada la comprobación, procedemos a actualizar el descuento.

UPDATE cliente
SET descuento = descuento + 5
WHERE descuento <= 60 and DNI IN (
    SELECT DNI_cliente
    FROM cita
    GROUP BY DNI_cliente,fecha
    AND YEAR(fecha) in ('2022')
    HAVING COUNT(DNI_cliente) >= 3
) ;

-- 5.- Insertar todos los profesionales que estén en estado ‘Despedido’ en la tabla PROFESIONALES_BAJA, incluyendo además de los campos propios de la tabla PROFESIONALES, la duración de su jornada laboral. (Debes hacerlo con una única sentencia).

INSERT INTO PROFESIONALES_BAJA (numero_trabajador, DNI, especialidad, nombre, apellidos, telefono, estado, hora_inicio, hora_fin, duracion_jornada)
SELECT numero_trabajador, DNI, especialidad, nombre, apellidos, telefono, estado, hora_inicio, hora_fin, TIMEDIFF(hora_fin, hora_inicio) as duracion_jornada
FROM PROFESIONALES
WHERE estado = 'Despedido';

-- 6.- Decrementar un año de experiencia a los profesores de pilates que han impartido menos de 3 clases en el último año (Debes hacerlo con una única sentencia).

UPDATE profesor_pilates
SET anos_experiencia = anos_experiencia - 1
WHERE numero_trabajador_pilates IN (
    SELECT numero_trabajador_pilates
    FROM imparte
    WHERE fecha >= DATE_SUB(NOW(), INTERVAL 365 DAY)
    GROUP BY numero_trabajador_pilates
    HAVING COUNT(*) < 3
);

-- 7.- Insertar en la tabla RANKING_PRODUCTOS por cada producto, su código, su nombre y la cantidad total pedida, siempre y cuando se hayan vendido más de 15 unidades del producto. (Debes hacerlo con una única sentencia).

INSERT INTO ranking_productos (codigo, nombre, total)
SELECT v.id_producto AS codigo, p.nombre AS nombre, SUM(v.cantidad) AS total
FROM venden v
JOIN productos p ON v.id_producto = p.id
GROUP BY v.id_producto, p.nombre
HAVING SUM(v.cantidad) > 15;

-- 8.- Bloquear la tabla profesionales en modo lectura y la tabla cliente en modo escritura, seguidamente intenta actualizar el nombre del profesional con dni 56948768S por Jose. Luego, actualiza el nombre del cliente con dni 27256987J por Antonia. Muestra capturas del resultado de las distintas sentencias, explicando los resultados obtenidos.
LOCK TABLES profesionales READ;

UPDATE profesionales SET nombre = 'Jose' WHERE dni = '56948768S';


LOCK TABLES cliente WRITE;

UPDATE cliente SET nombre = 'Antonia' WHERE dni = '27256987J';

-- 9.- Inicia una transacción. Elimina todos los profesionales que su estado sea ‘despedido’. Deshacer la transacción y comprobar que los registros no han sido eliminados.

START TRANSACTION;
DELETE FROM profesionales WHERE estado = 'despedido';
ROLLBACK;



