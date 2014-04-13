
#include "Accelerometer.h"
#include "Arduino.h"



Acc::Acc(int x_pin, int y_pin, int z_pin) {
	// Saves the pins internally. Follows order [x,y,z]
	PINS[0] = x_pin;
	PINS[1] = y_pin;
	PINS[2] = z_pin;

	// Values found from previous calibration
	// MAX_A[0] = 1.81;
	// MAX_A[1] = 1.47;
	// MAX_A[2] = 2.08;

	// MIN_G[0] = -2.05;
	// MIN_G[1] = -2.13;
	// MIN_G[2] = -1.734;
}

int Acc::read_raw(int coord_num) {
	// returns one read of the axis coord_num
	return analogRead(PINS[coord_num]);
}

int Acc::take_sample(int average_points, int coord_num) {
	// takess n = average_points readings and returs their average for
	// the axis coord_num
	long int sum = 0;
	for(int i=0; i<average_points; i++) {
		sum = sum + read_raw(coord_num);
	}
	return sum/average_points;
}

double Acc::to_v(int n_read) {
	// takes a reading (with N bit precision) and returns the voltage between
	// 0 and 3.3
	return 0;
	// return line(MAX_V,MIN_V,MIN_N,MAX_N,n_read);
	// return ((MAX_V - MIN_V) * (double)(n_read - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_V;
}

double Acc::read_g(int average_points, int coord_num) {
	return 0;
	// return line(MAX_G[coord_num],MIN_G[coord_num],3.3,MIN_V,to_v(take_sample(average_points,coord_num)));
	// return ((MAX_G[coord_num] - MIN_G[coord_num]) * (double)(take_sample(average_points,coord_num) - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_G[coord_num];
}

// double Acc::to_g(int n_read) {
// 	// takes a reading (witn N bit precision) and returns the acceleration
// 	// meassured in gravity units
// 	return ((MAX_G - MIN_G) * (double)(to_v(n_read) - MIN_V)) / (double)(3.3 - MIN_V) + MIN_G;
// }

double Acc::to_ms2(int n_read) {
	// takes a reading (with N bit precision) and returns the acceleration
	// meassured in m/s2
	return 0;
	// return line(MAX_A,MIN_A,MIN_N,MAX_N,n_read);
	// return ((MAX_A - MIN_A) * (double)(n_read - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_A;
}

double Acc::line(double max_y, double min_y, double min_x, double max_x, double x_val) {
	return (max_y - min_y) * (double)(x_val - min_x) / (double)(max_x - min_x) + min_y;
}