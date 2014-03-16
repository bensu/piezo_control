/**
 * MMA7361.h - MMA7361 Accelerometer Library
 * Written by Christopher Meyer, July 2011
 * Version 1.0
 * 
 * See notes in .cpp file for more information on library.
 * 
 */
#ifndef MMA7361_h
#define MMA7361_h

#define GS_15 15
#define GS_90 90

#define VREF_33 33
#define VREF_50 50

#define X_AXIS 0
#define Y_AXIS 1
#define Z_AXIS 2

#define INTERREAD_DELAY_MS 10
#define BAD_AXIS_VAL 0xFFFFFFFF

//Scale values by 16 to increase precision while still using ints
#define VALUE_SCALE 16

#define MID_POINT_33 512
#define XY_BITS_ZERO_33 8192//512 * 16

//Resolution of 1 bit at 3.3V and 1.5g, 3.3V/1024 * 1g/0.8V = 0.00403 g/b
//Scaled by 4 to lose less precision, 4 because right shift 2 is easier than div
//1g * 800mV/g = 800mV; 0.8V * 1024 / 3.3V =  248.24; (248.24 + 512) * 16 = 12163.8788
#define Z_BITS_ZERO_33_15 12164
//b/g = (b/V)*(V/g) = 1024 / 3.3V * 0.8V / 1g = 248.24 b/g; 248.24 * 16 = 3971.8788
#define G_CONVERSION_33_15 3971.8788

//Resolution of 1 bit at 3.3V and 9g, 3.3V/1024 * 1g/0.206V = 0.0156 g/b
//1g * 206mV/g = 206mV; 0.206V * 1024 / 3.3V = 63.92; (63.92 + 512) * 16 = 9214.759
#define Z_BITS_ZERO_33_90 9215
//b/g = (b/V)*(V/g) = 1024 / 3.3V * 0.206V / 1g = 63.92 b/g; 63.92 * 16 = 1022.7588
#define G_CONVERSION_33_90 1022.7588

#define MID_POINT_50 338
#define XY_BITS_ZERO_50 5407 //(3.3V / 2) * 1024 / 5V = 337.92V; 337.92 * 16 = 5406.7

//Scaled by 4 to lose less precision, 4 because right shift 2 is easier than div
//Reference voltage is set to 5 volts
//Resolution of 1 bit at 5.0V and 1.5g, 5.0V/1024 * 1g/0.8V = 0.00610 g/b
//1g * 800mV/g = 800mV; 0.8V * 1024 / 5V = 163.84; (163.84 + 337.92) * 16 = 8028.16
#define Z_BITS_ZERO_50_15 8028
//b/g = (b/V)*(V/g) = 1024 / 5V * 0.8V / 1g = 163.84 b/g; 163.84 * 16 = 2621.44
#define G_CONVERSION_50_15 2621.44

//Resolution of 1 bit at 5.0V and 9g, 5.0V/1024 * 1g/0.206V = 0.0237 g/b
//1g * 206mV/g = 206mV; 0.206V * 1024 / 5V = 42.1889; (42.1889 + 337.92) * 16 = 6081.74
#define Z_BITS_ZERO_50_90 6082
//b/g = (b/V)*(V/g) = 1024 / 5V * 0.206V / 1g = 42.19 b/g; 42.19 * 16 = 675.0208
#define G_CONVERSION_50_90 675.0208

#include "Arduino.h"

class MMA7361
{
public :
    signed long offset[3];
    MMA7361();
    void init(int xPin, int yPin, int zPin, int refType, 
                int refVoltage, int gRange, unsigned long points);
    void setAveragePoints(unsigned long points);
    void calibrate();
    unsigned int getRaw(int axis);
    int getOffsetRaw(int axis);
    float getGs(int axis);
    
private:
    int _x_pin;
    int _y_pin;
    int _z_pin;
    
    int _adc_midpoint;
    int _xy_bits_zero;
    int _z_bits_zero;
    float _g_conversion;
    
    unsigned long _averagingPoints;

};

#endif