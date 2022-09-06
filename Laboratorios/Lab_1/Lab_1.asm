; Microprocesadores 2022
; Brian Lorenzo
				    

;		    L A B   1 

.org 0x00			    ; jmp usa 2 ciclos de cpu, rjmp solo 1
rjmp _setup			    ; Sec 2.11 & 2.13 de Instruction Set Manual

; Se debe conocer previamente:
;	¿En qué puerto se encuentran los LEDs?  PORT B <5:2>
;	¿Cómo se configura el PORT B?		    DDRB
;	¿Tienen que ser salidas o entradas?	    Salidas
;	¿Qué implica que sean salidas?		    Impongo 0V ('0') ó 5V ('1')
;	¿Cómo configurar como salida?		    DDRB = 0bxxx1111xx
;	¿Cómo está armado el circuito de LEDs?  Ver D1-D4 en "modulo.jpg"
;	¿Cómo prendo los LEDs?                  Con 0V
;	¿Cómo impongo 0V a los LEDs?		    PORT B = 0bxxx0000xx
	 
; En "_setup" se busca resolver:
;	    Correcta configuración de los puertos de LEDs (como salida = '1')
;	    Correcto encendido de cada uno de los LEDs de forma secuencial ('0')
_setup:
    ldi r16,0xFF	; r16 = 11111111 (me interesan bit 5,4,3 y 2)
    out DDRB,r16	; Configuro PORTB como salida
    out PORTB,r16	; Inicializo LEDs apagados 
    
_main:  
    
    cbi PORTB, 2    ;Prendo LEDs uno por uno
    cbi PORTB, 3
    cbi PORTB, 4
    cbi PORTB, 5
    
    sbi PORTB, 2    ;Apago LEDs uno por uno
    sbi PORTB, 3
    sbi PORTB, 4
    sbi PORTB, 5
    
    rjmp _main	    ;Vuelvo al principio de la rutina (loop principal)
    ; Se podria loopear solo con sbi porque es un toggler pero prefiero que
    ; conozcan y de apropien de más y más instrucciones lo antes posible.

;=========================================    
; N U E V A S   I N S T R U C C I O N E S
;=========================================
;	* rjmp
;	* ldi
;	* out
;	* cbi
;	* sbi
;    
    
    