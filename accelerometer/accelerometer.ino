/**
 * Written by Christopher Meyer, July 2011
 * Version 1.0
 * 
 * Simple example for MMA7361 library.
 * 
 * Program will output a comma delimited reading of all three accelerometer
 * axis on the MMA7361.
 * 
 */

#include "Accelerometer.h"

/**
 * Pin defines. Library was developed on a Modern Device MMA7361 Module. The
 * G and Vin pins are attached to A1 and A2 respectively. Those pins output
 * a low and a high respectively. The 3 axes are attached to the next 3 pins,
 * A3, A4, A5.
 * 
 */
// #define GND_PIN A0
// #define VCC_PIN A5

#define X_PIN A0
#define Y_PIN A1
#define Z_PIN A2
#define AVERAGING_POINTS 256

#define GND_PIN 22

#define FILTER 50000

long int counter;
int i;

Accelerometer acc = Accelerometer(X_PIN, Y_PIN, Z_PIN);

void setup(void) {
    delay(250); //Allow the chip to stop shaking from the reset press
    
    Serial.begin(9600);
    Serial.println("Start");
    counter = 0;
    i = 0;
}

/**
 * Print the value from each axis all on a single, comma delimited line
 * 
 */
void loop(void) {
    char otherChar;
    short int i;
    i = 0;
    if (++counter > FILTER) {
        counter = 0;
        int value;
        
        switch (i) {
            case 0:
              value = analogRead(A0);
              break;
            case 1:
              value = analogRead(A1);
              break;
            case 2:
              value = analogRead(A2);
              break;
        }
        otherChar = (i==2) ? '\n' : ',';
        // i = (i + 1) % 3;
        Serial.print(value);
        Serial.print(otherChar);
    }
}
