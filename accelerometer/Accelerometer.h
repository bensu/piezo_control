#include "Arduino.h"

#ifndef ACCEL_H_

#define ACCEL_H_
// #define MAX_G 1.5
// #define MIN_G -1.5
#define MAX_A 14.7
#define MIN_A -14.7
#define MAX_V 3.3
#define MIN_V 0
#define MAX_N 1023
#define MIN_N 0

class Acc {
public:
	Acc(int x_pin, int y_pin, int z_pin);
	int read_raw(int coord_num);
	int take_sample(int average_points, int coord_num);
	static double to_v(int n_read);
	// static double to_g(int n_read);
	static double to_ms2(int n_read);
	double read_g(int average_points, int coord_num);
private:
	static double line(double, double, double, double, double);
	int PINS[3];
	double MAX_G[3];
	double MIN_G[3];
};

#endif