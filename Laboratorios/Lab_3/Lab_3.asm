; Microprocesadores 2022 - 1er Semestre
; Brian Lorenzo
				    

;		    L A B   3 


; Definiciones

.def temp = r16			    ; variable temporal 
.def contador = r17		    ; para contar las veces que hace overflow timer0
.def ON = r18			    ; config de prender los leds (en PORTB)


.org 0x00
rjmp _setup			    ; jmp usa 2 ciclos de cpu, rjmp solo 1

.org 0x0008
rjmp _isr_botones
				    
.org 0x20			    ; dirección mp de interrupción por Timer 0 
rjmp _isr_timer0		    ; (si fuera por comparacion con compA seria 0x1C)
				    ; cuando interrumpe ejecuta el jmp 


_setup: 

    ldi temp, 0b11111111
    out DDRB, temp		    ; PORTB como salida

    ldi ON, 0b00111100		    ; bits 5,4,3,2 de PORTB son los leds
    
; Config Timer0
    ldi temp,  0b00000101
    out TCCR0B, temp		    ; configuro preescaler - Table 14-9
    ;			    TCCR0B
    ; ........................................................
    ; || FOC0A | FOC0B | - | - | WGM02 | CS02 | CS01 | CS00 ||
    ; ........................................................
    ; ||  b7   |  b6   | b5|b4 |   b3  |  b2  |  b1  |  b0  ||
    ;
    ; "Clock Selector" CS<CS02,CS01,CS00> = 101 = Prescaler 1:1024 (el máximo)
     
    sbi TIMSK0, 1		    ; configuro TOIE0 (Timer Overflow Interrupt Enable) 
				    ; para que interrumpa por overflow

    clr temp
    out TCNT0, temp		    ; inicializo el contador del Timer0 en 0
    
    
    
; Config Botones
    ; Los botones están en PC<1:3> a ellos se les asocia PCINT<9:11>
    ; el registro PCMSK1 contiene la habilitación de interrupción de los pines
    ; 8-15. Entre ellos los correspondientes a los botones. Habilito con 1 los 
    ; pines correspondientes a los PCMSK1<1:3>
    
    ldi temp, 0b00001110
    out PCMSK1, temp	    ; habilito interrupciones en los pines PORTC<1:3>
    sbi PCICR,1		    ; habilito interrupciones por cambio de botones
    
    clr PORTC		    ; defino todos los pines como entrada (en especial los botones)
    
; Habilito interrupciones generales
    sei 

   
_main:
   
   nop
   rjmp _main           
  
   
   
_isr_timer0: 
   in temp, SREG	    ; Salvar contexto: temp = SREG
   
   inc contador		    ; cada vez que interrumpe incrementamos contador
   cpi contador, 125	    ; comparamos contador con 61
   brne PC+2		    ; si no es 61 salimos de la isr
   clr contador		    ; si es 61 reseteamos contador y salimos de la int
   
   
   out SREG,temp			; Salvar contexto: SREG = temp
   reti						

_isr_botones:
    in temp,SREG			; Salvar contexto: temp = SREG
    
    
    sbis PORTC, 1	    ; Chequeo el cambio del boton S1
    rjmp _but1_off	    ; PORTC<1> = 0  - No presionado
    rjmp _but1_on	    ; PORTC<1> = 1  - Presionado
    
    sbis PORTC, 1	    ; Chequeo el cambio del boton S2
    rjmp _but2_off	    ; PORTC<2> = 0  - No presionado
    rjmp _but2_on	    ; PORTC<2> = 1  - Presionado
    
    sbis PORTC, 1	    ; Chequeo el cambio del boton S3
    rjmp _but3_off	    ; PORTC<3> = 0  - No presionado
    rjmp _but3_on	    ; PORTC<3> = 1  - Presionado
    
    _but1_on:
	
    _but2_on:
    
    _but3_on:
    
    _but1_off:
    _but2_off:
    _but3_off:
    
    
    out SREG,temp
    reti

PCMSK1 int en cada pin chequear en layout PCINT 9:11
    
habilitar PCIE en PCICR el 1
    
    
    SBIC    btsc 
    SBIS    btss