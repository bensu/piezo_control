#include "Piezo.h"
#include "Arduino.h"
#include "Helpers.h"

Piezo::Piezo(int dir_pin, int enable_pin) {
	// Saves the pins internally
	DIR_PIN = dir_pin;
	ENABLE_PIN = enable_pin;
	/* Arduino Mega: (tested on Arduino Mega 2560)
	timer 0 (controls pin 13, 4)
	timer 1 (controls pin 12, 11)
	timer 2 (controls pin 10, 9)
	timer 3 (controls pin 5, 3, 2)
	timer 4 (controls pin 8, 7, 6)*/
	// WRITING
    // TCCR0B = _BV(CS00) | _BV(CS02);	// Unknown
    // TCCR1B = TCCR1B & 0b11111000 | 0x00; // 0x01 sets Arduino Mega's pin 10 and 9 to frequency 31250.
    pinMode(DIR_PIN,OUTPUT);
    pinMode(ENABLE_PIN, OUTPUT);
    counter = 0;
}

void Piezo::apply_voltage(float V) {
	int aux = (abs(V) > MAX_PV) ? MAX_PV : abs(V);
	int amplitude = Helpers::line(MAX_ADC,MIN_ADC,MAX_PV,MIN_PV,aux) / 1;
	bool sign = (V > 0);
	// if (counter > 1000) {
	// 	counter = 0;
	// 	Serial.println(amplitude);
	// 	Serial.println(aux);
	// } else {
	// 	counter = counter + 1;
	// }

	// Reverse logic because we are producing the inverse function
	analogWrite(ENABLE_PIN,ADC_LIMIT-amplitude);
    digitalWrite(DIR_PIN, sign ? HIGH : LOW);
}

void Piezo::actuate_sin(float amp, float f) {
	// Should be in loop()
    float t = millis() / 1000.0;
    float V = amp*(sin(2*3.14*f*t));
    apply_voltage(V);
}
