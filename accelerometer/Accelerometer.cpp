
#include "Accelerometer.h"
#include "Arduino.h"
#include "Helpers.h"

Acc::Acc(int x_pin, int y_pin, int z_pin) {
	// Saves the pins internally. Follows order [x,y,z]
	PINS[0] = x_pin;
	PINS[1] = y_pin;
	PINS[2] = z_pin;

	// READING
    pinMode(PINS[0],INPUT);
    pinMode(PINS[1],INPUT);
    pinMode(PINS[2],INPUT);

	// Values found from previous calibration
	// MAX_A[0] = 1.81;
	// MAX_A[1] = 1.47;
	// MAX_A[2] = 2.08;

	// MIN_G[0] = -2.05;
	// MIN_G[1] = -2.13;
	// MIN_G[2] = -1.734;
}

int Acc::coord2int(Coord coord) {
	switch (coord) {
		case X:	return 0; break;
		case Y: return 1; break;
		case Z: return 2; break;
	}
}

Coord Acc::int2coord(int i) {
	switch (i) {
		case 0:	return X; break;
		case 1: return Y; break;
		case 2: return Z; break;
	}
}

void Acc::test_loop(void) {
	// WARNING: this function contains a hardcoded delay(500);
	// It prints the Raw readings (ints between 0 and 1023) of the
	// 3 axis of the accelerometers. When the accelerometer is stables
	// you should read stable values around half scale.

	// After initializing the object and a Serial port, put this 
	// in the loop() function
	// Ex. Code in the top
	// Acc acc = Acc(A0, A1, A2);
	// Ex. Code in setup()
	// Serial.begin(9600);

	for (char i = 0; i < 3; i++) {
        int n_read = take_sample(256,int2coord(i));
        Serial.print(n_read);
        Serial.print((i == 2) ? '\n' : ',');
    }
    // Makes the variables readable in the Serial Monitor
    delay(900);
}

int Acc::read_raw(Coord coord) {
	// returns one read of the axis coord_num
	return analogRead(PINS[coord2int(coord)]);
}

int Acc::take_sample(int average_points, Coord coord) {
	// takess n = average_points readings and returs their average for
	// the axis coord_num
	long int sum = 0;
	for(int i=0; i<average_points; i++) {
		sum = sum + read_raw(coord);
	}
	return sum/average_points;
}

double Acc::to_v(int n_read) {
	// takes a reading (with N bit precision) and returns the voltage between
	// 0 and 3.3
	return Helpers::line(MAX_V,MIN_V,MAX_N,MIN_N,n_read);
	// return ((MAX_V - MIN_V) * (double)(n_read - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_V;
}

double Acc::read_g(int average_points, int coord_num) {
	return 0;
	// return Helpers::line(MAX_G[coord_num],MIN_G[coord_num],3.3,MIN_V,to_v(take_sample(average_points,coord_num)));
	// return ((MAX_G[coord_num] - MIN_G[coord_num]) * (double)(take_sample(average_points,coord_num) - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_G[coord_num];
}

double Acc::to_g(int coord, int n_read) {
	// takes a reading (witn N bit precision) and returns the acceleration
	// meassured in gravity units
	double v_read = to_v(n_read);
	return Helpers::line(1,-1,V_READS[coord][2],V_READS[coord][0],v_read);
	// return ((MAX_G - MIN_G) * (double)(to_v(n_read) - MIN_V)) / (double)(3.3 - MIN_V) + MIN_G;
}

double Acc::to_ms2(int n_read) {
	// takes a reading (with N bit precision) and returns the acceleration
	// meassured in m/s2
	return 0;
	// return Helpers::line(MAX_A,MIN_A,MIN_N,MAX_N,n_read);
	// return ((MAX_A - MIN_A) * (double)(n_read - MIN_N)) / (double)(MAX_N - MIN_N) + MIN_A;
}