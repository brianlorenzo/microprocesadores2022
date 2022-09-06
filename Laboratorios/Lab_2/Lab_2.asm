; Microprocesadores 2022
; Brian Lorenzo
				    

;		    L A B   2 

.org 0x00			    ; jmp usa 2 ciclos de cpu, rjmp solo 1
rjmp _setup			    ; Sec 2.11 & 2.13 de Instruction Set Manual

; Definiciones:
.def contador1 = r17		    ;Utilizado para decrementar Loop 1
.def contador2 = r18		    ;Utilizado para decrementar Loop 1
.def contador3 = r19		    ;Utilizado para decrementar Loop 1    
    
    
; Se debe conocer previamente:
;	Relación entre frecuencia y tiempo	f = 1/t
;	Frecuencia del reloj de la placa	16 MHz
;	Ciclos por instrucción			Tabla 4-2, 4-3, 4-4 
;						Instruction Set Manual
;	Entender como armar una rutina cíclica	Loop
;	Diferencias entre "rjmp" y "call"	Sec 2.11, 2.13
;	Cuantos ciclos de instrucción		8.000.000
;	ocupa 2Hz
;	Registro STATUS: Flag Z			Z=1 si resultado = 0
;	¿En qué puerto y pin está el buzzer?	PORTD <2> Ver "módulo.jpg"
    
; En "_setup" se busca resolver:
;	Mantener configuración de LEDs (LAB 1)
    

_setup:
    ldi r16,0xFF	; r16 = 11111111 (me interesan bit 5,4,3 y 2)
    out DDRB,r16	; Configuro PORTB como salida
    out PORTB,r16	; Inicializo LEDs apagados 
  
_main:
    ;==========================================================
    ; PARTE 1 - Prender LED a 2Hz
    ;==========================================================
    _parte_1:
    sbi PORTB,2		; Prendo LED
    call _delay		; Llamo al delay de 2Hz
    sbi PORTB,2		; Apago LED
    call _delay		; Llamo al delay de 2Hz
    rjmp _parte_1	; Vuelvo a rutina principal (loop principal)
    
    ;==========================================================
    ; PARTE 2 - Barrido LED (auto fantástico) y alarma
    ;==========================================================   
    _parte_2_leds:
    sbi PORTB,2		; Prendo LED 1
    call _delay		; Llamo al delay de 2Hz
    sbi PORTB,2		; Apago LED 1
    
    sbi PORTB,3		; Prendo LED 2
    call _delay		; Llamo al delay de 2Hz
    sbi PORTB,3		; Apago LED 2
    
    sbi PORTB,4		; Prendo LED 3
    call _delay		; Llamo al delay de 2Hz
    sbi PORTB,4		; Apago LED 3
    
    sbi PORTB,4		; Prendo LED 4
    call _delay		; Llamo al delay de 2Hz
    sbi PORTB,4		; Apago LED 4
    
    rjmp _parte_2_leds	; Loop
    
    _parte_2_alarma:
    sbi PORTD,4		; Prendo buzzer
    call _delay		; Llamo al delay de 2Hz
    sbi PORTD,4		; Apago buzzer
    call _delay		; Llamo al delay de 2Hz
    rjmp _parte_2_alarma
    
_delay:
    ldi contador1, 125	; Inicialización de valores de contadores
    ldi contador2, 255
    ldi contador3, 255

    _loop1:
	dec contador1		    ; Decremento contador1 en 1
	brne _loop2		    ; Si Z=0 (no es cero) -> Branch a _loop2
	ldi contador1, 125	    ; Si Z=1   (es cero)  -> recargo contador1
	ret			    ; y vuelvo del call
    
	_loop2:	    
	    dec contador2	    ; Decremento contador2 en 1
	    brne _loop3		    ; Si Z=0 (no es cero) -> Branch a _loop3
	    ldi contador2, 255	    ; Si Z=1  (es cero)   -> recargo contador2 y
	    rjmp _loop1		    ; jump a _loop2

	    _loop3:
		dec contador3	    ; Decrementa contador3 en 1
		brne _loop3	    ; Si Z=0 (no es cero) -> Branch a _loop3
		ldi contador3, 255  ; Si Z=1   (es cero)  -> recargo contador3 y 
		rjmp _loop2	    ; jump a _loop2
  
;=========================================    
; N U E V A S   I N S T R U C C I O N E S
;=========================================
;	* dec
;	* brne
;	* call
;	* ret