/*ACTIVIDAD 1*/
CREATE OR REPLACE TYPE Persona AS OBJECT (
  DNI       VARCHAR2(9),
  nombre    VARCHAR2(30),
  apellidos VARCHAR2(40),
  telefono  VARCHAR2(9),
  f_ingreso DATE
)NOT FINAL;
/

/*Creamos el tipo voluntario con su atributo*/

CREATE OR REPLACE TYPE Voluntario UNDER Persona (
  puntosAcumula NUMBER(8),
  MEMBER FUNCTION calcularPuntosGanados RETURN NUMBER
);
/

-- Crear una función para obtener los puntos ganados en base a los turnos del mes
CREATE OR REPLACE TYPE Voluntario UNDER Persona (
  puntosAcumula NUMBER(8),
  MEMBER FUNCTION calcularPuntosGanados RETURN NUMBER
);
/

-- Implementar la función calcularPuntosGanados en el tipo de objeto Voluntario
CREATE OR REPLACE TYPE BODY Voluntario AS
  MEMBER FUNCTION calcularPuntosGanados RETURN NUMBER IS
    puntosGanados NUMBER;
  BEGIN
    -- Cálculo de los puntos ganados en base a los turnos del mes
    puntosGanados := ObtenerTurnosDelMes(8);
    
    RETURN puntosGanados;
  END calcularPuntosGanados;
END;
/



-- Crear el tipo de objeto "Cliente" como tipo heredado de "Persona"
CREATE OR REPLACE TYPE Cliente UNDER Persona (
  ingresosMes NUMBER(6,2),
  miembrosFam NUMBER(2),
  tipoAyuda   VARCHAR2(1),
  CONSTRUCTOR FUNCTION Cliente(
    DNI VARCHAR2,
    nombre VARCHAR2,
    apellidos VARCHAR2,
    telefono VARCHAR2,
    f_ingreso DATE,
    ingresosMes NUMBER,
    miembrosFam NUMBER
  ) RETURN SELF AS RESULT
);
/

-- Crear el cuerpo del tipo de objeto "Cliente"
CREATE OR REPLACE TYPE BODY Cliente AS
  CONSTRUCTOR FUNCTION Cliente(
    DNI VARCHAR2,
    nombre VARCHAR2,
    apellidos VARCHAR2,
    telefono VARCHAR2,
    f_ingreso DATE,
    ingresosMes NUMBER,
    miembrosFam NUMBER
  ) RETURN SELF AS RESULT IS
    v_renta NUMBER;
  BEGIN
    SELF.DNI := DNI;
    SELF.nombre := nombre;
    SELF.apellidos := apellidos;
    SELF.telefono := telefono;
    SELF.f_ingreso := f_ingreso;
    SELF.ingresosMes := ingresosMes;
    SELF.miembrosFam := miembrosFam;
    
    -- Calcula la renta
    v_renta := ingresosMes/miembrosFam;
    
    -- Asignamos el valor del atributo tipoAyuda según la renta calculada
    IF v_renta <= 50 THEN
      SELF.tipoAyuda := 'A';
    ELSIF v_renta <= 100 THEN
      SELF.tipoAyuda := 'B';
    ELSE
      SELF.tipoAyuda := 'C';
    END IF;
    
    RETURN;
  END Cliente;
END;
/


/*ACTIVIDAD 2*/
/*Creamos el tipo de objeto Producto*/
CREATE OR REPLACE TYPE Producto AS OBJECT (
  codigo   VARCHAR2(3),
  nombre   VARCHAR2(30),
  cantidad NUMBER(3),
  medida   VARCHAR2(10)
);
/
/*Creamos el VARRAY de Listado de productos pudiendo almacenar hasta 20prods*/
CREATE OR REPLACE TYPE ListadoProductos AS VARRAY(20) OF Producto;
/
/*Creamos el tipo de objeto Donacion con sus atributos*/
CREATE OR REPLACE TYPE Donacion AS OBJECT (
  numero     VARCHAR2(3),
  valor      NUMBER(6,2),
  listaCesta ListadoProductos
);
/
/*Creamos el tipo de objeto Entrega, con sus respectivos atributos*/
CREATE OR REPLACE TYPE Entrega AS OBJECT (
  numero     VARCHAR2(5),
  fecha      DATE,
  socio      REF Cliente,
  repartidor REF Voluntario,
  cesta      REF Donacion
);
/

/*ACTIVIDAD 3*/
/*Creamos tablas basadas en los objetos previamente creados */
CREATE TABLE VOLUNTARIADO OF Voluntario;
CREATE TABLE SOCIOS OF Cliente;
CREATE TABLE CATALOGO OF Producto;
CREATE TABLE ENTREGADOS OF Entrega;


/*ACTIVIDAD 4*/
/*Bloques PL/SQL de voluntario, cliente y producto */
DECLARE
  v_voluntario1 Voluntario;
  v_voluntario2 Voluntario;
  v_puntos NUMBER;
BEGIN
  -- Crear primera instancia de Voluntario
  v_voluntario1 := Voluntario('10000000A', 'Jaime', 'Sánchez Terol', '111222333', TO_DATE('15/03/2018', 'DD/MM/YYYY'), 200);

  -- Crear segunda instancia de Voluntario
  v_voluntario2 := Voluntario('20000000B', 'Carmen', 'Mira González', '888999000', TO_DATE('8/02/2020', 'DD/MM/YYYY'), 100);

  -- Insertar instancias en la tabla VOLUNTARIADO
  INSERT INTO VOLUNTARIADO VALUES v_voluntario1;
  INSERT INTO VOLUNTARIADO VALUES v_voluntario2;

  -- Calcular puntos ganados para el voluntario con DNI 10000000A
  v_puntos := v_voluntario1.calcularPuntosGanados();

  -- Actualizar puntos acumulados del voluntario con DNI 10000000A en la tabla VOLUNTARIADO
  UPDATE VOLUNTARIADO SET puntosAcumula = puntosAcumula + v_puntos WHERE DNI = '10000000A';

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Puntos ganados por el voluntario con DNI 10000000A: ' || v_puntos);
END;
/


/*BLOQUE CLIENTE*/
DECLARE
  v_cliente1 Cliente;
  v_cliente2 Cliente;
  v_cliente3 Cliente;
BEGIN
  -- Crear primera instancia de Cliente
  v_cliente1 := Cliente('11111111A', 'Pepe', 'Amorós García', '555999000', TO_DATE('12/12/2004', 'DD/MM/YYYY'), 550, 5, 'C');

  -- Crear segunda instancia de Cliente utilizando el constructor
  v_cliente2 := Cliente('22222222B', 'María', 'López Narváez', '222444666', TO_DATE('24/05/2008', 'DD/MM/YYYY'), 780, 8);

  -- Crear tercera instancia de Cliente utilizando el constructor
  v_cliente3 := Cliente('33333333C', 'Luis', 'Pérez Sanz', '444555666', TO_DATE('30/01/2010', 'DD/MM/YYYY'), 420, 9);

  -- Insertar instancias en la tabla SOCIOS
  INSERT INTO SOCIOS VALUES v_cliente1;
  INSERT INTO SOCIOS VALUES v_cliente2;
  INSERT INTO SOCIOS VALUES v_cliente3;

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Inserciones de clientes realizadas correctamente.');
END;
/


/*BLOQUE PRODUCTO*/
DECLARE
  v_producto1 Producto;
  v_producto2 Producto;
  v_producto3 Producto;
  v_producto4 Producto;
  v_producto5 Producto;
  v_producto6 Producto;
  v_producto7 Producto;
  v_producto8 Producto;
BEGIN
  -- Crear instancias de Producto
  v_producto1 := Producto('001', 'Leche', 6, 'litros');
  v_producto2 := Producto('002', 'Pan', 3, 'unidades');
  v_producto3 := Producto('003', 'Huevos', 12, 'unidades');
  v_producto4 := Producto('004', 'Pach Fruta', 3, 'kilos');
  v_producto5 := Producto('005', 'Botella Aceite', 1, 'litros');
  v_producto6 := Producto('006', 'Paquete Legumbres', 2, 'kilos');
  v_producto7 := Producto('007', 'Paquete Pasta', 4, 'kilos');
  v_producto8 := Producto('008', 'Paquete Galletas', 6, 'unidades');
  
  -- Insertar instancias en la tabla CATALOGO
  INSERT INTO CATALOGO VALUES v_producto1;
  INSERT INTO CATALOGO VALUES v_producto2;
  INSERT INTO CATALOGO VALUES v_producto3;
  INSERT INTO CATALOGO VALUES v_producto4;
  INSERT INTO CATALOGO VALUES v_producto5;
  INSERT INTO CATALOGO VALUES v_producto6;
  INSERT INTO CATALOGO VALUES v_producto7;
  INSERT INTO CATALOGO VALUES v_producto8;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Instancias de Producto creadas y insertadas en la tabla CATALOGO.');

END;



