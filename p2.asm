;Programa que lee la entrada del puerto A y lo refleja en el puerto B
;El programa deberá dormirse cuando los interruptores de entrada tengan la 
;configuración "11111".

                list    p=16F84A
                include <P16F84A.INC>

                ORG     0x0000              ;El programa inicia en la dirección 0x0000 de la memoria
NumVeces        equ     0x0C                ;Variable del número A
Contador        equ     0x0D                ;Variable del número B
Inicio          bsf     STATUS, RP0         ;Acceso al banco 1
                clrf    TRISB               ;Las lineas del puerto B como salidas
                movlw   0x00                ;Valor para configurar los puertos (todos como salida) copiado al W
                movwf   TRISA               ;Las 5 lineas del puerto A como entradas
                bcf     STATUS, RP0         ;Acceso al banco 0
                goto    IniciarContador

Principal       movf    PORTA, W            ;Carga el registro de datos del Puerto A en W
                movwf   PORTB               ;El contenido de W se desposita en el Puerto B
                goto    comprobarPORTA      ;Vuelve al principio

IniciarContador clrf    Contador            ;Reseteamos contador
                movlw   0x05                ;Valor para configurar el contador
                movwf   Contador            ;El contador se configura en la dirección 0x0D
                goto    Principal           ;Comprobamos el Puerto A

                                            ;Si el estado de portaA esta a 11111 finaliza el programa
comprobarPORTA  decfsz  Contador,F          ;Decrementa el contador 
                btfsc   PORTA,Contador      ;Ejecuta la siguiente instruccion si el bit del contador es 0
                goto    Principal           ;Vuelve al principio
                goto    ComprobarContador   ;Comprobamos que el contador no llega a 0
                
ComprobarContador
                movlw   .0                  ;for the check, if content of a register is 1, we load 1 into the W-register
                xorwf   Contador,W          ;exclusive-or of VarA with W, result in W
                btfsc   STATUS,Z            ;Z-Bit is set, if Contador = 0 in this case
                goto    Stop                ;execute SUBROUTINE, if Z-Bit is set
                goto    comprobarPORTA      ;Vuelve a comprobar el estado de los interruptores

ResetearContador clrf    Contador            ;Reseteamos contador
                movlw   0x05                ;Valor para configurar el contador
                movwf   Contador            ;El contador se configura en la dirección 0x0D
                goto    comprobarPORTA      ;Vuelve a comprobar el estado de los interruptores
Stop            nop                         ;Poner breakpoint de parada
                end                         ;Fin del programa fuente
