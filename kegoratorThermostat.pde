/*
  Kegerator Thermostat Version 1.01
  v1.00 Code complete
  v1.01 Adjusting delay times from 50000 to 40000
 
 
  The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD pin 1 to ground
 * LCD pin 2 to +5v
 * LCD pin 3 to 4.7K ohm res to ground

 * LM-34 Vout pin to Analog 0
 
 * Button up to digital pin 7
 * Button down to digital pin 8
 
 * Relay on digital pin 13

 */

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

// set pin numbers:
const int relay = 13;          // the number of the relay pin
const int buttonUpPin = 8;     // the number of the Temp Up pin
const int buttonDnPin = 7;     // the number of the Temp Down pin
const int tempPin = 0;         // analog temp sensor pin
// set wait values
// v1.01 Adjusting delay times from 50000 to 40000
const int maxOffWait = 40000;  // How many ms to wait to turn off
const int maxOnWait = 40000;   // How many ms to wait to turn on


// variables:
int setTemp = 50;              // variable storing the Set temp
int currTemp = 0;              // variable storing the actual, current temp
int tempTemp = 0;              // temporary temp
int buttonUpState = 0;         // variable for reading the pushbutton status
int buttonDnState = 0;         // variable for reading the pushbutton status
int tempIn = 0;                // get temperature variable
int flagOff = 0;               // flag for off delay loop
int flagOn = 0;                // flag for on delay loop


void setup() {
  // set up the LCD's number of rows and columns: 
  lcd.begin(16, 2);
  // initialize the pushbutton pins as input:
  pinMode(relay, OUTPUT);
  digitalWrite(relay, LOW);
  //digitalWrite(relay, HIGH);
  pinMode(buttonUpPin, INPUT);  
  pinMode(buttonDnPin, INPUT);  
  lcd.setCursor(0, 0);
  lcd.print("   Key Largo");  
  lcd.setCursor(0, 1);
  lcd.print("    Brewery");  
  delay(500);
  lcd.setCursor(0, 1);
  lcd.print("                "); 
}

void loop() {
  // Print header line of output
  lcd.setCursor(0, 0);
  lcd.print(" Current | Set  ");  
 
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  lcd.setCursor(3, 1);
  lcd.print(currTemp); 
  lcd.print("F  ");
  lcd.setCursor(9, 1);
  lcd.print("|");
  lcd.setCursor(11, 1);
  
  // Check buttons for set temp
  buttonUpState = digitalRead(buttonUpPin);
  if (buttonUpState == HIGH) {  
    // add 1 to setTemp
    setTemp++; 
    delay(250); 
  }
  buttonDnState = digitalRead(buttonDnPin);
  if (buttonDnState == HIGH) {     
    // subtr 1 from setTemp
    setTemp--;  
    delay(250);
  }
  lcd.print(setTemp); 
  lcd.print("F ");

  //Get the temp
  tempIn = analogRead(tempPin)/8.0;
  currTemp = (tempIn * 9)/ 5 + 32; // converts to fahrenheit  
  tempTemp = setTemp-1;

//Relay switch off logic (Anti-thrashing)
  if ((tempTemp > currTemp)&&(flagOff == 0)) {  
    flagOff = 1;
    }
  if ((flagOff != 0)&&(flagOff <= maxOffWait)){
    ++flagOff;
    }
  if (flagOff >= maxOffWait){
    // turn on relay
    lcd.setCursor(15, 1);
    lcd.print("Z");
    digitalWrite(relay, LOW);
    flagOff = 0;
    }
    
//Relay switch on logic (Anti-thrashing) 
  if ((setTemp < currTemp)&&(flagOn == 0)) {  
    flagOn = 1;
    }
  if ((flagOn != 0)&&(flagOn <= maxOnWait)){
    ++flagOn;
    }
  if (flagOn >= maxOnWait){
    // turn off relay
    lcd.setCursor(15, 1);
    lcd.print("&");
    digitalWrite(relay, HIGH);
    flagOn = 0;
    }
}


