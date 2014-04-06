function msfun_arduino_analogwrite(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']
%   http://www.mathworks.com/access/helpdesk/help/toolbox/simulink/sfg/f7-67622.html
%

    %   Copyright 2011 The MathWorks, Inc.

% instance variables 
myArduino = [];
myPin = 0;

setup(block)

%%
    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 1;
        block.NumOutputPorts = 0;
        
        block.SetPreCompInpPortInfoToDynamic;
        block.InputPort(1).Dimensions        = 1;
        block.InputPort(1).DirectFeedthrough = false;
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 3; % arduino var
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(3).Data 0];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        % the ArduinoIO Setup block uses the Start method to initialize the arduino
        % connection; by using InitConditions, we ensure that we don't access
        % the variable before it is created
        
        block.RegBlockMethod('CheckParameters', @CheckPrms); % called during update diagram
        % block.RegBlockMethod('Start', @Start); % called first
        block.RegBlockMethod('PostPropagationSetup', @PostPropSetup); 
        block.RegBlockMethod('InitializeConditions', @InitConditions); % called second
        block.RegBlockMethod('Outputs', @Output); % called first in sim loop
        % block.RegBlockMethod('Update', @Update); % called second in sim loop
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function CheckPrms(block)        
        try
            validateattributes(block.DialogPrm(1).Data, {'char'}, {'nonempty'});  % Name of arduino instance
            validateattributes(str2double(block.DialogPrm(2).Data), {'numeric'}, {'real', 'scalar', 'nonnegative'}); % pin
            validateattributes(block.DialogPrm(3).Data, {'numeric'}, {'real', 'scalar', 'nonzero'}); % sample time
        catch %#ok<CTCH>
            error('Simulink:ArduinoIO:invalidParameter', 'Invalid value for a mask parameter');
        end        
    end                
        
%%
    function PostPropSetup(block)
        st = block.SampleTimes;
        if st(1) == 0
            error('The ArduinoIO library blocks can only handle discrete sample times');
        end        
    end
%%
    function InitConditions(block) 
        % fprintf('%s: InitConditions\n', getfullname(block.BlockHandle));
        customData = getSetupBlockUserData(bdroot(block.BlockHandle), block.DialogPrm(1).Data);
        myArduino = customData('arduinoHandle');
        myPin = str2double(block.DialogPrm(2).Data);
        myArduino.pinMode(myPin, 'output');
    end

%%
    function Output(block)
        % fprintf('%s: Output\n', getfullname(block.BlockHandle));
        myArduino.analogWrite(myPin, min(255,max(0,round(block.InputPort(1).Data))) );        
    end

%%
    function Terminate(block)  %#ok<INUSD>
         % The ArduinoIO Setup block handles cleanup of myArduino
    end
end

