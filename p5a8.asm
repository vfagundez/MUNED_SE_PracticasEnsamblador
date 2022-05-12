;Subrutina denominada Retcs que genera un retardo de una centesima de segundo utilizando el temporizador TMR0.

                list    p=16F84A
                include <P16F84A.INC>

Inicio          org     0x0000
                call    Retcs
                goto    stop

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

