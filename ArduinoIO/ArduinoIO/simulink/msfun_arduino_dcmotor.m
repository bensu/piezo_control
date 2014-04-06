function msfun_arduino_dcmotor(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']

    %   Copyright 2011 The MathWorks, Inc.

% instance variables 
myArduino = [];
myMotorNum = 0;
mySendOnChange = false;
myOldMode = 0; % 1=forward, 0=release, -1=backward
myOldSpeed = 0;

setup(block);

%% ---------------------------------------------------------

    function setup(block)
        block.NumInputPorts  = 2;
        block.NumOutputPorts = 0;
        
        block.SetPreCompInpPortInfoToDynamic;
        block.InputPort(1).Dimensions        = 1;
        block.InputPort(1).DirectFeedthrough = false;
        block.InputPort(2).Dimensions        = 1;
        block.InputPort(2).DirectFeedthrough = false;
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 4; % arduino var, motor num, sendOnChange
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(4).Data 0];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        % the ArduinoIO block uses the Start method to initialize the arduino
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
            validateattributes(str2double(block.DialogPrm(2).Data), {'numeric'}, {'real', 'scalar', 'nonnegative'}); % motor num
            validateattributes(block.DialogPrm(3).Data, {'numeric'}, {'real', 'scalar', 'binary'}); % sendOnChange
            validateattributes(block.DialogPrm(4).Data, {'numeric'}, {'real', 'scalar', 'nonzero'}); % sample time
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
        myMotorNum = str2double(block.DialogPrm(2).Data);        
        mySendOnChange = block.DialogPrm(3).Data;        
    end

%%
    function Output(block)                
        % fprintf('%s: Output\n', getfullname(block.BlockHandle));
        newMode = sign(block.InputPort(1).Data); % 1=forward, 0=release, -1=backward
        newSpeed = min(255,abs(round(block.InputPort(2).Data))); % desired speed 0 to 255

        if ~mySendOnChange || (newMode ~= myOldMode)
            % fprintf('### %g %s: Setting mode to %d\n', block.CurrentTime, getfullname(block.BlockHandle), newMode);
            myArduino.motorRun(myMotorNum, newMode);
        end
        
        if ~mySendOnChange || (newSpeed ~= myOldSpeed)
            % fprintf('### %g %s: Setting speed to %d\n', block.CurrentTime, getfullname(block.BlockHandle), newSpeed);
            myArduino.motorSpeed(myMotorNum, newSpeed);
        end

        myOldMode = newMode;
        myOldSpeed = newSpeed;
    end

%%
    function Terminate(block)  %#ok<INUSD>
        % The ArduinoIO Setup block handles cleanup of myArduino
    end

end
