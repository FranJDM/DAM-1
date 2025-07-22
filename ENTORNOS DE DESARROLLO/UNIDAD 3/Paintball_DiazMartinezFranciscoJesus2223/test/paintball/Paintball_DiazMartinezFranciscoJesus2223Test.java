/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package paintball;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Fran
 */
public class Paintball_DiazMartinezFranciscoJesus2223Test {
    
    public Paintball_DiazMartinezFranciscoJesus2223Test() {
    }

    /* En este test indicamos que x=1 un valor que es válido. Indicamos que el
    nuevo valor esperado del cargador después de descargar una bala es de 19.
    Si hubiera algún problema también definimos la salida para la excepción que nos
    muestre por pantalla de que se trata */
     @Test
       public void testLimiteInferior() throws Exception {
        System.out.println("Test de prueba para comprobar el límite inferior");
        int cantidad = 1;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
        try {
        instance.descargar(cantidad);
        assertTrue(instance.municionCargada==19); 
        }catch (Exception e) { 
            fail ("Se ha producido una excepción no esperada: " +e);
        }
     }
         /* En este test indicamos que x=19 esto no debería de arrojar ningún error
       pues es un valor válido para descargar munición, además indicamos que el 
       nuevo valor del cargador después de esto es 1, pues hemos tomado como referencia 
       las 20 balas que contiene el cargador por defecto*/
        @Test
       public void testLimiteSuperior() throws Exception {
        System.out.println("Test de prueba para comprobar el límite superior");
        int cantidad = 19;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
        try {
        instance.descargar(cantidad);
        assertTrue(instance.municionCargada==1); 
        }catch (Exception e) { 
            fail ("Se ha producido una excepción no esperada: " +e);
        }
     }
       /* En este test indicamos que x=0 esto no es posible,porque no
       se pueden descargar 0 balas de un arma de paintball así que nos
       debería de devolver el resultado de la excepción definida en el método*/
       
    @Test
     public void testDescargarMunicionCero() throws Exception {
        System.out.println("Test de prueba para descargar 0 balas");
        int cantidad = 0;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
       try {
        instance.descargar(cantidad);
        fail("Intento de descargar 0 balas");
       } 
       catch (Exception e){
         System.out.println(e);
         assertTrue(instance.municionCargada==20);  
       }  
    }
    
       /* En este test indicamos que x=-1 esto no es posible, así que nos
       debería de devolver el resultado de la excepción definida en el método
     Al tomar por defecto el valor del cargador como 20, y requerir la comprobación
     de un valor límite, el -1 es un valor límite no válido*/
         @Test
       public void testLimiteInferiorNo() throws Exception {
        System.out.println("Test de prueba para comprobar el límite inferior, valor no válido");
        int cantidad = -1;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
        try {
        instance.descargar(cantidad);
            fail("Intento de descargar munición con valor negativo");
        }catch (Exception e) {
                        System.out.println(e);
           assertTrue(instance.municionCargada==20);
        }
     }
       
      /* En este test indicamos que x=21 esto no es posible, así que nos
       debería de devolver el resultado de la excepción definida en el método
     Al tomar por defecto el valor del cargador como 20, y requerir la comprobación
     de un valor límite, el 21 es un valor límite no válido pues supera las balas
       contenidas en el cargador */
            @Test
       public void testLimiteSuperiorNo() throws Exception {
        System.out.println("Test de prueba para comprobar el límite superior, valor no válido");
        int cantidad = 21;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
        try {
        instance.descargar(cantidad);
            fail("Intento de descargar más munición de la cargada actualmente");
        }catch (Exception e) {
                        System.out.println(e);
           assertTrue(instance.municionCargada==20);
        }
     }

        /* En este test indicamos que x=-4 esto no es posible, así que nos
       debería de devolver el resultado de la excepción definida en el método
       Se repite el caso del valor límite inferior no válido, que coincide por definición
       con este test*/
     @Test
     public void testDescargarMunicionNegativa() throws Exception {
        System.out.println("Test de prueba para descargar numero negativo de balas");
        int cantidad = -4;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
       try {
        instance.descargar(cantidad);
        fail("Intento de descargar número negativo de balas");
       } 
       catch (Exception e){
         System.out.println(e);
         assertTrue(instance.municionCargada==20);  
       }  
    }
     
       /* En este test indicamos que x=24 esto no es posible, así que nos
       debería de devolver el resultado de la excepción definida en el método
     Se repite el caso del valor límite superior, no se pueden descargar más balas
     de las que estan contenidas en el cargador en ese momento*/
     @Test
     public void testDescargarMunicionSuperiorActual() throws Exception {
        System.out.println("Test de prueba para descargar más balas de las que estan cargadas actualmente");
        int cantidad = 24;
        Paintball_DiazMartinezFranciscoJesus2223 instance = new Paintball_DiazMartinezFranciscoJesus2223(40,20);
       try {
        instance.descargar(cantidad);
        fail("Intento de descargar más balas de las que hay en el cargador");
       } 
       catch (Exception e){
         System.out.println(e);
         assertTrue(instance.municionCargada==20);  
       }  
    }
     
     
  
    }
    


    

