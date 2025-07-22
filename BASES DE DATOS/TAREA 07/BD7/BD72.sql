/*ACTIVIDAD 1*/
/*Creamos el objeto "persona" con los atributos indicados
tambien indicamos NOT FINAL para que pueda ser elemento padre
de los siguientes que obtendran su herencia*/
CREATE OR REPLACE TYPE persona AS OBJECT (
        dni       VARCHAR2(9),
        nombre    VARCHAR2(30),
        apellidos VARCHAR2(40),
        telefono  VARCHAR2(9),
        f_ingreso DATE
) NOT FINAL;

/*Creamos el tipo voluntario con su atributo*/
/*Incluimos la funcion de calcular puntos ganados*/
CREATE OR REPLACE TYPE voluntario UNDER persona (
        puntosacumula NUMBER(8),
        MEMBER FUNCTION calcularpuntosganados RETURN NUMBER
);

-- Crear una función para obtener los puntos ganados en base a los turnos del mes
/*Definimos la funcion y el parametro para posteriormente multiplicarlo por 50*/
CREATE OR REPLACE FUNCTION obtenerturnosdelmes (
    turnosmes NUMBER
) RETURN NUMBER IS
    total NUMBER;
BEGIN
  -- Cálculo de los puntos ganados en base a los turnos del mes
    total := turnosmes * 50;
    RETURN total;
END;


/*Implementamons el cuerpo del elemento Voluntario*/
CREATE OR REPLACE TYPE BODY voluntario AS
    MEMBER FUNCTION calcularpuntosganados RETURN NUMBER IS
        puntosganados NUMBER;
    BEGIN
    -- Cálculo de los puntos ganados en base a los turnos del mes
        puntosganados := obtenerturnosdelmes(8);
        RETURN puntosganados;
    END calcularpuntosganados;

END;



-- Crear el tipo de objeto "Cliente" como tipo heredado de "Persona"
CREATE OR REPLACE TYPE cliente UNDER persona (
        ingresosmes NUMBER(6, 2),
        miembrosfam NUMBER(2),
        tipoayuda   VARCHAR2(1),
        CONSTRUCTOR FUNCTION cliente (
               dni         VARCHAR2,
               nombre      VARCHAR2,
               apellidos   VARCHAR2,
               telefono    VARCHAR2,
               f_ingreso   DATE,
               ingresosmes NUMBER,
               miembrosfam NUMBER
           ) RETURN SELF AS RESULT
);
/

-- Crear el cuerpo del tipo de objeto "Cliente"
/*Como debemos de tener en cuenta que tipo de ayuda le corresponde 
segun el calculo de la renta, la cual acotamos con la variable
v_renta y asignamos el valor indicado*/
CREATE OR REPLACE TYPE BODY cliente AS
    CONSTRUCTOR FUNCTION cliente (
        dni         VARCHAR2,
        nombre      VARCHAR2,
        apellidos   VARCHAR2,
        telefono    VARCHAR2,
        f_ingreso   DATE,
        ingresosmes NUMBER,
        miembrosfam NUMBER
    ) RETURN SELF AS RESULT IS
        v_renta NUMBER;
    BEGIN
        self.dni := dni;
        self.nombre := nombre;
        self.apellidos := apellidos;
        self.telefono := telefono;
        self.f_ingreso := f_ingreso;
        self.ingresosmes := ingresosmes;
        self.miembrosfam := miembrosfam;
    
    -- Calcula la renta
        v_renta := ingresosmes / miembrosfam;
    
    -- Asignamos el valor del atributo tipoAyuda según la renta calculada
        IF v_renta <= 50 THEN
            self.tipoayuda := 'A';
        ELSIF v_renta <= 100 THEN
            self.tipoayuda := 'B';
        ELSE
            self.tipoayuda := 'C';
        END IF;

        RETURN;
    END cliente;

END;


/*ACTIVIDAD 2*/
/*Creamos el tipo de objeto Producto*/
CREATE OR REPLACE TYPE producto AS OBJECT (
        codigo   VARCHAR2(3),
        nombre   VARCHAR2(30),
        cantidad NUMBER(3),
        medida   VARCHAR2(10)
);

/*Creamos el VARRAY de Listado de productos pudiendo almacenar hasta 20prods*/
CREATE OR REPLACE TYPE listadoproductos AS
    VARRAY(20) OF producto;

/*Creamos el tipo de objeto Donacion con sus atributos*/
CREATE OR REPLACE TYPE donacion AS OBJECT (
        numero     VARCHAR2(3),
        valor      NUMBER(6, 2),
        listacesta listadoproductos
);

/*Creamos el tipo de objeto Entrega, con sus respectivos atributos*/
CREATE OR REPLACE TYPE entrega AS OBJECT (
        numero     VARCHAR2(5),
        fecha      DATE,
        socio      cliente,
        repartidor REF voluntario,
        cesta      donacion
);


/*ACTIVIDAD 3*/
/*Creamos tablas basadas en los objetos previamente creados */
CREATE TABLE voluntariado OF voluntario;

CREATE TABLE socios OF cliente;

CREATE TABLE catalogo OF producto;

CREATE TABLE entregados OF entrega;


/*ACTIVIDAD 4*/
/*Bloques PL/SQL de voluntario, cliente y producto */
DECLARE
    v_voluntario1 voluntario;
    v_voluntario2 voluntario;
    v_puntos      NUMBER;
BEGIN
  -- Creamos primera instancia de Voluntario
    v_voluntario1 := voluntario('10000000A', 'Jaime', 'Sánchez Terol', '111222333', TO_DATE('15/03/2018',
           'DD/MM/YYYY'), 200);

  -- Creamos segunda instancia de Voluntario
    v_voluntario2 := voluntario('20000000B', 'Carmen', 'Mira González', '888999000', TO_DATE('8/02/2020',
           'DD/MM/YYYY'), 100);

  -- Insertamos las instancias en la tabla VOLUNTARIADO
    INSERT INTO voluntariado VALUES v_voluntario1;

    INSERT INTO voluntariado VALUES v_voluntario2;

  -- Usamos la funcion creada para calcular los puntos ganados por el voluntario con DNI 10000000A
    v_puntos := v_voluntario1.calcularpuntosganados();

  -- Actualizamos los puntos acumulados del voluntario con DNI 10000000A en la tabla VOLUNTARIADO
    UPDATE voluntariado
    SET
        puntosacumula = puntosacumula + v_puntos
    WHERE
        dni = '10000000A';

    dbms_output.put_line('Puntos ganados por el voluntario con DNI 10000000A: ' || v_puntos);
    COMMIT;
END;



/*BLOQUE CLIENTE*/

/*Declaramos 3 instancias de cliente*/
DECLARE
    v_cliente1 cliente;
    v_cliente2 cliente;
    v_cliente3 cliente;
BEGIN
  -- Crear primera instancia de Cliente
    v_cliente1 := cliente('11111111A', 'Pepe', 'Amorós García', '555999000', TO_DATE('12/12/2004',
        'DD/MM/YYYY'), 550, 5, 'C');

  -- Crear segunda instancia de Cliente utilizando el constructor
    v_cliente2 := cliente('22222222B', 'María', 'López Narváez', '222444666', TO_DATE('24/05/2008',
        'DD/MM/YYYY'), 780, 8);

  -- Crear tercera instancia de Cliente utilizando el constructor
    v_cliente3 := cliente('33333333C', 'Luis', 'Pérez Sanz', '444555666', TO_DATE('30/01/2010',
        'DD/MM/YYYY'), 420, 9);

  -- Insertar instancias en la tabla SOCIOS
    INSERT INTO socios VALUES v_cliente1;

    INSERT INTO socios VALUES v_cliente2;

    INSERT INTO socios VALUES v_cliente3;
    COMMIT;
END;

/*BLOQUE PRODUCTOS*/
DECLARE
  -- Creamos las instancias de Producto
    p1              producto := producto('001', 'Leche', 6, 'litros');
    p2              producto := producto('002', 'Pan', 3, 'unidades');
    p3              producto := producto('003', 'Huevos', 12, 'unidades');
    p4              producto := producto('004', 'Pach Fruta', 3, 'kilos');
    p5              producto := producto('005', 'Botella Aceite', 1, 'litros');
    p6              producto := producto('006', 'Paquete Legumbres', 2, 'kilos');
    p7              producto := producto('007', 'Paquete Pasta', 4, 'kilos');
    p8              producto := producto('008', 'Paquete Galletas', 6, 'unidades');

  -- Creamos las instancias de ListadoProductos utilizando los productos previamente creados
    listaproductos1 listadoproductos := listadoproductos(p1, p3, p5, p7);
    listaproductos2 listadoproductos := listadoproductos(p1, p2, p4, p8);
    listaproductos3 listadoproductos := listadoproductos(p3, p5, p6);
  
  
  -- Variables correpsondiendes a donaciones
    donacion1       donacion;
    donacion2       donacion;
    donacion3       donacion;
  
   -- Variables para guardar las referencias de voluntarios
    refvoluntario1  REF voluntario;
    refvoluntario2  REF voluntario;
  
    -- Variables para guardar las instancias de clientes
    cliente1        cliente;
    cliente2        cliente;
  
    -- Variables para guardar las instancias de Entrega
    entrega1        entrega;
    entrega2        entrega;
    entrega3        entrega;
    entrega4        entrega;
BEGIN

-- Creamos las instancias de donacion
    donacion1 := donacion('11', 35, listaproductos1);
    donacion2 := donacion('22', 30, listaproductos2);
    donacion3 := donacion('33', 25, listaproductos3);
   
    /*Obtenemos las referencias de los voluntarios
    y las guardamos en la variable V*/
    
    SELECT
        ref(v)
    INTO refvoluntario1
    FROM
        voluntariado v
    WHERE
            v.dni = '10000000A'
        AND ROWNUM = 1;

    SELECT
        ref(v)
    INTO refvoluntario2
    FROM
        voluntariado v
    WHERE
            v.dni = '20000000B'
        AND ROWNUM = 1;
/*Obtenemos las referencias de los clinetes y las guardamos en la variable
C*/
    SELECT
        value(c)
    INTO cliente1
    FROM
        socios c
    WHERE
            c.dni = '11111111A'
        AND ROWNUM = 1;

    SELECT
        value(c)
    INTO cliente2
    FROM
        socios c
    WHERE
            c.dni = '22222222B'
        AND ROWNUM = 1;
        
        /*Creamos 4 instancias de entrega, con sus correspondientes parámetros
        que son el resultado de recuperar instancias creadas previamente*/

    entrega1 := entrega('00001', '18/02/2023', cliente1, refvoluntario1, donacion1);
    entrega2 := entrega('00002', '18/02/2023', cliente2, refvoluntario1, donacion3);
    entrega3 := entrega('00003', '29/03/2023', cliente1, refvoluntario2, donacion2);
    entrega4 := entrega('00004', '29/03/2023', cliente2, refvoluntario1, donacion2);

    /*Insertamos  las instancias creadas previamente en la tabla entregados*/
    INSERT INTO entregados VALUES entrega1;

    INSERT INTO entregados VALUES entrega2;

    INSERT INTO entregados VALUES entrega3;

    INSERT INTO entregados VALUES entrega4;

  -- Mostramos los nombres de los productos en ListaProductos1
  /*Esto lo hacemos usando un bucle que recorre la instancia indicada*/
  
    FOR i IN 1..listaproductos1.count LOOP
        dbms_output.put_line(listaproductos1(i).nombre);
    END LOOP;

    COMMIT;
END;


/*ACTIVIDAD 5*/
/*Actualizacion de la fecha mediante UPDATE*/
UPDATE entregados
SET
    fecha = TO_DATE('12/04/23', 'DD/MM/YY')
WHERE
    numero = '00004';
/*Declaramos 2 variables; para entrega y para voluntario*/
DECLARE
    Ventrega    entrega;
    Vvoluntario voluntario;
    
    /*Recuperamos la informacion de la tabla entregados y DUAL para luego hacer un
    print de los datos obtenidos*/
BEGIN
    SELECT
        value(f)
    INTO ventrega
    FROM
        entregados f
    WHERE
            numero = '00002'
        AND ROWNUM = 1;

    SELECT
        deref(ventrega.repartidor)
    INTO vvoluntario
    FROM
        dual;

    dbms_output.put_line('DATOS DONACION ENTREGADA');
    dbms_output.put_line('----------------------------');
    dbms_output.put_line('DONACION ENTREGADA NUM: ' || Ventrega.numero);
    dbms_output.put_line('FECHA ENTREGADA DONACION: '
                         || to_char(Ventrega.fecha, 'DD/MM/YY'));
    dbms_output.put_line('DATOS SOCIO BENEFICIARIO: '
                         || Ventrega.socio.nombre
                         || ' '
                         || Ventrega.socio.apellidos);

    dbms_output.put_line('ENTREGADO POR VOLUNTARIO: ' || Vvoluntario.nombre);
    dbms_output.put_line('NUMERO DE CESTA DONADA: ' || Ventrega.cesta.numero);
    dbms_output.put_line('');
    dbms_output.put_line('LISTA DE PRODUCTOS QUE CONTIENE ESA CESTA:');
    dbms_output.put_line('------------------------------------------');
    FOR i IN 1..Ventrega.cesta.listacesta.count LOOP
        dbms_output.put_line('PRODUCTO: '
                             || Ventrega.cesta.listacesta(i).nombre
                             || ' - '
                             || Ventrega.cesta.listacesta(i).cantidad
                             || ' '
                             || Ventrega.cesta.listacesta(i).medida);
    END LOOP;

END;
/