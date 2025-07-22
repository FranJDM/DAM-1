--EJERCICIO 1 A: Filtro y disparador de actualización de citas nuevas asociadas a un fisio
CREATE OR REPLACE PROCEDURE listar_citas_fisioterapeuta(p_fisioterapeuta NUMBER) AS
  v_total_citas NUMBER := 0;

BEGIN
  DBMS_OUTPUT.PUT_LINE('El fisio con número: ' || p_fisioterapeuta || ' ha tenido cita con los siguientes clientes:');
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('CLIENTES                                  DNI           TELEFONO            FECHA            PRECIO');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------------------------------');
  FOR c IN (SELECT c.nombre, c.apellidos, c.dni, c.telefono, ci.fecha_hora, ci.precio
            FROM cliente c
            INNER JOIN cita ci ON c.dni = ci.dni_cliente
            WHERE ci.numero_fisio = p_fisioterapeuta
            ORDER BY ci.fecha_hora)
  LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(c.nombre || ' ' || c.apellidos, 40) ||
      RPAD(c.dni, 15) ||
      RPAD(c.telefono, 20) ||
        RPAD(TO_CHAR(c.fecha_hora, 'DD-MON-YY HH24:MI'), 20) ||
      RPAD(c.precio, 10)
    );
    v_total_citas := v_total_citas + c.precio;
  END LOOP;
DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE(RPAD('SUMA DE LOS PRECIOS', 95) || v_total_citas);
END;
/


--Comprobamos

BEGIN
  listar_citas_fisioterapeuta(3); -- Reemplazar con el número de fisioterapeuta a comprobar
END;
/




--EJERCICIO 2 B: Calculo de precio antes y después de los clientes con/sin descuento

CREATE OR REPLACE PROCEDURE calcular_citas_descuento(p_dni VARCHAR2) AS
  v_cliente_id cliente.dni%TYPE;
  v_nombre cliente.nombre%TYPE;
  v_apellidos cliente.apellidos%TYPE;
  v_num_citas NUMBER := 0;
  v_precio_bruto NUMBER := 0;
  v_porcentaje_descuento cliente.descuento%TYPE;
  v_descuento NUMBER := 0;
  v_precio_neto NUMBER := 0;
BEGIN
  -- Obtenemos los datos del cliente por su DNI
  SELECT cliente.dni, nombre, apellidos, descuento INTO v_cliente_id, v_nombre, v_apellidos, v_porcentaje_descuento
  FROM cliente
  WHERE dni = p_dni;

  -- Calculos de la cantidad de citas y precio antes de descuento
  SELECT COUNT(*) AS num_citas, SUM(precio) AS precio_total
  INTO v_num_citas, v_precio_bruto
  FROM cita
  WHERE dni_cliente = v_cliente_id;

  -- Calculos del descuento y precio después del descuento
  v_descuento := v_precio_bruto * (v_porcentaje_descuento / 100);
  v_precio_neto := v_precio_bruto - v_descuento;

  -- Creamos el print
  DBMS_OUTPUT.PUT_LINE('DNI del cliente: ' || p_dni);
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
  DBMS_OUTPUT.PUT_LINE('Apellidos: ' || v_apellidos);
  DBMS_OUTPUT.PUT_LINE('Número de citas: ' || v_num_citas);
  DBMS_OUTPUT.PUT_LINE('Precio total antes del descuento: ' || v_precio_bruto);
  DBMS_OUTPUT.PUT_LINE('Descuento aplicable: ' || v_descuento);
  DBMS_OUTPUT.PUT_LINE('Precio total después del descuento: ' || v_precio_neto);
END;
/

--Comprobamos

BEGIN
  calcular_citas_descuento('27569874M');
END;
/

-- EJERCICIO 3 C: Numero de fisioterapeutas por sala mediante nombre

--Como tenemos todos los datos que necesitamos en la tabla imparten solo tenemos que relacionarlos con el codigo de la sala
CREATE OR REPLACE FUNCTION contar_profesores_pilates(p_nombre_sala VARCHAR2) RETURN NUMBER IS
  v_num_profesores NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO v_num_profesores
  FROM imparte i
  INNER JOIN salas s ON i.codigo_sala = s.codigo
  WHERE s.nombre = p_nombre_sala;

  RETURN v_num_profesores;
END;
/

--Para comprobar que funciona nuestro script hacemos una consulta
--En mi caso dejo indicado la consulta  Pilates 1

SELECT contar_profesores_pilates('Pilates 1') FROM dual;


--EJERCICIO 4:

CREATE OR REPLACE TRIGGER disminuir_stock
AFTER INSERT ON VENDEN
FOR EACH ROW
BEGIN
  UPDATE PRODUCTOS
  SET stock = stock - :NEW.cantidad
  WHERE id = :NEW.id_producto;
END;
/

-- Posibles comprobaciones, vendemos 10 uds del producto "00000475"
-- introducimos el número del trabajador 1, y obtenemos la fecha del sistema
-- podremos comprobar que la cantidad ha disminuido haciendo un SELECT

INSERT INTO VENDEN (numero_trabajador, id_producto, cantidad, fecha)
VALUES ('00001', '00000475', 10, SYSDATE);
