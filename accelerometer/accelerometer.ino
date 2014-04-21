#include "Accelerometer.h"

#define X_PIN A0
#define Y_PIN A1
#define Z_PIN A2
#define AVERAGING_POINTS 256

#define GND_PIN 22

#define FILTER 50000

long int counter;
int dc;
Acc acc = Acc(X_PIN, Y_PIN, Z_PIN);
int control_pin = 5;
bool boolean_val;
void setup(void) {
    // TCCR0B = _BV(CS00) | _BV(CS02);
    delay(250); //Allow the chip to stop shaking rfom the reset press
    // TIMER 3 - PINS 5, 3, and 2
    // TCCR3B = TCCR2B & 0b11111000 | 0x03;  // analogWrite(control_pin, 127);
    pinMode(control_pin,OUTPUT);
    digitalWrite(control_pin, HIGH);
    // analogWrite(control_pin,127);
    boolean_val = false;
    dc = 115;
    // digitalWrite(control_pin, HIGH);
}

/**
 * Print the value from each axis all on a single, comma delimited line
 * 
 */
void loop(void) {

   
    boolean_val = false;
    digitalWrite(control_pin, boolean_val ? HIGH : LOW);
    // analogWrite(control_pin,62);
    delay(330-dc); //Allow the chip to stop shaking rfom the reset press
    boolean_val = true;
    // analogWrite(control_pin,127);
    digitalWrite(control_pin, boolean_val ? HIGH : LOW);
    delay(dc);
    // analogWrite(control_pin,127);

}
