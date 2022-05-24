;Reloj que muestra una cuenta de segundos por el puerto B
;Subrutina denominada RetNcs que genera un retardo de N centesima de segundo 
;el numero de centesimas se pasara mediante el registro W
;Desactivar WATCHDOG en Configure>>Configuration Bits >>WDT off
                list    p=16F84A
                include <P16F84A.INC>

N               equ     0x0C            ;N Parametro para la subrutina (100cs=1s)
                goto    Inicio
                org     0x05            ;Vector de interrupcion
Retcs           bsf STATUS,RP0          ;Selección de la página 1
                movlw b'00000111'       ;Inicialización del registro OPTION con un divisor de frecuencia
                movwf OPTION_REG        ;de 256
                bcf INTCON,T0IF         ;Borrado del bit de fin de cuenta
                bcf STATUS,RP0          ;Selección de la página 0
                movlw 0x27              ;Complemento a 2 del número de ciclos
                sublw 0x00              ;0x00-0x27
                movwf TMR0              ;Inicialización del registro TMR0 con la resta anterior          
Bucle           btfss INTCON,T0IF       ;Comprobación del final de la cuenta
                goto Bucle              ;Si no es el final, se sigue esperando
                return

RetNcs          movwf N
Bucle3          call Retcs
                DECFSZ N,1              ; Decrementa N en una unidad, si es 0 salta
                goto Bucle3
                return

Inicio          bsf STATUS,RP0          ;Se pone a 1 el bit 5 RP0 de STATUS (03h) y se pasa a la página 1   
                movlw b'00000000'       ;Se carga 0 en w
                movwf TRISB             ;Se configura TRISB (06h) como salidas.
                bcf STATUS,RP0          ;Selección de la página 0
                clrf PORTB              ;Se limpia el puerto
                movlw d'100'            ;Se carga 100 en w

Bucle2          call RetNcs             ;Retardo de 1 segundo
                incf PORTB              ;Se incrementa en 1 unidad el contenido de PortB
                movlw d'100'
                goto Bucle2
                end