#include "Arduino.h"
#include "MMA7361.h"

#define SIZE 10
#define FILTER1 1000
#define FILTER2 100

MMA7361 * sensor = new MMA7361();

int flag = 0;
int flag2 = 0;
int count = 0;
int new_val;
int array[SIZE];

void setup (void) {
	sensor->init(2,3,4,DEFAULT,VREF_50,GS_15,10);
	Serial.begin(9600);
	// digitalWrite(A2, LOW);
	// pinMode(A2, INPUT);

	// for(int i=0; i<SIZE; i++) {
	// 	array[i] = 0;
	// }
}

void loop (void) {
	if (flag++ > FILTER1) {
		flag = 0;
		if (flag2++ > FILTER2) {
			flag2 = 0;
		
			unsigned int out = sensor->getRaw(X_AXIS);
			Serial.println(out);
			// if (count++ < SIZE) {
			// 	array[count] = analogRead(A2);
			// } else {
			// 	count = 0;
			// 	int sum = 0;
			// 	for(int i=0; i<SIZE; i++) {
			// 		sum += array[i];
			// 		array[i] = 0;
			// 	}
			// 	int out = sum/SIZE;
			// 	Serial.println(out);
			// }
		}
	} 
}