
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Source_Code.c,40 :: 		void interrupt(void){
;Source_Code.c,42 :: 		if(INTCON & 0x04){                                 // TMR0 overflow every 1 ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;Source_Code.c,44 :: 		if(!(PORTD&0B00001000)){
	BTFSC      PORTD+0, 3
	GOTO       L_interrupt1
;Source_Code.c,47 :: 		ldrflag=1;
	MOVLW      1
	MOVWF      _ldrflag+0
	MOVLW      0
	MOVWF      _ldrflag+1
;Source_Code.c,48 :: 		}else{
	GOTO       L_interrupt2
L_interrupt1:
;Source_Code.c,50 :: 		ldrflag=0;
	CLRF       _ldrflag+0
	CLRF       _ldrflag+1
;Source_Code.c,51 :: 		}
L_interrupt2:
;Source_Code.c,53 :: 		INTCON = INTCON & 0xFB;
	MOVLW      251
	ANDWF      INTCON+0, 1
;Source_Code.c,56 :: 		}
L_interrupt0:
;Source_Code.c,58 :: 		if(PIR1 & 0x04){
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt3
;Source_Code.c,59 :: 		if(flag==1){                                  // CCP1 interrupt
	MOVLW      0
	XORWF      _flag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt59
	MOVLW      1
	XORWF      _flag+0, 0
L__interrupt59:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;Source_Code.c,60 :: 		if(HL){
	MOVF       _HL+0, 0
	IORWF      _HL+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt5
;Source_Code.c,61 :: 		CCPR1H = angle >> 8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      _angle+1, 7
	MOVLW      255
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;Source_Code.c,62 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;Source_Code.c,63 :: 		HL = 0;                      //time low
	CLRF       _HL+0
	CLRF       _HL+1
;Source_Code.c,64 :: 		CCP1CON = 0x09;              // compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;Source_Code.c,65 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Source_Code.c,66 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Source_Code.c,67 :: 		}
	GOTO       L_interrupt6
L_interrupt5:
;Source_Code.c,69 :: 		CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;Source_Code.c,70 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;Source_Code.c,71 :: 		CCP1CON = 0x08;             // compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;Source_Code.c,72 :: 		HL = 1;                     //next time High
	MOVLW      1
	MOVWF      _HL+0
	MOVLW      0
	MOVWF      _HL+1
;Source_Code.c,73 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Source_Code.c,74 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Source_Code.c,75 :: 		}
L_interrupt6:
;Source_Code.c,77 :: 		PIR1 = PIR1&0xFB; }else{
	MOVLW      251
	ANDWF      PIR1+0, 1
	GOTO       L_interrupt7
L_interrupt4:
;Source_Code.c,79 :: 		PIR1 = PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;Source_Code.c,80 :: 		}
L_interrupt7:
;Source_Code.c,81 :: 		}
L_interrupt3:
;Source_Code.c,84 :: 		}
L_end_interrupt:
L__interrupt58:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Source_Code.c,86 :: 		void main(){
;Source_Code.c,87 :: 		TRISD=0B10111000;
	MOVLW      184
	MOVWF      TRISD+0
;Source_Code.c,88 :: 		TRISC=0X80;
	MOVLW      128
	MOVWF      TRISC+0
;Source_Code.c,89 :: 		TRISB=0X00;
	CLRF       TRISB+0
;Source_Code.c,90 :: 		TRISE=0X00;
	CLRF       TRISE+0
;Source_Code.c,91 :: 		PORTD=0X00;
	CLRF       PORTD+0
;Source_Code.c,92 :: 		PORTC=0X00;
	CLRF       PORTC+0
;Source_Code.c,93 :: 		PORTB=0X00;
	CLRF       PORTB+0
;Source_Code.c,94 :: 		PORTE=0X00;
	CLRF       PORTE+0
;Source_Code.c,97 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Source_Code.c,98 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Source_Code.c,99 :: 		HL = 1;
	MOVLW      1
	MOVWF      _HL+0
	MOVLW      0
	MOVWF      _HL+1
;Source_Code.c,100 :: 		CCP1CON = 0x08;        // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;Source_Code.c,101 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;Source_Code.c,102 :: 		INTCON = 0b11100000;         // Enable GIE and peripheral interrupts and TIMER0 interrupts
	MOVLW      224
	MOVWF      INTCON+0
;Source_Code.c,103 :: 		PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;Source_Code.c,104 :: 		CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
	MOVLW      7
	MOVWF      CCPR1H+0
;Source_Code.c,105 :: 		CCPR1L = 2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;Source_Code.c,108 :: 		OPTION_REG = 0x87; //  Set prescaler to 1:256, TIMER0 as timer
	MOVLW      135
	MOVWF      OPTION_REG+0
;Source_Code.c,109 :: 		TMR0 = 0;     // Preload value for ~1ms overflow
	CLRF       TMR0+0
;Source_Code.c,111 :: 		PORTD=0X00;
	CLRF       PORTD+0
;Source_Code.c,112 :: 		ATD_init() ;
	CALL       _ATD_init+0
;Source_Code.c,114 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Source_Code.c,115 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Source_Code.c,116 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Source_Code.c,118 :: 		button=1;
	MOVLW      1
	MOVWF      _button+0
	MOVLW      0
	MOVWF      _button+1
;Source_Code.c,119 :: 		servo=1;
	MOVLW      1
	MOVWF      _servo+0
	MOVLW      0
	MOVWF      _servo+1
;Source_Code.c,120 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;Source_Code.c,122 :: 		while(1){
L_main8:
;Source_Code.c,123 :: 		mode();
	CALL       _mode+0
;Source_Code.c,127 :: 		while(button){ //AUTOMATIC MODE
L_main10:
	MOVF       _button+0, 0
	IORWF      _button+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main11
;Source_Code.c,128 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Source_Code.c,129 :: 		mode();
	CALL       _mode+0
;Source_Code.c,130 :: 		PORTE = 0B00000001;
	MOVLW      1
	MOVWF      PORTE+0
;Source_Code.c,133 :: 		read_sonar();
	CALL       _read_sonar+0
;Source_Code.c,134 :: 		if(Distance<8){
	MOVLW      128
	XORWF      _Distance+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main61
	MOVLW      8
	SUBWF      _Distance+0, 0
L__main61:
	BTFSC      STATUS+0, 0
	GOTO       L_main12
;Source_Code.c,135 :: 		PORTC = PORTC & 0b11110111;
	MOVLW      247
	ANDWF      PORTC+0, 1
;Source_Code.c,136 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Source_Code.c,137 :: 		Lcd_Out(1, 1, "TANK IS EMPTY");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,138 :: 		PORTD=PORTD|0X01;
	BSF        PORTD+0, 0
;Source_Code.c,140 :: 		}else{
	GOTO       L_main13
L_main12:
;Source_Code.c,141 :: 		PORTD=PORTD & ~0X01;
	BCF        PORTD+0, 0
;Source_Code.c,142 :: 		}
L_main13:
;Source_Code.c,145 :: 		sRead=ATD_read(0);
	CLRF       FARG_ATD_read_port+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _sRead+0
	MOVF       R0+1, 0
	MOVWF      _sRead+1
;Source_Code.c,146 :: 		sRead= 100-( (sRead/1023.00) * 100 ) ;
	CALL       _int2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _sRead+0
	MOVF       R0+1, 0
	MOVWF      _sRead+1
;Source_Code.c,148 :: 		if(sRead<=34){
	MOVLW      128
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVF       R0+0, 0
	SUBLW      34
L__main62:
	BTFSS      STATUS+0, 0
	GOTO       L_main14
;Source_Code.c,149 :: 		if(Distance>=8){
	MOVLW      128
	XORWF      _Distance+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      8
	SUBWF      _Distance+0, 0
L__main63:
	BTFSS      STATUS+0, 0
	GOTO       L_main15
;Source_Code.c,150 :: 		PORTC = PORTC | 0x08;   //hbridge is connected IN1:RC0, IN2:RC3
	BSF        PORTC+0, 3
;Source_Code.c,151 :: 		}else{
	GOTO       L_main16
L_main15:
;Source_Code.c,152 :: 		PORTC = PORTC & 0b11110111;
	MOVLW      247
	ANDWF      PORTC+0, 1
;Source_Code.c,153 :: 		}
L_main16:
;Source_Code.c,154 :: 		}
L_main14:
;Source_Code.c,155 :: 		if(sRead>=60){
	MOVLW      128
	XORWF      _sRead+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      60
	SUBWF      _sRead+0, 0
L__main64:
	BTFSS      STATUS+0, 0
	GOTO       L_main17
;Source_Code.c,156 :: 		PORTC = PORTC & 0b11110111;
	MOVLW      247
	ANDWF      PORTC+0, 1
;Source_Code.c,157 :: 		}
L_main17:
;Source_Code.c,160 :: 		tRead=ATD_read(1);      //TEMPERATURE
	MOVLW      1
	MOVWF      FARG_ATD_read_port+0
	CALL       _ATD_read+0
	CALL       _int2double+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,161 :: 		tRead=(tRead / 1023) ;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,162 :: 		tRead = tRead * 5;  // Assuming 5V reference
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,164 :: 		tRead = tRead / 0.01;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      215
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      120
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,167 :: 		if(ldrflag==1 ||tRead>34 ){
	MOVLW      0
	XORWF      _ldrflag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      1
	XORWF      _ldrflag+0, 0
L__main65:
	BTFSC      STATUS+0, 2
	GOTO       L__main56
	MOVF       _tRead+0, 0
	MOVWF      R4+0
	MOVF       _tRead+1, 0
	MOVWF      R4+1
	MOVF       _tRead+2, 0
	MOVWF      R4+2
	MOVF       _tRead+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      8
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	GOTO       L_main20
L__main56:
;Source_Code.c,168 :: 		if(servo==0){
	MOVLW      0
	XORWF      _servo+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main66
	MOVLW      0
	XORWF      _servo+0, 0
L__main66:
	BTFSS      STATUS+0, 2
	GOTO       L_main21
;Source_Code.c,169 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,170 :: 		angle=5000;
	MOVLW      136
	MOVWF      _angle+0
	MOVLW      19
	MOVWF      _angle+1
;Source_Code.c,171 :: 		msDelay(1000);
	MOVLW      232
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      3
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,172 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;Source_Code.c,173 :: 		servo=1; }else{
	MOVLW      1
	MOVWF      _servo+0
	MOVLW      0
	MOVWF      _servo+1
	GOTO       L_main22
L_main21:
;Source_Code.c,174 :: 		servo=servo;}
L_main22:
;Source_Code.c,177 :: 		}else{
	GOTO       L_main23
L_main20:
;Source_Code.c,178 :: 		if(servo){
	MOVF       _servo+0, 0
	IORWF      _servo+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;Source_Code.c,179 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,180 :: 		angle=1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;Source_Code.c,181 :: 		msDelay(1000);
	MOVLW      232
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      3
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,182 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;Source_Code.c,183 :: 		servo=0;} else{servo=servo;}
	CLRF       _servo+0
	CLRF       _servo+1
	GOTO       L_main25
L_main24:
L_main25:
;Source_Code.c,185 :: 		}
L_main23:
;Source_Code.c,189 :: 		if(Distance>=8){
	MOVLW      128
	XORWF      _Distance+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      8
	SUBWF      _Distance+0, 0
L__main67:
	BTFSS      STATUS+0, 0
	GOTO       L_main26
;Source_Code.c,190 :: 		Lcd_Out(1, 1, "soil: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,191 :: 		IntToStr(sRead, myreadingsoil_out);
	MOVF       _sRead+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _sRead+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _myreadingsoil_out+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Source_Code.c,192 :: 		Lcd_Out(1, 7, myreadingsoil_out);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _myreadingsoil_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,193 :: 		Lcd_Out(2, 1, "temp: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,194 :: 		intToStr(tRead, myreadingtemp_out);
	MOVF       _tRead+0, 0
	MOVWF      R0+0
	MOVF       _tRead+1, 0
	MOVWF      R0+1
	MOVF       _tRead+2, 0
	MOVWF      R0+2
	MOVF       _tRead+3, 0
	MOVWF      R0+3
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _myreadingtemp_out+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Source_Code.c,195 :: 		Lcd_Out(2, 7, myreadingtemp_out);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _myreadingtemp_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,196 :: 		}else{
	GOTO       L_main27
L_main26:
;Source_Code.c,197 :: 		Lcd_Out(1, 1, "TANK IS EMPTY");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,198 :: 		}
L_main27:
;Source_Code.c,200 :: 		if(PORTD&0X10){
	BTFSS      PORTD+0, 4
	GOTO       L_main28
;Source_Code.c,201 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,202 :: 		angle=5000;
	MOVLW      136
	MOVWF      _angle+0
	MOVLW      19
	MOVWF      _angle+1
;Source_Code.c,203 :: 		msDelay(500);
	MOVLW      244
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,204 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;Source_Code.c,205 :: 		}
	GOTO       L_main29
L_main28:
;Source_Code.c,207 :: 		if(PORTD&0X20) {
	BTFSS      PORTD+0, 5
	GOTO       L_main30
;Source_Code.c,208 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,209 :: 		angle=1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;Source_Code.c,210 :: 		msDelay(500);
	MOVLW      244
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,211 :: 		flag=0; }
	CLRF       _flag+0
	CLRF       _flag+1
L_main30:
L_main29:
;Source_Code.c,213 :: 		msDelay(500);
	MOVLW      244
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,215 :: 		}
	GOTO       L_main10
L_main11:
;Source_Code.c,221 :: 		while(!button){  //MANUAL MODE
L_main31:
	MOVF       _button+0, 0
	IORWF      _button+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main32
;Source_Code.c,222 :: 		PORTE = 0B00000010;
	MOVLW      2
	MOVWF      PORTE+0
;Source_Code.c,223 :: 		PORTC = PORTC & 0b11110111;
	MOVLW      247
	ANDWF      PORTC+0, 1
;Source_Code.c,224 :: 		PORTD=PORTD & ~0X01;
	BCF        PORTD+0, 0
;Source_Code.c,226 :: 		mode();
	CALL       _mode+0
;Source_Code.c,227 :: 		sRead=ATD_read(0);
	CLRF       FARG_ATD_read_port+0
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _sRead+0
	MOVF       R0+1, 0
	MOVWF      _sRead+1
;Source_Code.c,228 :: 		sRead= 100-( (sRead/1023.00) * 100 ) ;
	CALL       _int2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      133
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _sRead+0
	MOVF       R0+1, 0
	MOVWF      _sRead+1
;Source_Code.c,231 :: 		tRead=ATD_read(1);
	MOVLW      1
	MOVWF      FARG_ATD_read_port+0
	CALL       _ATD_read+0
	CALL       _int2double+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,232 :: 		tRead=(tRead / 1023) ;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,233 :: 		tRead = tRead * 5;  // Assuming 5V reference
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,235 :: 		tRead = tRead / 0.01;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      215
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      120
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tRead+0
	MOVF       R0+1, 0
	MOVWF      _tRead+1
	MOVF       R0+2, 0
	MOVWF      _tRead+2
	MOVF       R0+3, 0
	MOVWF      _tRead+3
;Source_Code.c,238 :: 		Lcd_Out(1, 1, "soil: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,239 :: 		IntToStr(sRead, myreadingsoil_out);
	MOVF       _sRead+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _sRead+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _myreadingsoil_out+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Source_Code.c,240 :: 		Lcd_Out(1, 7, "        ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,241 :: 		Lcd_Out(1, 7, myreadingsoil_out);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _myreadingsoil_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,242 :: 		Lcd_Out(2, 1, "temp: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,243 :: 		intToStr(tRead, myreadingtemp_out);
	MOVF       _tRead+0, 0
	MOVWF      R0+0
	MOVF       _tRead+1, 0
	MOVWF      R0+1
	MOVF       _tRead+2, 0
	MOVWF      R0+2
	MOVF       _tRead+3, 0
	MOVWF      R0+3
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _myreadingtemp_out+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Source_Code.c,244 :: 		Lcd_Out(2, 7, "        ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_Source_Code+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,245 :: 		Lcd_Out(2, 7, myreadingtemp_out);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _myreadingtemp_out+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Source_Code.c,247 :: 		if(PORTD&0X10){
	BTFSS      PORTD+0, 4
	GOTO       L_main33
;Source_Code.c,248 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,249 :: 		angle=5000;
	MOVLW      136
	MOVWF      _angle+0
	MOVLW      19
	MOVWF      _angle+1
;Source_Code.c,250 :: 		msDelay(500);
	MOVLW      244
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,251 :: 		flag=0;
	CLRF       _flag+0
	CLRF       _flag+1
;Source_Code.c,252 :: 		}
	GOTO       L_main34
L_main33:
;Source_Code.c,254 :: 		if(PORTD&0X20) {
	BTFSS      PORTD+0, 5
	GOTO       L_main35
;Source_Code.c,255 :: 		flag=1;
	MOVLW      1
	MOVWF      _flag+0
	MOVLW      0
	MOVWF      _flag+1
;Source_Code.c,256 :: 		angle=1000;
	MOVLW      232
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;Source_Code.c,257 :: 		msDelay(500);
	MOVLW      244
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      1
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,258 :: 		flag=0; }
	CLRF       _flag+0
	CLRF       _flag+1
L_main35:
L_main34:
;Source_Code.c,261 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,262 :: 		}
	GOTO       L_main31
L_main32:
;Source_Code.c,264 :: 		}
	GOTO       L_main8
;Source_Code.c,266 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_mode:

;Source_Code.c,270 :: 		void mode(){
;Source_Code.c,272 :: 		if(PORTD & 0b10000000){
	BTFSS      PORTD+0, 7
	GOTO       L_mode36
;Source_Code.c,273 :: 		button++;
	INCF       _button+0, 1
	BTFSC      STATUS+0, 2
	INCF       _button+1, 1
;Source_Code.c,275 :: 		}
	GOTO       L_mode37
L_mode36:
;Source_Code.c,277 :: 		button=button;
;Source_Code.c,278 :: 		}
L_mode37:
;Source_Code.c,279 :: 		msDelay(100);
	MOVLW      100
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,280 :: 		if (button % 2 == 0) {
	MOVLW      2
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _button+0, 0
	MOVWF      R0+0
	MOVF       _button+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mode69
	MOVLW      0
	XORWF      R0+0, 0
L__mode69:
	BTFSS      STATUS+0, 2
	GOTO       L_mode38
;Source_Code.c,281 :: 		button = 0;
	CLRF       _button+0
	CLRF       _button+1
;Source_Code.c,282 :: 		} else {
	GOTO       L_mode39
L_mode38:
;Source_Code.c,283 :: 		button = 1;
	MOVLW      1
	MOVWF      _button+0
	MOVLW      0
	MOVWF      _button+1
;Source_Code.c,284 :: 		}
L_mode39:
;Source_Code.c,286 :: 		if(button){
	MOVF       _button+0, 0
	IORWF      _button+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_mode40
;Source_Code.c,287 :: 		rd2_bit=1;            ///// MODE OUTPUT ON RD3
	BSF        RD2_bit+0, BitPos(RD2_bit+0)
;Source_Code.c,288 :: 		}else{
	GOTO       L_mode41
L_mode40:
;Source_Code.c,289 :: 		rd2_bit=0;}
	BCF        RD2_bit+0, BitPos(RD2_bit+0)
L_mode41:
;Source_Code.c,290 :: 		msDelay(50);
	MOVLW      50
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,291 :: 		}
L_end_mode:
	RETURN
; end of _mode

_read_sonar:

;Source_Code.c,295 :: 		void read_sonar(void) {
;Source_Code.c,296 :: 		T1CON = 0x10;
	MOVLW      16
	MOVWF      T1CON+0
;Source_Code.c,298 :: 		Distance = 0;
	CLRF       _Distance+0
	CLRF       _Distance+1
;Source_Code.c,299 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;Source_Code.c,300 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;Source_Code.c,302 :: 		PORTC = PORTC | 0b01000000;          // Trigger the ultrasonic sensor (Rc6 connected to trigger)
	BSF        PORTC+0, 6
;Source_Code.c,303 :: 		msDelay(10);           // Keep trigger for 10uS
	MOVLW      10
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      0
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;Source_Code.c,304 :: 		PORTC = PORTC & 0b10111111;          // Remove trigger
	MOVLW      191
	ANDWF      PORTC+0, 1
;Source_Code.c,306 :: 		while (!(PORTC & 0b10000000));  // Wait until you start receiving the echo on rc7
L_read_sonar42:
	BTFSC      PORTC+0, 7
	GOTO       L_read_sonar43
	GOTO       L_read_sonar42
L_read_sonar43:
;Source_Code.c,307 :: 		T1CON = 0x19;          // TMR1 ON, Fosc/4 (1uS increment) with 1:2 prescaler
	MOVLW      25
	MOVWF      T1CON+0
;Source_Code.c,308 :: 		while (PORTC & 0b10000000);  // Wait until the pulse is received
L_read_sonar44:
	BTFSS      PORTC+0, 7
	GOTO       L_read_sonar45
	GOTO       L_read_sonar44
L_read_sonar45:
;Source_Code.c,309 :: 		T1CON = 0x18;          // TMR1 OFF, Fosc/4 (1uS increment) with 1:1 prescaler
	MOVLW      24
	MOVWF      T1CON+0
;Source_Code.c,311 :: 		Distance = ((TMR1H << 8) | TMR1L);  // Get the count from Timer 1
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
;Source_Code.c,313 :: 		Distance = (Distance * 34) / (1000 * 2);  // Calculate distance in cm
	MOVLW      34
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      208
	MOVWF      R4+0
	MOVLW      7
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
;Source_Code.c,316 :: 		if (Distance > 400) {
	MOVLW      128
	XORLW      1
	MOVWF      R2+0
	MOVLW      128
	XORWF      R0+1, 0
	SUBWF      R2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__read_sonar71
	MOVF       R0+0, 0
	SUBLW      144
L__read_sonar71:
	BTFSC      STATUS+0, 0
	GOTO       L_read_sonar46
;Source_Code.c,317 :: 		Distance = 0;  // Invalid distance, reset to 0
	CLRF       _Distance+0
	CLRF       _Distance+1
;Source_Code.c,318 :: 		}
L_read_sonar46:
;Source_Code.c,319 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;Source_Code.c,320 :: 		}
L_end_read_sonar:
	RETURN
; end of _read_sonar

_ATD_init:

;Source_Code.c,325 :: 		void ATD_init(void){
;Source_Code.c,326 :: 		ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
	MOVLW      65
	MOVWF      ADCON0+0
;Source_Code.c,327 :: 		ADCON1=0xC0;           // RA0 Analog, others are Digital, Right Allignment,
	MOVLW      192
	MOVWF      ADCON1+0
;Source_Code.c,329 :: 		}
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;Source_Code.c,331 :: 		int ATD_read(unsigned char port) {
;Source_Code.c,332 :: 		ADCON0 = (ADCON0 & 0xC7) | (port << 3);   // 11 000 111  +  port (0, 1)
	MOVLW      199
	ANDWF      ADCON0+0, 0
	MOVWF      R2+0
	MOVF       FARG_ATD_read_port+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      ADCON0+0
;Source_Code.c,333 :: 		Delay_ms(100);          //check datasheet???
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_ATD_read47:
	DECFSZ     R13+0, 1
	GOTO       L_ATD_read47
	DECFSZ     R12+0, 1
	GOTO       L_ATD_read47
	DECFSZ     R11+0, 1
	GOTO       L_ATD_read47
	NOP
;Source_Code.c,334 :: 		ADCON0 = ADCON0 | 0x04;   // 00 00 0 010
	BSF        ADCON0+0, 2
;Source_Code.c,335 :: 		while(ADCON0 & 0x04);
L_ATD_read48:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read49
	GOTO       L_ATD_read48
L_ATD_read49:
;Source_Code.c,336 :: 		return ((ADRESH << 8) | ADRESL);
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;Source_Code.c,337 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_msDelay:

;Source_Code.c,339 :: 		void msDelay(unsigned int msCnt) {
;Source_Code.c,340 :: 		unsigned int ms = 0;
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
;Source_Code.c,342 :: 		for (ms = 0; ms < msCnt; ms++) {
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
L_msDelay50:
	MOVF       FARG_msDelay_msCnt+1, 0
	SUBWF      msDelay_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay75
	MOVF       FARG_msDelay_msCnt+0, 0
	SUBWF      msDelay_ms_L0+0, 0
L__msDelay75:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay51
;Source_Code.c,343 :: 		for (cc = 0; cc < 155; cc++);  // 1ms delay loop
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
L_msDelay53:
	MOVLW      0
	SUBWF      msDelay_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay76
	MOVLW      155
	SUBWF      msDelay_cc_L0+0, 0
L__msDelay76:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay54
	INCF       msDelay_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_cc_L0+1, 1
	GOTO       L_msDelay53
L_msDelay54:
;Source_Code.c,342 :: 		for (ms = 0; ms < msCnt; ms++) {
	INCF       msDelay_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_ms_L0+1, 1
;Source_Code.c,344 :: 		}
	GOTO       L_msDelay50
L_msDelay51:
;Source_Code.c,345 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay
