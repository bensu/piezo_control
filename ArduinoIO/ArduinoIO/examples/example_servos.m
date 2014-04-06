%% Basic example for servos

% This is a very simple example that shows how to use the basic functions 
% for servo motors. Note that if the Adafruit Motor Shield is mounted
% on top or the arduino Uno board, then only the servo attached 
% on pin #9 and #10 (respectively the inner and outer connectors on the 
% upper left corner of the motor shield) are easily accessible.

%% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('DEMO');
end

%% servo motors

% attach servo on pin #9
servoAttach(a,9); 

% return the status of servo on pin #9
servoStatus(a,9); 

% rotates servo on pin #9 to 100 degrees
servoWrite(a,9,100); 

% reads angle from servo on pin #9
val=servoRead(a,9);

% detach servo from pin #9
servoDetach(a,9); 

% return the status of servo on pin #9
servoStatus(a,9); 

%% close session
delete(a)

% Copyright 2013 The MathWorks, Inc.