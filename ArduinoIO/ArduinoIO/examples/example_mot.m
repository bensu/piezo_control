%% Example for dc and stepper motors (with Adafruit Motor Shield)

% This is a very simple example that shows how to use the functions for
% dc and stepper motors connected to the Arduino board via the Adafruit 
% Motor Shield. Remember that the functions for both dc and stepper motors 
% require the motor_v1.pde or motor_v2.pde sketch running on the Arduino
% board, which in turn require the adafruit motor library installed.
% See the Readme.txt file for more details.

%% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('DEMO');
end

%% DC motors (this requires both adafruit motor shield and AFMotor library installed)

% gets speed of motor 4 (upper right port on the motor shield)
motorSpeed(a,4)      

% sets speed of motor 4 as 200/255
motorSpeed(a,4,200)      

% prints the speed of all motors
motorSpeed(a);    
        
% runs motor 1 forward
motorRun(a,4,'forward');    
 
% runs motor 3 backward
motorRun(a,4,'backward');     

% release motor 1
motorRun(a,4,'release');      

%% Stepper motors (this requires both adafruit motor shield and AFMotor library installed)

% sets speed of stepper 2 as 50 rpm
stepperSpeed(a,1,50)      

% prints the speed of stepper 2
stepperSpeed(a,1);         

% rotates stepper 1 forward of 100 steps in interleave mode 
stepperStep(a,1,'forward','double',100);

% rotates stepper 2 backward of 50 steps in single mode 
stepperStep(a,1,'backward','single',50); 

% releases stepper 2
stepperStep(a,1,'release'); 

%% close session
delete(a)

% Copyright 2013 The MathWorks, Inc.
