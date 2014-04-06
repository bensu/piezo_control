function msfun_arduino_stepper(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']

    %   Copyright 2011 The MathWorks, Inc.

% instance variables 
myArduino = [];
myStepperNum = 0;
mySendOnChange = false;
myOldSpeed = 0;

setup(block);

%% ---------------------------------------------------------

    function setup(block)
        block.NumInputPorts  = 3;
        block.NumOutputPorts = 0;
        
        block.SetPreCompInpPortInfoToDynamic;
        for i=1:block.NumInputPorts
            block.InputPort(i).Dimensions        = 1;
            block.InputPort(i).DirectFeedthrough = false;
        end
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 5; % arduino var, stepper num, style, sendOnChange
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Tunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(5).Data 0];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        % the ArduinoIO block uses the Start method to initialize the arduino
        % connection; by using InitConditions, we ensure that we don't access
        % the variable before it is created
        
        block.RegBlockMethod('CheckParameters', @CheckPrms); % called during update diagram
        block.RegBlockMethod('PostPropagationSetup', @PostPropSetup); 
        % block.RegBlockMethod('Start', @Start); % called first
        block.RegBlockMethod('InitializeConditions', @InitConditions); % called second
        block.RegBlockMethod('Outputs', @Output); % called first in sim loop
        % block.RegBlockMethod('Update', @Update); % called second in sim loop
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function CheckPrms(block)        
        try
            validateattributes(block.DialogPrm(1).Data, {'char'}, {'nonempty'});  % Name of arduino instance
            validateattributes(str2double(block.DialogPrm(2).Data), {'numeric'}, {'real', 'scalar', 'nonnegative'}); % stepper number
            validateattributes(block.DialogPrm(3).Data, {'char'}, {'nonempty'});  % Motion Style: 'single', 'double', 'interleave', 'microstep'
            validateattributes(block.DialogPrm(4).Data, {'numeric'}, {'real', 'scalar', 'binary'}); % sendOnChange
            validateattributes(block.DialogPrm(5).Data, {'numeric'}, {'real', 'scalar', 'nonzero'}); % sample time
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
        myStepperNum = str2double(block.DialogPrm(2).Data);
        mySendOnChange = block.DialogPrm(4).Data;
    end

%%
    function Output(block)                
        % fprintf('%s: Output\n', getfullname(block.BlockHandle));
        direction = sign(block.InputPort(1).Data); 
        newSpeed = min(255,abs(round(block.InputPort(2).Data)));
        numSteps = min(255,max(0,round(block.InputPort(3).Data)));
        
        if ~mySendOnChange || (newSpeed ~= myOldSpeed)
            % fprintf('### %g %s: Setting speed to %d\n', block.CurrentTime, getfullname(block.BlockHandle), newSpeed);
            myArduino.stepperSpeed(myStepperNum, newSpeed);
        end

        myArduino.stepperStep(myStepperNum, direction, block.DialogPrm(3).Data, numSteps);        
        myOldSpeed = newSpeed;
    end

%%
    function Terminate(block) %#ok<INUSD>
        % fprintf('%s: Terminate\n', getfullname(block.BlockHandle));
        % The ArduinoIO Setup block handles cleanup
    end

end
