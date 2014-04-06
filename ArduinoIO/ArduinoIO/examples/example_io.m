%% Basic example for analog and digital IO and basic serial functions

% This is a very simple example that shows how to use the basic functions 
% for analog and digital IO as well as serial port

%% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('DEMO');
end

%% basic analog and digital IO

% specify pin mode for pins 4, 13 and 5
pinMode(a,4,'input');
pinMode(a,13,'output');
pinMode(a,5,'output');

% read digital input from pin 4
dv=digitalRead(a,4);

% output the digital value (0 or 1) to pin 13
digitalWrite(a,13,dv);

% read analog input from analog pin 5 (physically != from digital pin 5)
av=analogRead(a,5);

% normalize av from 0:1023 to 0:254
av=(av/1023)*254;

% ouptput value on digital (pwm) pin 5 (again, different from digital pin 5)
analogWrite(a,5,round(av))

% change reference voltage for analog pins to external
analogReference(a,'external');

% change it back to default
analogReference(a,'default');

%% some serial port -related commands

% gets the name of the serial port to which the arduino is connected to
serial(a)

% flushes the PC's serial input buffer (just in case)
flush(a);

% sends number 42 to the arduino and back (to see if it's still there)
roundTrip(a,42)

%% close session
delete(a)

% Copyright 2013 The MathWorks, Inc.