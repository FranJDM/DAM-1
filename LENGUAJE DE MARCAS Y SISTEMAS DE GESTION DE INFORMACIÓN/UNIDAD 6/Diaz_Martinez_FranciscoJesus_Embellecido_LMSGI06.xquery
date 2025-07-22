(:Para este ejercicio me he tomado la libertad de investigar como hacer un salto de línea entre etiquetas y he encontrado que mediante la función "concat" después del return
y añadiendo &#10 para el salto de línea se podían ordenar las consultas. No obstante también entregaré las consultas sin formato:)

(: Ejercicio 1 :)
(: Obtener la marca, modelo y precio de los vehiculos comerciales que le cuesten a la empresa menos de 100.000 €, ordenados desde el más caro al más barato.
Estructura: 
<vehiculo>
   <marca>Marca</marca>
   <modelo>Modelo</modelo>
   <precio moneda="EUR">XXX</precio>
</vehiculo>
:)

(:Para esta primera consulta, solo tenemos que filtrar los vehiculos que tenguna un precio menor a 100.000€, posteriormente los ordenamos en orden descendiente |order by- descending| y mostramos el return
con la información y estructura que nos indican:)

for $vehiculo in doc("llegaya.xml")//vehiculo[precio < 100000]
order by $vehiculo/precio descending
return
  concat(
    '<vehiculo>',
    '&#10;<marca>', data($vehiculo/marca), '</marca>',
    '&#10;<modelo>', data($vehiculo/modelo), '</modelo>',
    '&#10;<precio moneda="EUR">', data($vehiculo/precio), '</precio>',
    '&#10;</vehiculo>',
    '&#10;'
  )
,

(: Ejercicio 2 :)
(: Obtener el nif, zona de reparto, nombre, teléfono y salario (en ese orden) de los repartidores que han realizado más 5 repartos con un vehículos de la marca "Tesla" en el 2023. (No sabemos su código, sólo la marca del vehiculo).
Resultado: 
<repartidor nif="23234234B" zona="D">
   <nombre>Víctor</nombre>
   <telefono>607624122</telefono>
   <salario unidad="Euros">1100</salario>
</repartidor>
:)

(:Primero establecemos el elemento repartido y reparto para luego relacionarlos:)
(:Filtramos mediante la clausula |where| la condición de reparto en 2023 con más de 5 testlas vendidos cuya identififcacion es "semi":)

let $repartidores := doc("llegaya.xml")/llegaya/repartidores/repartidor
let $repartos := doc("llegaya.xml")/llegaya/repartos/reparto
for $repartidor in $repartidores
let $nif := $repartidor/@nif
let $zona := $repartidor/@zona
let $nombre := $repartidor/nombre
let $telefono := $repartidor/telefono
let $salario := $repartidor/salario
where $repartos[@repartidor = $nif and @vehiculo = "semi" and contains(@fechareparto, "2023") and number(.) > 5]
return
concat(
  '<repartidor nif="', $nif, '" zona="', $zona, '">',
  '&#10;  <nombre>', $nombre, '</nombre>',
  '&#10;  <telefono>', $telefono, '</telefono>',
 '&#10;  <salario>', $salario, '</salario>',
  '&#10;</repartidor>',
  '&#10;'
)
,

(: Ejercicio 3 :)
(: Obtener (usando let) el número total de vehículos comerciales que tiene llegaya, el coste total de adquisición y el precio del vehículo más caro.
Estructura:
<totales>
   <flota_vehiculos>X</flota_vehiculos>
   <coste_total moneda="EUR">XXX</coste_total>
   <mas_caro moneda="EUR">XXX</mas_caro>
</totales>
:)

(:Operamos con vehículos haciendo un count para obtener un recuento, con un "sum" obtenemos el total del precio de adquisición de los vehículos y con un "max" el vehículo
más caro de la flota:)

let $vehiculos := count(doc("llegaya.xml")//vehiculo)
let $coste_total := sum(doc("llegaya.xml")//vehiculo/precio)
let $mas_caro := max(doc("llegaya.xml")//vehiculo/precio)
return
  concat(
    '<totales>',
    '&#10;  <flota_vehiculos>', $vehiculos, '</flota_vehiculos>',
    '&#10;  <coste_total moneda="EUR">', $coste_total, '</coste_total>',
    '&#10;  <mas_caro moneda="EUR">', $mas_caro, '</mas_caro>',
    '&#10;</totales>',
    '&#10;&#10;'
  )

,

(: Ejercicio 4 :)
(: Obtener, usando let, la suma de los salarios de los repartidores que cobran menos de 1.000 €, que viven en la provincia de Sevilla (excepto los que viven en la capital) y además no tienen zona A. 
Estructura:
<total_salarios moneda="EUR">XXX</total_salarios>
:) 

(:Para obtener la suma de los salarios usando sum, debemos de a continuación poner las conciones "not" para la zona A y "and|and not" para indicar que viviendo en Sevilla, debemos de
tener en cuenta solo los que no viven en la localidad de Sevilla, así como establecer que la variable salario debe de ser menor a 1000:)

let $total_salarios := sum(doc("llegaya.xml")/llegaya/repartidores/repartidor[not(@zona = 'A') and provincia = 'Sevilla' and not(localidad = 'Sevilla') and salario < 1000]/salario)
return
concat(
    '<total_salarios moneda="EUR">', $total_salarios, '</total_salarios>',
    '&#10;
     &#10;'
  )
,

(: Ejercicio 5 :)
(: Obtener el nombre del cliente, los paquetes que incluye esa entrega, el coste de la entrega y el precio con un descuento del 50% para empleados. Ordenar por el nombre del cliente desde el nombre más corto hasta el más largo.
Estructura:
<entrega>
   <nombre>Nombre</nombre>
   <paquetes>XX</paquetes>
   <importe moneda="EUR">XX</importe>
   <importe_empleados moneda="EUR">XX</importe_empleados>
</entrega>
:)

(:Esta consulta es la más sencilla respecto a configuración, ya que solo tenemos que filtrar las entregas mediante la longitud de la string correspondiente al nombre asociado
esto lo hacemos con la funcion order by seguida de string-length que cuenta los caracteres de la string, y al no indicar descending, la omisión hace que el orden sea de menor a mayor:)

for $entrega in doc("llegaya.xml")//entrega
order by string-length($entrega/nombre)
return
concat(
    '<entrega>',
    '&#10;  <nombre>', $entrega/nombre/text(), '</nombre>',
    '&#10;  <paquetes>', $entrega/paquetes/text(), '</paquetes>',
    '&#10;  <importe moneda="EUR">', $entrega/importe/text(), '</importe>',
    '&#10;  <importe_empleados moneda="EUR">', $entrega/importe * 0.5, '</importe_empleados>',
    '&#10;</entrega>',
    '&#10;&#10;'
  )
