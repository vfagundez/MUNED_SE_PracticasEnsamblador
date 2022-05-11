; Utilizando el algoritmo de sumas parciales, diseñe un programa que multiplique
;dos números de 4 bits leídos desde el puerto A (anchura de 5 bits) y muestre el resultado en el
;puerto B (anchura 8 bits). De los cinco bits del puerto A, el más significativo indicará el
;número que se está introduciendo (NumA o NumB), y los otros cuatro bits indicarán el valor
;del número (se debe limpiar la parte alta, que se puede hacer con una AND con 0x0F). A
;continuación, se presenta un esquema del programa a realizar; la multiplicación deberá
;realizarse invocando a una subrutina

                list    p=16F84A
                include <P16F84A.INC>

                ORG     0x0000              ;El programa inicia en la dirección 0x0000 de la memoria
multiplicando   equ     0x0C                ;Dato a sumar
multiplicador   equ     0x0D                ;veces a sumar
DH              equ     0x0E                  ;byte alto
DL              equ     0x0F                  ;byte bajo
Inicio          bsf     STATUS, RP0         ;Acceso al banco 1
                clrf    TRISB               ;Las lineas del puerto B como salidas
                movlw   0x00                ;Valor para configurar los puertos (todos como salida) copiado al W
                movwf   TRISA               ;Las 5 lineas del puerto A como entradas
                bcf     STATUS, RP0         ;Acceso al banco 0
                goto    Principal

Principal       call    leerNumeros         ;Leemos el primer numero
                movf    multiplicando, W    ;Lo guardamos en el registro multiplicador
                andlw   0x0F                ;Limpiamos la parte alta
                movwf   multiplicando       ;Una vez hemos quitado el bit representativo, lo volvemos a guardar
                clrf    PORTA               ;Limpiamos el puerto A
                call    leerNumeros         ;Leemos el segundo numero
                call    multiplica          ;Vuelve al principio
                movwf   PORTB               ;El contenido de W se desposita en el Puerto B

leerNumeros     movf    PORTA, W            ;Carga el registro de datos del Puerto A en W
                btfsc   PORTA, 4            ;Si el bit 4 está en 1, guardamos el multiplicando
                movwf   multiplicando       ;en el registro multiplicando
                movwf   multiplicador       ;si no en el multiplicador
                return
multiplica      clrf    DH
                clrf    DL
                movf    multiplicador,W         ;W = multiplicador
                btfsc   STATUS,Z                ;Salta si Z=1
                goto    Stop                    ;Z=0 multiplicador=0
bucle           movf    DL,W                    ;W=DL
                addwf   multiplicando,W         ;W += multiplicando
                movwf   DL                      ;DL=W
                btfsc   STATUS,C                ;Salta si C=0
                incf    DH,F
resto           decfsz  multiplicador,F       ;multiplicador-1
                goto    bucle                   ;no hemos acabado
                return                        ;fin subrutina

Stop            nop                         ;Poner breakpoint de parada
                end                         ;Fin del programa fuente