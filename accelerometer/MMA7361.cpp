/**
 * MMA7361.h - MMA7361 Accelerometer Library
 * Written by Christopher Meyer, July 2011
 * Version 1.0
 * 
 * This library is used to interface an Arduino compatible system with an
 * MMA7361 accelerometer. After being initialized this library can produce
 * an averaged raw, offset, or g-reading for a given axis.
 * 
 * The sign of the force is directly related to the value of the value received 
 * from the ADC. Higher voltages received from the MMA7361 will always result in
 * greater values than lower voltage readings.
 * 
 * This library should be extensible to other accelerometers. The only changes
 * that will need to be made are to those calculating g-forces. The formulas 
 * used are listed in the header file with the voltage and g-range #defines.
 * 
 */

#include "MMA7361.h"
#include "Arduino.h"

/**
 * Populate the accelerometer variables to known values.
 * 
 * By setting the values to 0, the user should be aware if the system was not 
 * initiated.
 *
 */
MMA7361::MMA7361()
{
    _adc_midpoint = 0;
    _xy_bits_zero = 0;
    _z_bits_zero = 0;
    _g_conversion = 0;
    
    offset[X_AXIS] = 0;
    offset[Y_AXIS] = 0;
    offset[Z_AXIS] = 0;
}

/**
 * Initialize and calibrate the accelerometer
 * 
 * In addition to setting the pins for all 3 axes, reference voltage source,
 * reference voltage, g-range, and the number of points to average over the 
 * chip will be calibrated assuming that the chip is sitting on stationary and 
 * level surface.
 * 
 * Whenever the reference voltage is changed or g-range selector is modified,
 * this function will need to be re-run.
 * 
 * When an invalid value is received for refVoltage the default voltage will be
 * 3.3V. If an invalid value is received for gRange, the default is 1.5g.
 * 
 * Params
 * xPin -- Pin that the X-axis is attached to
 * yPin -- Pin that the Y-axis is attached to
 * zPin -- Pin that the Z-axis is attached to
 * refType -- Reference voltage source. Values used are the same as those used 
 *          by analogReference, e.g. DEFAULT, EXTERNAL, etc.
 * refVoltage -- Reference voltage level
 *          VREF_50 -- 5V Reference
 *          VREF_33 -- 3.3V Reference
 * gRange -- Force range
 *          GS_90 -- -9G to 9G
 *          GS_15 -- -1.5G to 1.5G
 * points -- Number of points to average when getting a reading of an axis
 * 
 */
void MMA7361::init(int xPin, int yPin, int zPin, 
    int refType, int refVoltage,
    int gRange,
    unsigned long points)
{
        
    analogReference(refType);
    _x_pin = xPin;
    _y_pin = yPin;
    _z_pin = zPin;
    
    //Make sure that pull up resistors on analog pins are off
    digitalWrite(_x_pin, LOW);
    digitalWrite(_y_pin, LOW);
    digitalWrite(_z_pin, LOW);
    
    //Make sure analog pins are inputs
    pinMode(_x_pin, INPUT);
    pinMode(_y_pin, INPUT);
    pinMode(_z_pin, INPUT);
    
    //Set the voltag and g-range specific conversion constants
    if (refVoltage == VREF_50) {
        _adc_midpoint = MID_POINT_50;
        _xy_bits_zero = XY_BITS_ZERO_50;
        
        if (gRange == GS_90) {
            _z_bits_zero = Z_BITS_ZERO_50_90;
            _g_conversion = G_CONVERSION_50_90;
        } else {
            _z_bits_zero = Z_BITS_ZERO_50_15;
            _g_conversion = G_CONVERSION_50_15;
        }
        
    } else {
        _adc_midpoint = MID_POINT_33;
        _xy_bits_zero = XY_BITS_ZERO_33;
        
        if (gRange == GS_90) {
            _z_bits_zero = Z_BITS_ZERO_33_90;
            _g_conversion = G_CONVERSION_33_90;
        } else {
            _z_bits_zero = Z_BITS_ZERO_33_15;
            _g_conversion = G_CONVERSION_33_15;
        }
    }
    
    _averagingPoints = points;
    
    calibrate();
}

/**
 * Set the number of points to average a raw read over
 * 
 * Params
 * points -- Number of points that will be averaged
 *
 */
void MMA7361::setAveragePoints(unsigned long points)
{
    _averagingPoints = points;
}

/**
 * Calculates and stores the offsets for all three axes.
 * 
 * The assumption is that the system is stationary and laying on a flat surface 
 * parallel to the surface of the earth (or whatever large mass the system is 
 * on. The default values are:
 *  x-axis -- 0g
 *  y-axis -- 0g
 *  z-axis -- +1g
 * 
 * The difference between the expected and actual readings are stored in the 
 * public array "offset"
 * 
 */ 
void MMA7361::calibrate()
{
    long tempOffset;
    unsigned long delayed;
    
    delayed = millis() + INTERREAD_DELAY_MS;
    while (millis() < delayed) {}
    delayed = millis() + INTERREAD_DELAY_MS;
    
    tempOffset = ((long(getRaw(X_AXIS)) << 4) - _xy_bits_zero) >> 4;
    offset[X_AXIS] = tempOffset;
    
    while (millis() < delayed) {}
    delayed = millis() + INTERREAD_DELAY_MS;
    
    tempOffset = ((long(getRaw(Y_AXIS)) << 4) - _xy_bits_zero) >> 4;
    offset[Y_AXIS] = tempOffset;
    
    while (millis() < delayed) {}
    
    //Assume chip is perpendicular to the earth. Z-force is 1g.
    tempOffset = ((long(getRaw(Z_AXIS)) << 4) - _z_bits_zero) >> 4;
    offset[Z_AXIS] = tempOffset;
}

/**
 * Returns the value received from the A/D pin for a given axis.
 * 
 * The value in the variable _averagingPoints is the number of samples taken and
 * averaged. This value can be changed by modifying setAveragingPoints().
 * 
 * If the axis is invalid, the returned value is BAD_AXIS_VAL.
 * 
 * Params
 * axis -- The axis to read. Valid valeus are:
 *      X_AXIS
 *      Y_AXIS
 *      Z_AXIS
 * 
 * Returns
 * Value received from the ADC. Values are not offset as the are raw.
 * 
 */
unsigned int MMA7361::getRaw(int axis)
{
    unsigned int pin;
    unsigned short i;
    unsigned long cumVal;
    
    switch (axis) {
        case X_AXIS:
            pin = _x_pin;
            break;
        case Y_AXIS:
            pin = _y_pin;
            break;
        case Z_AXIS:
            pin = _z_pin;
            break;
        default:
            return BAD_AXIS_VAL;
    }
        
    cumVal = 0;
    
    for (i = 0; i < _averagingPoints; i++) {
        cumVal = cumVal + analogRead(pin);
    }
    
    cumVal = cumVal / _averagingPoints;
    
    return int(cumVal);
}

/**
 * Returns the value received from the A/D pin offset where 0g is 0.
 * 
 * The value in the variable _averagingPoints is the number of samples taken and
 * averaged. This value can be changed by modifying setAveragingPoints().
 * 
 * If the axis is invalid, the returned value is BAD_AXIS_VAL.
 * 
 * Params
 * axis -- The axis to read. Valid values are:
 *      X_AXIS
 *      Y_AXIS
 *      Z_AXIS
 * 
 * Returns
 * ADC value offset where 0g is 0.
 * 
 */
int MMA7361::getOffsetRaw(int axis)
{
    return (getRaw(axis) - offset[axis] - 512);
}

/**
 * Returns the force in gs excerted on the chip on the given axis.
 * 
 * If an invalid axis is given BAD_AXIS_VAL will be returned.
 * 
 * The resolution for the value depends on the reference voltage and g-scale
 * used. The resolutions in g/b are as follows:
 * 
 *                      Voltage (V)
 *                  3.3         5.0
 * Scale    1.5     0.00403     0.0156
 * (g)      9.0     0.00610     0.0237
 *
 * Params
 * axis -- The axis to read. Valid valeus are:
 *      X_AXIS
 *      Y_AXIS
 *      Z_AXIS
 *
 * Returns
 * Floating point value of Gs exerted on the given axis.
 * 
 */
float MMA7361::getGs(int axis)
{
    float retVal;
    
    if (axis > Z_AXIS) {
        return BAD_AXIS_VAL;
    }
    
    retVal = float(getRaw(axis)) - offset[axis] - _adc_midpoint;
    retVal = (retVal * VALUE_SCALE / _g_conversion);
    
    return  retVal;    
}