function msfun_arduino_encoderread(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']

%   Copyright 2011 The MathWorks, Inc.

% instance variables
myArduino = [];
myEncNum = 0;

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
        block.NumDialogPrms     = 6; % arduinoVar, encNum, pinA, pinB, DbDl, T
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Set the sample time
        block.SampleTimes = [block.DialogPrm(6).Data 0];
        
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
            validateattributes(str2double(block.DialogPrm(2).Data), {'numeric'}, {'integer', 'scalar', 'nonnegative','<',3}); % encoder
            validateattributes(str2double(block.DialogPrm(3).Data), {'numeric'}, {'integer', 'scalar', '>',1, '<',70}); % pinA
            validateattributes(str2double(block.DialogPrm(4).Data), {'numeric'}, {'integer', 'scalar', '>',1, '<',70}); % pinB
            validateattributes(block.DialogPrm(5).Data, {'numeric'}, {'integer', 'scalar', 'nonnegative', '<',70}); % DbDl
            validateattributes(block.DialogPrm(6).Data, {'numeric'}, {'real', 'scalar', 'nonzero'}); % sample time
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
        
        % get all parameters first
        myArduino = customData('arduinoHandle');
        myEncNum = str2double(block.DialogPrm(2).Data);
        myPinA = str2double(block.DialogPrm(3).Data);
        myPinB = str2double(block.DialogPrm(4).Data);
        myDbDl = str2double(block.DialogPrm(5).Data);
        
        % attach encoder if it's not attached
        if ~(myArduino.encoderStatus(myEncNum)),
            
            % encoder isn't already attached: attach it and set debouncing delay
            myArduino.encoderAttach(myEncNum, myPinA, myPinB);
            myArduino.encoderDebounce(myEncNum, myDbDl);
            
            % The existence of the key indicates that the corresponding encoder is attached.
            % The value of the key (true/false) isn't important.
            encVarName = sprintf('enc%d', myEncNum);
            customData(encVarName) = true;  %#ok<NASGU>
        end
    end

%%
    function Output(block)
        % fprintf('%s: Output\n', getfullname(block.BlockHandle));
        block.OutputPort(1).Data = myArduino.encoderRead(myEncNum);
    end

%%
    function Terminate(block) %#ok<INUSD>
        % The ArduinoIO Setup block handles cleanup
    end

end
