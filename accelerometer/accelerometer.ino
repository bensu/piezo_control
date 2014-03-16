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

#include "MMA7361.h"

/**
 * Pin defines. Library was developed on a Modern Device MMA7361 Module. The
 * G and Vin pins are attached to A1 and A2 respectively. Those pins output
 * a low and a high respectively. The 3 axes are attached to the next 3 pins,
 * A3, A4, A5.
 * 
 */
// #define GND_PIN A0
// #define VCC_PIN A5

#define X_PIN A2
#define Y_PIN A3
#define Z_PIN A4
#define AVERAGING_POINTS 256

MMA7361 accelo;

void setup()
{
    delay(250); //Allow the chip to stop shaking from the reset press
    
    Serial.begin(115200);
    // pinMode(VCC_PIN, OUTPUT);
    // pinMode(GND_PIN, OUTPUT);
    
    // digitalWrite(VCC_PIN, HIGH);
    // digitalWrite(GND_PIN, LOW);
    
    accelo = MMA7361();

    accelo.init(X_PIN, Y_PIN, Z_PIN,
        EXTERNAL, VREF_33, GS_15, AVERAGING_POINTS);

    //Print offsets to illustrate that offsets can be accessed
    Serial.print(accelo.offset[X_AXIS]);
    Serial.print(' ');
    Serial.print(accelo.offset[Y_AXIS]);
    Serial.print(' ');
    Serial.println(accelo.offset[Z_AXIS]);
}

/**
 * Print the value from each axis all on a single, comma delimited line
 * 
 */
void loop()
{
    float val;
    char otherChar;
    short int i;
    
    for (i = 0; i < 3; i++) {
        otherChar = ',';
        switch(i) {
            case 0:
                //val = accelo.getGs(X_AXIS);
                val = accelo.getRaw(X_AXIS);
                //val = accelo.getOffsetRaw(X_AXIS);
                break;
            
            case 1:
                //val = accelo.getGs(Y_AXIS);
                val = accelo.getRaw(Y_AXIS);
                //val = accelo.getOffsetRaw(Y_AXIS);
                break;
            
            case 2:
                //val = accelo.getGs(Z_AXIS);
                val = accelo.getRaw(Z_AXIS);
                //val = accelo.getOffsetRaw(Z_AXIS);
                otherChar = '\n';
                break;
        }
        Serial.print(val);
        Serial.print(otherChar);
    }
    delay(250);
}
