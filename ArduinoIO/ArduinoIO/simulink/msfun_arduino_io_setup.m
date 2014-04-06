function msfun_arduino_io_setup(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']

%   Copyright 2011 The MathWorks, Inc.

% define instance variables
myArduino = [];

setup(block);

%% ---------------------------------------------------------

    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 0;
        block.NumOutputPorts = 0;
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 3; % arduino var, workspace var name, COM port
        block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable'};
        
        % Block is fixed in minor time step, i.e., it is only executed on major
        % time steps. With a fixed-step solver, the block runs at the fastest
        % discrete rate.
        block.SampleTimes = [0 1];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        block.SimStateCompliance = 'DefaultSimState';
        
        % If the creation of a new variable is requested, (i.e. no
        % previously instantiated workspace arduino variable is used)
        % then the ArduinoIO block uses the Start method to initialize the
        % arduino connection before the variable is actually accessed
        
        block.RegBlockMethod('CheckParameters', @CheckPrms); % called during update diagram
        block.RegBlockMethod('Start', @Start); % called first
        % block.RegBlockMethod('InitializeConditions', @InitConditions); % called second
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function CheckPrms(block)
        try
            validateattributes(block.DialogPrm(1).Data, {'char'}, {'nonempty'}); % Name of new arduino variable
            validateattributes(block.DialogPrm(2).Data, {'char'}, {'nonempty'}); % serial port
            validateattributes(block.DialogPrm(3).Data, {'char'}, {'nonempty'}); % name of existing workspace variable
        catch %#ok<CTCH>
            error('Simulink:ArduinoIO:invalidParameter', 'Invalid parameter for Arduino IO block');
        end
        
        if ~isempty(strfind(block.DialogPrm(1).Data,'Existing')),
            try
                myArduino = evalin('base', block.DialogPrm(3).Data);
                assert(isa(myArduino, 'arduino'));
                assert(isvalid(myArduino));
                assert(~strcmpi(serial(myArduino),'Invalid'));
            catch
                error('Simulink:ArduinoIO:invalidParameter', 'Either the workspace variable ''%s'' is not defined, or it is not a valid arduino object, or its serial port is invalid', block.DialogPrm(3).Data);
            end
        end
        
    end

%%
    function Start(block)
        
        % create the arduino object one way or another
        if ~isempty(strfind(block.DialogPrm(1).Data,'Existing')),
            myArduino = evalin('base', block.DialogPrm(3).Data);
        else
            myArduino = arduino(block.DialogPrm(2).data);
        end
        
        % avoid checking arguments since we know how functions are called
        myArduino.chkp=false;
        
        % store info in custom data;
        customData = containers.Map('UniformValues', false);
        customData('arduinoHandle') = myArduino;
        set(block.BlockHandle, 'UserData', customData, 'UserDataPersistent', 'off');
    end

%%
    function Terminate(block)
        
        % if a new workspace variable was created, needs to be deleted
        customData = get(block.BlockHandle, 'UserData');
        if isvalid(customData)
            arduinoCleanup(customData,block.DialogPrm(1).Data); % this function will delete the arduino object
            delete(customData);
        end
    end


end

