-- 1.- Obtener un listado de todos los clientes.

SELECT Nombre, Apellidos
FROM cliente;

-- 2.- Obtener el nombre y stock de los productos que tengan menos de 50 unidades de stock ordenados de menor a mayor.

SELECT Nombre AS 'Nombre del producto',Stock
FROM productos
WHERE stock < 50
ORDER BY Stock ASC;

-- 3.- Obtener los nombres y apellidos de los profesionales que trabajan en el horario de tarde (desde las 15:00) y cuál es su horario

SELECT Nombre, Apellidos,CONCAT('Desde  ',hora_inicio, '  hasta las  ', hora_fin) AS 'Horario'
FROM profesionales
WHERE hora_inicio >= 150000;

-- 4.- Obtener una lista con los clientes que estén dados de baja y tengan un descuento mayor de 40.

SELECT Nombre, Apellidos, Baja, Descuento
FROM cliente c
WHERE c.baja or c.descuento > 40;

-- APARTADO B:
-- 5.- Obtener la fecha y hora de la cita, el nombre y apellidos del cliente y el número de trabajador del fisioterapeuta para todas las citas a domicilio, ordenadas por fecha y hora de forma ascendente.

SELECT c.Fecha, c.Hora, CONCAT(x.nombre, ' ', x.apellidos) AS 'Nombre del cliente', p.numero_trabajador AS 'Numero de identificación del fisioterapeuta'
FROM cita c, cliente x, profesionales p
ORDER BY fecha,hora ASC;

-- 6.- Obtener el producto que más cuesta y el que menos cuesta, indicando su valor.

SELECT  Nombre, Precio 
FROM Productos 
WHERE Precio = (SELECT MAX(Precio) FROM Productos) OR Precio = (SELECT MIN(Precio) FROM Productos);

-- 7.- Obtener un listado donde se muestre por cada uno de los estados en los que puede estar un profesor de pilates, la cantidad total de profesores que existen por cada uno de ellos.

SELECT p.estado AS 'Estado del profesor', COUNT(*) AS 'Cantidad de profesores' 
FROM profesionales p 
INNER JOIN profesor_pilates pp ON p.numero_trabajador = pp.numero_trabajador_pilates 
GROUP BY P.estado;

-- 8.- Obtener por cada mes que haya tenido al menos una cita (con el formato de nombre y no de número ej. Noviembre), la cantidad de citas realizadas en 2022 ordenadas por número de citas de mayor a menor.

SELECT DATE_FORMAT(Fecha, '%M') AS 'Mes',COUNT(*) AS 'Cantidad de citas', fecha 
FROM cita
WHERE YEAR(Fecha) = 2022 
GROUP BY fecha
HAVING COUNT(*) > 0 
ORDER BY COUNT(*) DESC;

 -- 9.- Obtener un histórico de todas las citas del cliente ‘27256987J’ dónde se pueda ver el numero trabajador del fisioterapeuta que le trató, la fecha y el precio de las citas.

SELECT f.numero_trabajador_fisio AS 'Numero de Fisioterapeuta', c.fecha AS 'Fecha de la cita', c.precio AS  'Precio de la cita'
FROM fisioterapeuta f, cita c
WHERE DNI_cliente = '27256987J';

-- 10.- Obtener un listado de todos los fisioterapeutas que han dado citas fuera de su horario, mostrando en qué fecha la dieron en formato DD/MM/AAAA.

SELECT numero_fisio AS 'Fisioterapeuta', CONCAT(p.nombre, ' ',p.apellidos) AS 'Nombre del fisio' , DATE_FORMAT(fecha, '%d/%m/%Y') AS 'Fecha de la cita fuera de horario' 
FROM cita c 
JOIN profesionales p ON c.numero_fisio = p.numero_trabajador 
WHERE c.hora < p.hora_inicio OR c.hora > p.hora_fin 
GROUP BY p.numero_trabajador, c.fecha;

-- 11.- Obtener un listado con la fecha de la última cita que se dio y el nombre y apellidos del cliente que asistió.

SELECT CONCAT(c.nombre, ' ', c.apelLidos) AS 'Nombre completo' , max(ci.fecha) AS 'Última cita'
FROM cliente c  
INNER JOIN  cita ci ON c.dni = ci.Dni_cliente
GROUP BY c.nombre,c.apellidos;

-- 12.- Obtener un listado con el nombre y apellidos de cada profesor de pilates que no estén ni despedidos ni ausentes y también la cantidad de clases que han impartido ordenados de mayor a menor por la cantidad de clases.

SELECT CONCAT(p.nombre,' ', p.apellidos) AS 'Nombre del profesor', COUNT(*) AS CantidadClases
FROM profesionales p
INNER JOIN imparte i ON p.numero_trabajador = i.numero_trabajador_pilates
WHERE p.estado NOT IN ('Despedido', 'Ausente') 
GROUP BY p.nombre, p.apellidos
ORDER BY CantidadClases DESC;

-- 13.- Obtener por cada producto cuantas unidades se han vendido, mostrar también los productos que no hayan tenido ninguna venta.

SELECT p.id AS 'Num Id', p.nombre AS 'Nombre del producto' , IFNULL(SUM(v.cantidad), 0) AS 'Unidadaes Vendidas'
FROM productos p
LEFT JOIN venden v ON p.id = v.id_producto
GROUP BY p.id, p.nombre
ORDER BY 'Unidades Vendidas' DESC;

-- 14.- Obtener los nombres, apellidos y teléfonos de los fisioterapeutas que trabajen menos de 5 horas al día y estén trabajando actualmente.

SELECT CONCAT(p.nombre, ' ', p.apellidos) AS 'Nombre del profesional' , p.telefono AS 'Teléfono'
FROM profesionales p
LEFT JOIN fisioterapeuta f ON p.numero_trabajador = f.numero_trabajador_fisio
WHERE TIMEDIFF(hora_fin, hora_inicio) < '05:00:00' AND p.estado = 'Trabajando';

-- 15.- Obtener un listado de clases de pilates que hayan sido impartidas por más de un profesor, indicando el nombre de la sala, el día, la hora de la clase y número de profesores.

SELECT s.nombre AS 'Nombre de la sala' , i.fecha AS 'Fecha de la clase', i.hora AS 'Hora de la clase', count(*) AS 'Numero de profesores'
FROM imparte i
JOIN salas s ON i.codigo_sala = s.codigo
GROUP BY i.codigo_sala, i.fecha, i.hora
HAVING COUNT(*) > 1;

-- 16.- Obtener un listado con el precio medio de las citas de 2022 por cada fisioterapeuta que esté trabajando, mostrar número de fisio y el precio medio.

SELECT f.numero_trabajador_fisio AS 'Numero de fisio', AVG(c.precio) AS 'Precio medio'
FROM fisioterapeuta f
JOIN  cita c  ON f.numero_trabajador_fisio = c.numero_fisio
JOIN profesionales p ON f.numero_trabajador_fisio = p.numero_trabajador
WHERE YEAR (c.fecha) = 2022  AND  p.estado = 'Trabajando'
GROUP BY f.numero_trabajador_fisio;

-- APARTADO C:
-- 17.- Obtener un listado con el nombre de la sala y el nombre completo del profesor de pilates junto al número de veces que dicho profesor ha utilizado cada una de las salas donde al menos haya impartido clase el mismo profesor en la misma sala 2 o más veces.

SELECT s.nombre AS 'Nombre de la sala' , CONCAT(p.nombre,' ', p.apellidos) AS 'Nombre del profesor', COUNT(*) AS 'Cantidad de clases'
FROM  salas s, profesionales p
INNER JOIN imparte i ON p.numero_trabajador = i.numero_trabajador_pilates
GROUP BY  s.nombre, CONCAT(p.nombre,' ', p.apellidos)
HAVING COUNT(*) >= 2;

-- 18.- Obtener el DNI y nombre de cada cliente junto a la cantidad total que lleva gastada en fisioterapeutas, siempre y cuando esa cantidad total sea superior a la media de todas las citas.

SELECT c.DNI, CONCAT(c.nombre, ' ', c.apellidos) as 'Nombre del cliente', SUM(ci.precio) AS 'Total gastado'
FROM cliente c
JOIN cita ci ON c.DNI = ci.DNI_cliente
GROUP BY c.DNI,CONCAT(c.nombre, ' ', c.apellidos)
HAVING SUM(ci.precio) > (SELECT AVG(ci.precio) FROM cita ci);



