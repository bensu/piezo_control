#include "Accelerometer.h"

#define X_PIN A0
#define Y_PIN A1
#define Z_PIN A2
#define AVERAGING_POINTS 256

#define GND_PIN 22

#define FILTER 50000

long int counter;

Acc acc = Acc(X_PIN, Y_PIN, Z_PIN);
int control_pin = 4;
bool boolean_val;
void setup(void) {
    // TCCR0B = _BV(CS00) | _BV(CS02);
    delay(250); //Allow the chip to stop shaking rfom the reset press
    // analogWrite(control_pin, 127);
    pinMode(control_pin,OUTPUT);
    // digitalWrite(control_pin, HIGH);
    // analogWrite(control_pin,127);
    boolean_val = false;
}

/**
 * Print the value from each axis all on a single, comma delimited line
 * 
 */
void loop(void) {

    delay(10); //Allow the chip to stop shaking rfom the reset press
    boolean_val = !boolean_val;
    digitalWrite(control_pin, boolean_val ? HIGH : LOW);
    // analogWrite(control_pin,127);

}
