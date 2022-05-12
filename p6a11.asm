;Subrutina que provoca una interrupción cada centesima de segundo utilizando 
;el temporizador
                list    p=16F84A
                include <P16F84A.INC>
                org     00h                         ; Vector de reset
                goto    inicio
                org     04h                         ; Vector de interrupción
                goto    interr                      ; Salto a la rutina de tratamiento de la interrupción
                org     05h

W_TEMP          equ     0x0C                ;Segundos
STATUS_TEMP     equ     0x0D                ;veces a sumar
inicio          
                movlw   b'10100000'
                movwf   INTCON                      ;Activamos la interrupcion de timeoverflow
inicioBucle     call    Int1cs                      ; Comienzo del programa principal
                goto    inicioBucle

                org     300h                        ; Ubicación de subrutinas genéricas
Int1cs          call    Retcs                       ; Llamada a la subrutina para esperar una centesima
                return

interr          
                movwf       W_TEMP                  ;Copia W a W_TEMP
                swapf       STATUS,0                ;Copia STATUS a W con intercambio de nibbles
                movwf       STATUS_TEMP             ;Guarda STATUS en STATUS_TEMP a través de 
                btfsc       INTCON,0                ;Comprobación flag interrupción por cambio en puerto B
                goto        portb_int
                btfsc       INTCON,1                ;Comprobación flag interrupción externa
                goto        ext_int
                btfsc       INTCON,2                ;Comprobación flag desbordamiento contador
                goto        timer_int
                btfsc       EECON1,4                ;Comprobación flag fin de escritura en EEPROM
                goto        eeprom_int
portb_int                                           ;Instrucciones tratamiento interrupción por cambio en puerto B
                
                swapf       STATUS_TEMP,0           ;Copia STATUS_TEMP a W con intercambio de nibbles
                movwf       STATUS                  ;Restaura STATUS_TEMP a STATUS a través de W
                swapf       W_TEMP,1                ;Copia W_TEMP en W_TEMP con intercambio de nibbles
                swapf       W_TEMP,0                ;Restaura W_TEMP a W con intercambio de nibble
                bcf         INTCON,0                ;Limpieza del bit de interrupción
                retfie
ext_int                                             ;Instrucciones tratamiento interrupción externa
                swapf       STATUS_TEMP,0           ;Copia STATUS_TEMP a W con intercambio de nibbles
                movwf       STATUS                  ;Restaura STATUS_TEMP a STATUS a través de W
                swapf       W_TEMP,1                ;Copia W_TEMP en W_TEMP con intercambio de nibbles
                swapf       W_TEMP,0                ;Restaura W_TEMP a W con intercambio de nibble
                bcf         INTCON,1                ;Limpieza del bit de interrupción
                retfie
timer_int                                           ;Instrucciones tratamiento interrupción por desbordamiento del timer
                swapf       STATUS_TEMP,0           ;Copia STATUS_TEMP a W con intercambio de nibbles
                movwf       STATUS                  ;Restaura STATUS_TEMP a STATUS a través de W
                swapf       W_TEMP,1                ;Copia W_TEMP en W_TEMP con intercambio de nibbles
                swapf       W_TEMP,0                ;Restaura W_TEMP a W con intercambio de nibble
                bcf         INTCON,2                ;Limpieza del bit de interrupción
                retfie
eeprom_int                                          ;Instrucciones tratamiento interrupción por fin escritura en EEPROM
                swapf       STATUS_TEMP,0           ;Copia STATUS_TEMP a W con intercambio de nibbles
                movwf       STATUS                  ;Restaura STATUS_TEMP a STATUS a través de W
                swapf       W_TEMP,1                ;Copia W_TEMP en W_TEMP con intercambio de nibbles
                swapf       W_TEMP,0                ;Restaura W_TEMP a W con intercambio de nibble
                bcf         EECON1,4                ;Limpieza del bit de interrupción
                retfie                              ; Instrucción para retorno del tratamiento de interrupción


Retcs           bsf     STATUS,RP0          ;Selección de la página 1
                movlw   b'00000111'         ;Inicialización del registro OPTION con un divisor de frecuencia
                movwf   OPTION_REG          ;de 256
                bcf     INTCON,T0IF         ;Borrado del bit de fin de cuenta
                bcf     STATUS,RP0          ;Selección de la página 0
                movlw   .39                ;Complemento a 2 del número de ciclos 
                sublw   0x0000              ;0x0000-39
                movwf   TMR0                ;Inicialización del registro TMR0 con la resta anterio
bucle           btfss   INTCON,T0IF           ;Espera de que el bit de fin de cuenta sea 1
                goto    bucle                  ;Se repite el bucle
                return

stop            nop
                end
