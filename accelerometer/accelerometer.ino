#include "Accelerometer.h"

#define X_PIN A0
#define Y_PIN A1
#define Z_PIN A2
#define AVERAGING_POINTS 256

#define GND_PIN 22

#define FILTER 50000

long int counter;

Acc acc = Acc(X_PIN, Y_PIN, Z_PIN);

void setup(void) {
    delay(250); //Allow the chip to stop shaking from the reset press
    
    Serial.begin(9600);
    Serial.println("Start");
    counter = 0;
}

/**
 * Print the value from each axis all on a single, comma delimited line
 * 
 */
void loop(void) {
    char otherChar;
    if (++counter > FILTER) {
        counter = 0;
        double sum = 0;
        for(int i=0; i<3; i++) {
            double value = Acc::to_v(acc.take_sample(AVERAGING_POINTS,i));
            otherChar = (i==2) ? '\n' : ',';
            Serial.print(value);
            Serial.print(otherChar);
            sum = sum + sq(value);
        }
        // Serial.println(sqrt(sum)); 
    }
}
