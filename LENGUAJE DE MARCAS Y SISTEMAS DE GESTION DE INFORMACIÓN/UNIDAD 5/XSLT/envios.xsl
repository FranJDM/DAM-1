<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" />
    <xsl:template match="/">
        <html>
            <head>
                <title>Tarea 5 - LMSGI - Curso 2022-23</title>
                <style>
                    table, th, td {
                    width:500px;
                    margin: 0 auto;
                    text-align: center;
                    border: 1px solid black;
                    border-collapse: collapse;
                    }
                    th {
                    color: white;
                    background-color:grey;
                    }
                    .urgente {
                    color: red;
                    background-color:yellow;
                    }
                    .nocturno {
                    color: white;
                    background-color:black;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h2>Lenguaje de Marcas y Sistemas de Gestión de Información</h2>
                    <h2>Tarea 5: XPath y XSLT</h2>
                    <h2>Autor/a: Francisco Jesús Díaz Martínez</h2>
                </header>
                <h3>A. Lista ordenada por precio y apellido de los envíos a Sevilla. 
                    Indicar el número de orden (con número), el precio, la moneda, el 
                    apellido y el nombre. El orden será de mayor a menor precio y si 
                    tienen el mismo precio por orden alfabético de apellido. </h3>
                <h5>Formato:<br/> 1) 33 euros - Sánchez, Carlos.</h5>
                <br/>
                <br/>
                <envios>
                    <xsl:for-each select="//envio[provincia='Sevilla']">
                        <xsl:sort select="precio" order="descending"/>
                        <xsl:sort select="apellido"/>
                        <xsl:variable name="num" select="position()"/>
                        <xsl:variable name="moneda" select="precio/@moneda" />
                        <xsl:value-of select="concat(position(), ') ', precio, ' ', $moneda, ' - ', apellido, ', ', nombre,'.')"/>
                        <br/>
                    </xsl:for-each>
                </envios>
                        
                <h3>B. Número de envíos urgentes a Cádiz y su porcentaje respecto al 
                    total de envíos a Cádiz</h3>
                <h5>Formato:<br/> Hay 4 envíos urgentes a Cádiz, que suponen el 28.57% 
                    de los 14 envíos totales registrados a Cádiz.</h5>
                <br/>
                <br/>

                <xsl:template match="/">
                    <xsl:variable name="cadiz-envios" select="/envios/envio[provincia='Cádiz']"/>
                    <xsl:variable name="cadiz-envios-urgentes" select="$cadiz-envios[prioridad='Urgente']"/>
                    <xsl:variable name="total-cadiz-envios" select="count($cadiz-envios)"/>
                    <xsl:variable name="porcentaje-urgentes" select="format-number(count($cadiz-envios-urgentes) div $total-cadiz-envios * 100, '0.00')"/>
                    <xsl:text>Hay </xsl:text>
                    <xsl:value-of select="count($cadiz-envios-urgentes)"/>
                    <xsl:text> envíos urgentes a Cádiz, que suponen el </xsl:text>
                    <xsl:value-of select="$porcentaje-urgentes"/>
                    <xsl:text>% de los </xsl:text>
                    <xsl:value-of select="$total-cadiz-envios"/>
                    <xsl:text> envíos totales registrados a Cádiz.</xsl:text>
                </xsl:template>
        
                <h3>C. Lista ordenada (por código de envío) con el tipo de prioridad, 
                    la provincia, el nombre y el apellido de todos los envío cuyo nombre 
                    comience por 'A' y tengan una prioridad 'Normal', o 
                    su apellido contenga una 'a' y la provincia sea 'Almería' o 'Granada'.
                </h3>
                <h5>Formato:<br/> 1.- (DBD72R - 24_horas - Granada). Carlos Cano.</h5>
                <br/>
                <br/>
        
                <xsl:for-each select="//envio[starts-with(nombre,'A') and prioridad='Normal'] | //envio[(provincia='Almería' or provincia='Granada') and contains(apellido,'a')]" >
                    <xsl:sort select="@codigo"/>
                    <xsl:variable name="posicion" select="position()" />
                    <ol>
                        <xsl:value-of select="concat($posicion, '.-','(',@codigo, prioridad, ' - ', provincia, '). ', nombre, ' ', apellido, '.')"/>
                    </ol>
                </xsl:for-each>

                <h3>D. Lista de todas las provincias (ordenadas alfabeticamente) con su 
                    número de envíos, ingresos totales (suma de todos sus precios) e 
                    ingreso medio</h3>
                <h5>Formato:<br/> Almería: 11 envíos. Ingresos totales: 229 euros. 
                    Ingreso medio: 20.82 euros.</h5>
                <br/>
                <br/>
         
                <xsl:key name="provincia" match="envio" use="provincia" />
  
                <xsl:template match="/">
                    <xsl:for-each select="//envio[generate-id() = generate-id(key('provincia', provincia)[1])]">
                        <xsl:sort select="provincia" />
                        <xsl:variable name="provincia" select="provincia" />
                        <xsl:variable name="envios" select="key('provincia', provincia)" />
                        <xsl:variable name="num_envios" select="count($envios)" />
                        <xsl:variable name="ingresos_totales" select="sum($envios/precio)" />
                        <xsl:variable name="ingreso_medio" select="format-number($ingresos_totales div $num_envios, '0.00')" />
                        <p>
                            <xsl:value-of select="$provincia" />
                            : <xsl:value-of select="$num_envios" /> envíos.
                            Ingresos totales: <xsl:value-of select="$ingresos_totales" /> euros.
                            Ingreso medio: <xsl:value-of select="$ingreso_medio" /> euros.
                        </p>
                    </xsl:for-each>
                </xsl:template>
  

                
                <h3>E. Crear una tabla, ordenada por fecha de entrega, de los envíos a 
                    Almería. La tabla incluirá las columnas: fecha de entrega, provincia, 
                    código de envío y prioridad. Estilos: La tabla deberá usar los estilos 
                    definidos en la plantilla que se proporciona en el ejercicio. Los 
                    elementos tabla y las celdas usarán los estilos de los selectores 
                    'table','th' y 'td'. La cabecera usará el estilo del selector 'th'. 
                    Si la prioridad de un envío es 'Urgente' esa celda usará el estilo del 
                    selector '.urgente'. Si la prioridad de un envío es 'Nocturno' esa 
                    celda usará el estilo del selector '.nocturno'.</h3>
                <h5>Formato:</h5>
                <table>
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Provincia</th>
                            <th>Código de envío</th>
                            <th>Prioridad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//envio[provincia='Almería']">
                            <xsl:sort select="fecha_entrega"/>
                            <tr>
                                <td>
                                    <xsl:value-of select="fecha_entrega"/>
                                </td>
                                <td>
                                    <xsl:value-of select="provincia"/>
                                </td>
                                <td>
                                    <xsl:value-of select="@codigo"/>
                                </td>
                                <td class="{prioridad}">
                                    <xsl:value-of select="prioridad"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

                <br/>
                <br/>
        
  






            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>