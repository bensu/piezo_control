# Active Vibration Control of a Cantilever Beam with Piezoelectric Materials

This project contains the entire source code for my Master Thesis for the a Masters in
Mechanical Engineering, with specialization in Mechatronics in ITBA.

The objective of the project is to stop induced vibrations on a cantilever beam by acting on it
with piezoelectric actuators. The system has the following components:

- The physical beam to be controlled.
- The piezoelectric actuators attached to the beam.
- An accelerometer attached to the beam to measure its vibrations.
- An Arduino interfacing between the actuators, the accelerometer, and a Desktop computer
implementing the control strategy.
- A software FEM model of the beam, the piezoelectric actuators, and the accelerometer.
- A software implementation of Kalman filters to correct the accelerometer's input.
- A software Control module that implements the PID control strategy.

## Contents

### Arduino Drivers

- `Accelerometer.cpp`: driver to read from accelerometer. API:
  * `int take_sample(int average_points, Coord coord)` samples the accelerometer's output.
  * `double read_g(int average_points, int coord_num)` samples the accelerometer's output and transforms it into physical units (m/s^2)
- `Piezo.cpp`: a C++ driver to manage piezoelectric actuator. API:
  * `void apply_voltage(float V)` starts applying a voltage to the actuator. Apply `0` to stop it.
  * `void actuate_square(float amp, float f)` applies a voltage of amplitude `amp` with a frequency of `f` (measured in Hz)
  * `void actuate_sin(float amp, float f)` applies a sine way with maximum amplitude of `amp` with a frequency of `f` (measured in Hz). It approximates the sine function with the build it `sin`.

### Simulation & Control

- `Run.m`: MATALAB class that serves as the main entry point of the application, initializing the FEM model, the Arduino interface, and the Controller
- `Controller.m`: MATLAB class to control the beam based on the accelerometer's readings and the piezoelectric's possible outputs. It uses a Kalman filter to improve the readings, a PID controller as its main control strategy, and a FEM model as a representation of the system to control
- `DSP.m`: MATLAB class to implement the Kalman filter and other Digital Signal Processing techniques (FFT for the prior analysis)
- `Arduino.m`: MATALAB class to interface with the Arduino controller
