;subrutina que introduce un retardo de 5 ms
            list    p=16F84A
            include <P16F84A.INC>
reg1        equ     0x0C                ;Variable del reg1
reg2        equ     0x0D                ;Variable del reg2
reg3        equ     0x0E                ;Variable del reg3
Inicio      call    retardo             ;Llamada a la subrutina
            goto    Stop

retardo     movlw   .6                  ;(1ciclo) Asignacion de 6 a la variable W
            movwf   reg3                ;(1ciclo) y se pasa a la variable de retardo
externo     movlw   .24                 ;(1ciclo) Asignacion de 24 a la variable W
            movwf   reg2                ;(1ciclo) y se pasa a la variable de retardo
mitad       movlw   .35                 ;(1ciclo) Asignacion de 35 a la variable W
            movwf   reg1                ;(1ciclo) y se pasa a la variable de retardo
interno     decfsz reg1,1               ;(1 ciclo) Le resta una unidad a reg1 
            goto interno                ;(2 ciclo) Sigue decrementando hasta que reg1 llegue a 0
            decfsz reg2,1               ;(1 ciclo) Le resta una unidad a reg2 cuando reg1 llega a 0 
            goto mitad                  ;(2 ciclo) Vuelve a cargar reg1 y se repite la rutina interna
            decfsz reg3,1               ;(1 ciclo) Le resta una unidad a reg3 cuando reg2 llega a 0
            goto externo                ;(2 ciclo) Vuelve a cargar reg2 y reg1, se repite la rutina de la mitad
            return                      ;(2 ciclo) Termina la rutina y regresa

Stop        nop                         ;Poner breakpoint de parada
            end                         ;Fin del programa fuente
