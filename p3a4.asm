;Subrutina que realiza la comparación de dos numeros
            list    p=16F84A
            include <P16F84A.INC>

            org     0x0000              ;Se inicia en el origen 0
NumA        equ     0x0C                ;Variable del número A
NumB        equ     0x0D                ;Variable del número B
Mayor       equ     0x0E                ;Variable que almacenará el mayor de los números
            org     0x00                ;Vector de reset
            goto    Inicio              ;Salto incondicional al principio del programa
            org     0x05                ;Vector de interrupción
Inicio      call    Mayoromenor         ;Llamada a la subrutina
A_menor_B   movf     NumB,W              ;No, A es menor que B
            movwf   Mayor               ;Suma A más B
            goto    Stop                ;Salto incondicional al final del programa
A_mayor_B   movf    NumA,W              ;No, A es menor que B
            movwf   Mayor               ;Suma A más B
            goto    Stop                ;Salto incondicional al final del programa
A_igual_B   clrf    Mayor               ;Pone a 0 el resultado

Mayoromenor movf    NumB,W              ;NumB -> W (acumulador)
            subwf   NumA,W              ;A-W -> W
            btfsc   STATUS,Z            ;Bit de cero del registro de Estado a 1 0
            goto    A_igual_B           ;Si
            btfsc   STATUS,C            ;Bit de acarreo del registro de Estado a 1
            goto    A_mayor_B           ;Si
            goto    A_menor_B           ;No
            return                      ;Fin y retorno de la subrutina
Stop        nop                         ;Poner breakpoint de parada
            end                         ;Fin del programa fuente