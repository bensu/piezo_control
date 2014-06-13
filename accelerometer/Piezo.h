#include "Arduino.h"

#ifndef PIEZO_H_

#define PIEZO_H_
// #define MAX_G 1.5
// #define MIN_G -1.5
#define ADC_LIMIT 1023
#define MAX_ADC 1000
#define MIN_ADC 20
#define MAX_PV 150
#define MIN_PV 0


class Piezo {
public:
	Piezo(int dir_pin, int enable_pin);
	void apply_voltage(float V);
	void actuate_sin(float amp, float f);
	void actuate_square(float amp, float f);
private:
	int DIR_PIN ;
	int ENABLE_PIN;
	int counter;
};

#endif