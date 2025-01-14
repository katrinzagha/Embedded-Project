sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;



int button;
int Distance;
int sRead;
char myreadingsoil_out[7];
float tRead;
char myreadingtemp_out[7];
int HL;
int flag;
int ldrflag;
int angle;
int servo;
int MCLR;

void mode();
void read_sonar(void);
void ATD_init(void);
int ATD_read(char port);
void msDelay(unsigned int msCnt);





void interrupt(void){

 if(INTCON & 0x04){                                 // TMR0 overflow every 1 ms

         if(!(PORTD&0B00001000)){


             ldrflag=1;
             }else{

             ldrflag=0;
             }

         INTCON = INTCON & 0xFB;


     }

       if(PIR1 & 0x04){
       if(flag==1){                                  // CCP1 interrupt
             if(HL){
                       CCPR1H = angle >> 8;
                       CCPR1L = angle;
                       HL = 0;                      //time low
                       CCP1CON = 0x09;              // compare mode, clear output on match
                       TMR1H = 0;
                       TMR1L = 0;
             }
             else{                                          //low
                       CCPR1H = (40000 - angle) >> 8;       // 40000 counts correspond to 20ms
                       CCPR1L = (40000 - angle);
                       CCP1CON = 0x08;             // compare mode, set output on match
                       HL = 1;                     //next time High
                       TMR1H = 0;
                       TMR1L = 0;
             }

             PIR1 = PIR1&0xFB; }else{

              PIR1 = PIR1&0xFB;
             }
       }


 }

void main(){
TRISD=0B10111000;
TRISC=0X80;
TRISB=0X00;
TRISE=0X00;
PORTD=0X00;
PORTC=0X00;
PORTB=0X00;
PORTE=0X00;


TMR1H = 0;
TMR1L = 0;
HL = 1;
CCP1CON = 0x08;        // Compare mode, set output on match
T1CON = 0x01;
INTCON = 0b11100000;         // Enable GIE and peripheral interrupts and TIMER0 interrupts
PIE1 = PIE1|0x04;      // Enable CCP1 interrupts
CCPR1H = 2000>>8;      // Value preset in a program to compare the TMR1H value to            - 1ms
CCPR1L = 2000;


OPTION_REG = 0x87; //  Set prescaler to 1:256, TIMER0 as timer
TMR0 = 0;     // Preload value for ~1ms overflow

PORTD=0X00;
ATD_init() ;

Lcd_Init();
Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
Lcd_Cmd(_LCD_CLEAR); // clear LCD

button=1;
servo=1;
flag=0;

while(1){
mode();



while(button){ //AUTOMATIC MODE
Lcd_Cmd(_LCD_CLEAR);
mode();
PORTE = 0B00000001;

//distance check for the ultrasonic
read_sonar();
if(Distance<8){
PORTC = PORTC & 0b11110111;
Lcd_Cmd(_LCD_CLEAR);
Lcd_Out(1, 1, "TANK IS EMPTY");
PORTD=PORTD|0X01;

}else{
PORTD=PORTD & ~0X01;
}

// S read     SOIL
sRead=ATD_read(0);
sRead= 100-( (sRead/1023.00) * 100 ) ;

if(sRead<=34){
if(Distance>=8){
PORTC = PORTC | 0x08;   //hbridge is connected IN1:RC0, IN2:RC3
}else{
 PORTC = PORTC & 0b11110111;
}
       }
if(sRead>=60){
PORTC = PORTC & 0b11110111;
        }


tRead=ATD_read(1);      //TEMPERATURE
tRead=(tRead / 1023) ;
tRead = tRead * 5;  // Assuming 5V reference
// Convert voltage to temperature (LM35: 10mV/°C)
tRead = tRead / 0.01;


if(ldrflag==1 ||tRead>34 ){
               if(servo==0){
                flag=1;
               angle=5000;
               msDelay(1000);
               flag=0;
               servo=1; }else{
               servo=servo;}


}else{
             if(servo){
               flag=1;
               angle=1000;
               msDelay(1000);
               flag=0;
               servo=0;} else{servo=servo;}

}



if(Distance>=8){
Lcd_Out(1, 1, "soil: ");
IntToStr(sRead, myreadingsoil_out);
Lcd_Out(1, 7, myreadingsoil_out);
Lcd_Out(2, 1, "temp: ");
intToStr(tRead, myreadingtemp_out);
Lcd_Out(2, 7, myreadingtemp_out);
}else{
 Lcd_Out(1, 1, "TANK IS EMPTY");
}

 if(PORTD&0X10){
                flag=1;
                angle=5000;
                msDelay(500);
                flag=0;
                }
 else
     if(PORTD&0X20) {
                    flag=1;
                    angle=1000;
                    msDelay(500);
                    flag=0; }

msDelay(500);

}





while(!button){  //MANUAL MODE
PORTE = 0B00000010;
PORTC = PORTC & 0b11110111;
PORTD=PORTD & ~0X01;

mode();
sRead=ATD_read(0);
sRead= 100-( (sRead/1023.00) * 100 ) ;


tRead=ATD_read(1);
tRead=(tRead / 1023) ;
tRead = tRead * 5;  // Assuming 5V reference
// Convert voltage to temperature (LM35: 10mV/°C)
tRead = tRead / 0.01;


Lcd_Out(1, 1, "soil: ");
IntToStr(sRead, myreadingsoil_out);
Lcd_Out(1, 7, "        ");
Lcd_Out(1, 7, myreadingsoil_out);
Lcd_Out(2, 1, "temp: ");
intToStr(tRead, myreadingtemp_out);
Lcd_Out(2, 7, "        ");
Lcd_Out(2, 7, myreadingtemp_out);

 if(PORTD&0X10){
                flag=1;
                angle=5000;
                msDelay(500);
                flag=0;
                }
 else
     if(PORTD&0X20) {
                    flag=1;
                    angle=1000;
                    msDelay(500);
                    flag=0; }


msDelay(100);
}

}

}



 void mode(){

 if(PORTD & 0b10000000){
  button++;

  }
 else{
 button=button;
 }
 msDelay(100);
if (button % 2 == 0) {
    button = 0;
} else {
    button = 1;
}

 if(button){
  rd2_bit=1;            ///// MODE OUTPUT ON RD3
 }else{
 rd2_bit=0;}
 msDelay(50);
 }



 void read_sonar(void) {
     T1CON = 0x10;

    Distance = 0;
    TMR1H = 0;
    TMR1L = 0;

    PORTC = PORTC | 0b01000000;          // Trigger the ultrasonic sensor (Rc6 connected to trigger)
    msDelay(10);           // Keep trigger for 10uS
    PORTC = PORTC & 0b10111111;          // Remove trigger

    while (!(PORTC & 0b10000000));  // Wait until you start receiving the echo on rc7
    T1CON = 0x19;          // TMR1 ON, Fosc/4 (1uS increment) with 1:2 prescaler
    while (PORTC & 0b10000000);  // Wait until the pulse is received
    T1CON = 0x18;          // TMR1 OFF, Fosc/4 (1uS increment) with 1:1 prescaler

    Distance = ((TMR1H << 8) | TMR1L);  // Get the count from Timer 1

    Distance = (Distance * 34) / (1000 * 2);  // Calculate distance in cm

    // Handle unreasonable distance (e.g., too large)
    if (Distance > 400) {
        Distance = 0;  // Invalid distance, reset to 0
    }
     T1CON = 0x01;
}




void ATD_init(void){
      ADCON0=0x41;           // ON, Channel 0, Fosc/16== 500KHz, Dont Go
      ADCON1=0xC0;           // RA0 Analog, others are Digital, Right Allignment,

}

 int ATD_read(unsigned char port) {
     ADCON0 = (ADCON0 & 0xC7) | (port << 3);   // 11 000 111  +  port (0, 1)
     Delay_ms(100);          //check datasheet???
     ADCON0 = ADCON0 | 0x04;   // 00 00 0 010
     while(ADCON0 & 0x04);
     return ((ADRESH << 8) | ADRESL);
}

void msDelay(unsigned int msCnt) {
    unsigned int ms = 0;
    unsigned int cc = 0;
    for (ms = 0; ms < msCnt; ms++) {
        for (cc = 0; cc < 155; cc++);  // 1ms delay loop
    }
}