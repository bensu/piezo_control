#include "Accelerometer.h"
#include "Piezo.h"
#include "Helpers.h"

#define X_PIN A0
#define Y_PIN A1
#define Z_PIN A2
#define AVERAGING_POINTS 256

#define CYCLE 333
#define FILTER 50000

int enable_pin = 10;
int dir_pin = 7;

Acc acc = Acc(A0, A1, A2);
Piezo piezo = Piezo(dir_pin,enable_pin);    

int counter = 0;
int value = 4;
int sign = 1;
int dc;
bool boolean_val;

float f = 2.1;
int V = 150;

void setup(void) {
    TCCR2B = TCCR2B & 0b11111000 | 0x01;
    delay(250); //Allow the chip to stop shaking rfom the reset press
    
    pinMode(enable_pin,OUTPUT);
    pinMode(dir_pin,OUTPUT);
    // analogWrite(10, 240);
    // digitalWrite(7, LOW);
    // piezo.apply_voltage(150);
    // digitalWrite(enable_pin, HIGH);
    // analogWrite(enable_pin,127);
    boolean_val = false;
    dc = CYCLE/2;
    // digitalWrite(enable_pin, HIGH);

    Serial.begin(9600);
}

void loop(void) {

    // acc.test_loop();
    // piezo.actuate_sin(V,f);
    digitalWrite(dir_pin, HIGH);
    analogWrite(enable_pin, 220);
    // digitalWrite(dir_pin, HIGH);


    // if (counter > 100) {
    //     counter = 0;
    //     if (value == (MAX_NUM - 1) || value == 2) {
    //         sign = -sign;
    //     }
    //     value = (value + sign*1) % MAX_NUM;
    //     analogWrite(enable_pin,value);
    // } else {
    //     counter = counter + 1;
    // }

    // boolean_val = false;
    // digitalWrite(enable_pin, boolean_val ? HIGH : LOW);
    // delay(CYCLE-dc); //Allow the chip to stop shaking rfom the reset press
    // boolean_val = true;
    // digitalWrite(enable_pin, boolean_val ? HIGH : LOW);
    // delay(dc);

    // // int g_read = acc.read_raw(2);
    // double g_read = acc.to_g(2,acc.read_raw(Z));
    // bool control_bool = (g_read > 0);
    // // digitalWrite(enable_pin, control_bool);
    // Serial.println(g_read);
    // delay(330);
}


