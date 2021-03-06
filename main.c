//**************************************************************************************************
//  Description: This is the project of the Embedded Systems Programming course.
//  The goal of the project is to make an echo device using PSoC. In particular,
//  Psoc is connected to PC using serial RS232 cable, and text inputted from the PC 
//  is displayed on LCD. Button is used to activate/deactivate the serial line communication, 
//  and the status of the line is show in LCD (offline / online)
//
//  Author: Nguyen Quang Vu
//  Student ID: 1005157
//  Helsinki Metropolia University of Applied Sciences
//  License: GPL
//  Version 1.0 from May 2012
//**************************************************************************************************
#include <m8c.h>
#include "PSoCAPI.h"  
#include "PSoCGPIOINT.h"

#define CLEAR 0x01
#define forever 1
#define statusButton (statusButton_Data_ADDR & statusButton_MASK)	

//Global variables
char bufChar[16];
char bufChar1[16];
int mode = 0;  // Integer variable for choosing online/offline mode
char *strPtr;

//Function prototypes
void initialize(void);
void buttonISR(void);
void displayLCD(void);
void echoText(void);

//****************************************************************************
//                          Main Function           
//****************************************************************************
void main(void){
    initialize();                 //Initializing the system
   
    while(forever) {
       if(UART_bCmdCheck() != 0){ // Checks if command terminator has been received
            strPtr = UART_szGetRestOfParams(); 
	        displayLCD();         // Display the text on the LCD   					
            echoText();           //Print the text back on the terminal/ echo the text
			UART_CmdReset();      // Reset command buffer  
	    }
   }//End forever loop
}//End main function

//*********************************************************************************
//                 Function for initializing the system
//*********************************************************************************
void initialize(void){
    UART_CmdReset();                      // Initialize receiver/cmd buffer
    UART_IntCntl(UART_ENABLE_RX_INT);     // Enable RX interrupts 
    UART_Start(UART_PARITY_NONE);         // Enable UART
	UART_CPutString("You can only type in a maximum of 32 characters at a time");
	UART_CPutString("\r\n");
   
    LCD_Start();                          // Initialize the LCD
    LCD_Position(0,5);
    LCD_PrCString("PSoC");
    LCD_Position(1,1);
    LCD_PrCString("FINAL PROJECT");
    
    M8C_EnableGInt ;                      // Turn on global interrupts
	M8C_EnableIntMask(INT_MSK0 , INT_MSK0_GPIO);
    
}

//***********************************************************************
//          Interrupt service routine for the status button
//***********************************************************************
#pragma interrupt_handler buttonISR
void buttonISR(void){
    if(statusButton && mode == 0){
	    UART_Stop();
	    LCD_Control(CLEAR);
		LCD_Position(0,0);
		LCD_PrCString("OFFLINE");
		mode = 1;
	}
	else if(mode == 1){
	    UART_Start(UART_PARITY_NONE);
		LCD_Control(CLEAR);
		LCD_Position(0,0);
		LCD_PrCString("ONLINE");
		mode = 0;
	}
}

//***********************************************************************
//                 Display the text on the LCD
//***********************************************************************
void displayLCD(void){
    unsigned int i;
	
    LCD_Control(CLEAR);
	for(i = 0; i < 16; i++){
	    bufChar[i] = strPtr[i];
	}
	LCD_Position(0,0);
	LCD_PrString(bufChar);
			
	for(i = 16; i < 33; i++){
	    bufChar1[i - 16] = strPtr[i];
	}
	LCD_Position(1,0);
	LCD_PrString(bufChar1);
}

//**********************************************************************
//               Echo the text back to the terminal
//**********************************************************************
void echoText(void){
    UART_PutString(strPtr);     
	UART_CPutString("\r\n");
}

