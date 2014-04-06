function msfun_arduino_servoread(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']

    %   Copyright 2011 The MathWorks, Inc.

% instance variables 
myArduino = [];
myPinNum = 0;

setup(block);

%% ---------------------------------------------------------

    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 0;
        block.NumOutputPorts = 1;
        
        block.SetPreCompOutPortInfoToDynamic;
        block.OutputPort(1).Dimensions  = 1;
        block.OutputPort(1).SamplingMode = 'sample';
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 3; % arduinoVar, servoNum
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(3).Data 0];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
                
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
            validateattributes(block.DialogPrm(2).Data, {'numeric'}, {'integer', 'scalar', '>',1, '<',70}); % pin
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
        myPinNum = block.DialogPrm(2).Data;     
        servoVarName = sprintf('servo%d', myPinNum);
        if ~(myArduino.servoStatus(myPinNum)),
            % servo isn't already attached
            myArduino.servoAttach(myPinNum);
            % The existence of the key indicates that the corresponding servo is attached.
            % The value of the key (true/false) isn't important.
            customData(servoVarName) = true;  %#ok<NASGU>
        end
    end

%%
    function Output(block)
        % fprintf('%s: Output\n', getfullname(block.BlockHandle));
        block.OutputPort(1).Data = myArduino.servoRead(myPinNum);
    end

%%
    function Terminate(block) %#ok<INUSD>
        % The ArduinoIO Setup block handles cleanup of myArduino and servo
    end

end
