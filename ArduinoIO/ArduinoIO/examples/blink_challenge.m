%% Blink Challenge

% The "blink_challenge" is described in the last part of the Ladyada Arduino 
% tutorial, http://www.ladyada.net/learn/arduino/ and it consists in designing 
% a circuit (and programming the board) so that the resulting device has 5 
% LEDs (connected to the digital outputs 9 to 13) and 4 modes (the user can 
% switch among them using a button connected to digital input #2):
% 
% Mode 1: All LEDs Off
% Mode 2: All LEDs On
% Mode 3: LEDs blinking simultaneously with variable frequency regulated 
%         by a potentiometer
% Mode 4: LEDs blinking one after the other (wave like) with variable speed 
%         regulated by a potentiometer
% 
% Note that the arduino must be connected in order to run this demo,
% you can use the command: a.connect('DEMO') if you don't have the 
% actual hardware.
% Also note that if the variable delay is set (with the potentiometer) to
% high values, it might be necessary to keep the button pressed longer to
% change mode. Finally, the schematics for the blink challenge is shown in
% blink_challenge_sch.mdl

%   Copyright 2011 The MathWorks, Inc.

%% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('DEMO');
end

%% initialize pins
disp('Initializing Pins ...');

% sets digital input pins
a.pinMode(2, 'INPUT'); 
a.pinMode(3, 'INPUT'); 
a.pinMode(4, 'INPUT'); 
a.pinMode(7, 'INPUT'); 
a.pinMode(8, 'INPUT'); 
  
% sets digital and analog (pwm) output pins   
a.pinMode(5, 'OUTPUT'); % pwm available here
a.pinMode(6, 'OUTPUT'); % pwm available here
a.pinMode(9, 'OUTPUT'); % pwm available here
a.pinMode(10,'OUTPUT'); % pwm available here
a.pinMode(11,'OUTPUT'); % pwm available here
a.pinMode(12,'OUTPUT'); 
a.pinMode(13,'OUTPUT'); 

% button pin and analog pin
bPin=2;aPin=2;

% initialize state
state=0;
% get previous state
prev=a.digitalRead(bPin);

%% start loop
disp('Starting main loop (it will last 60 secs)');
disp('push button to change state ...');

% loop for 1 minute
tic
while toc/60 < 1
    
    % read analog input
    ain=a.analogRead(aPin);
    v=100*ain/1024;
    
    % read current button value
    % note that button has to be kept pressed a few seconds to make sure
    % the program reaches this point and changes the current button value 
    curr=a.digitalRead(bPin);
    
    % button is being released, change state
    % delay corresponds to the "on" time of each led in state 3 (wave)
    if (curr==1 && prev==0),
        state=mod(state+1,4);
        disp(['state = ' num2str(state) ', delay = ' num2str(v/200)]);
    end
    
    % toggle state all on or off
    if (state<2),
        for i=9:13,
            a.digitalWrite(i,state);
        end
    end
    
    % blink all leds with variable delay
    if (state==2),
        for j=0:1,
            % analog output pins
            for i=9:11,
                a.analogWrite(i,20*(i-8)*j);
            end
            % digital output only pins
            for i=12:13,
                a.digitalWrite(i,j);
            end
            pause((15*v*(1-j)+4*v*j)/1000);
        end
    end
    
    % wave
    if (state==3),
        for i=4:8,
            a.digitalWrite(9+mod(i,5),0);
            a.digitalWrite(9+mod(i+1,5),1);
            pause(v/200);
        end
        a.digitalWrite(13,0);
    end
    
    % update state
    prev=curr;
    
end

%% turn everything off
for i=9:13, a.digitalWrite(i,0); end

