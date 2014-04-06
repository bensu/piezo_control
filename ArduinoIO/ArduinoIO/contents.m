% ArduinoIO (a.k.a  "Tethered" MATLAB Support Package for Arduino)
% Version 4.4 (R2013a), G. Campa,  30-Aug-2013
% Copyright 2013 The MathWorks, Inc.
%
% This is a MATLAB class that allows performing Analog/Digital Input
% and Output with the Arduino Board from the MATLAB command line.
% Please read the file readme.txt for more info
%

% FILES:
%
% readme.txt              : file you should read before doing anything
% contents.m              : this file (needed for matlab help)
%
% arduino.m               : file that defines the arduino class
%
% pde/adio                : folder containing the adio.pde sketch
% pde/adioe               : folder containing the adioe.pde sketch
% pde/adioes              : folder containing the adioes.pde sketch
% pde/motor_v1            : folder containing the motor_v1.pde sketch
% pde/motor_v2            : folder containing the motor_v2.pde sketch
%
% examples                : folder containing a few examples, specifically:
% example_io.m            : IO example
% example_encoders.m      : Encoder example
% example_servos.m        : Servos example
% example_mot.m           : motor example
% blink_challenge.m       : blink challenge code
% blink_led_sim.mdl       : simplest simulink test
% blink_challenge_sch.mdl : blink challenge schematics
% blink_challenge_sim.mdl : blink challenge, simulink implementation
% blink_challenge_sf.mdl  : blink challenge, stateflow implementation
% library_test.mdl        : demo-mode test for all the library blocks
% servo_sim.mdl           : shows how to use the servo blocks
% encoder_sim.mdl         : shows how to use the encoders blocks
% motor_sim.mdl           : shows how to use the motor blocks
% stepper_sim.mdl         : shows how to use the stepper blocks
%
% simulink                : folder containing the simulink library and block s-functions
%

%
% HISTORY:
%
% Ver  1.0 - Jul 2009  - Initial Version
% Ver  1.1 - Aug 2009  - Readme.txt file added, additional checks on variables
% Ver  1.2 - Aug 2009  - Readme.txt and arduino_connect extensively rewritten
% Ver  1.4 - Aug 2009  - Additional checks and DEMO mode capability added
% Ver  1.5 - Aug 2009  - Change pin mode added and using fwrite instead of fprint
% Ver  1.7 - Sep 2009  - Many improvements in adiosrv.pde and functions help
% Ver  1.9 - Sep 2009  - Motor shield support and error check improvements
% Ver  1.A - Sep 2009  - Improvements to help and motor shield handling
% Ver  1.B - Sep 2009  - Improved connection, fixed demo mode bug
% Ver  2.0 - Oct 2009  - Rewritten using m-class objects
% Ver  2.1 - Feb 2010  - Display function added
% Ver  2.2 - Apr 2010  - Display function improved
% Ver  2.3 - Jun 2010  - Very minor corrections in the examples and in readme.txt
% Ver  2.4 - Jul 2010  - License files added, and delete function refined
% Ver  2.5 - Aug 2010  - Instructions for the Arduino Mega board included
% Ver  3.0 - Jun 2011  - Single server file adopted and Simulink library added
% Ver  3.1 - Oct 2011  - Assorted improvements to pde files and demo mode
% Ver  3.2 - Dec 2011  - Minor improvements in unexpected input handling
% Ver  3.3 - Aug 2012  - Existing workspace objects can now be used in Simulink
% Ver  3.4 - Aug 2012  - MEGA board fully supported
% Ver  3.8 - Aug 2012  - Servo support and interface greatly improved
% Ver  4.1 - Aug 2012  - Encoder support and other minor improvements
% Ver  4.2 - Aug 2012  - Encoder debouncing function added
% Ver  4.3 - Aug 2013  - Reorganized sketch handling and examples
% Ver  4.4 - Aug 2013  - Improved docs and added support for AFMotor Shield V2
