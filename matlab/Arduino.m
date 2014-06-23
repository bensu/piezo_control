classdef Arduino < handle
    
    % This class defines an "arduino" object
    % Giampiero Campa, Aug 2013, Copyright 2013 The MathWorks, Inc.
    
    properties (SetAccess = private, GetAccess = private)
        aser   % Serial Connection
        pins   % Pin Status Vector
        srvs   % Servo Status Vector
        mspd   % DC Motors Speed Status
        sspd   % Stepper Motors Speed Status
        encs   % Encoders Status
        sktc   % Motor Server Running on the Arduino Board
    end
    properties (Hidden = true)
        chks = false;  % Checks serial connection before every operation
        chkp = true;   % Checks parameters before every operation
    end
    
    methods
        function a = Arduino(comPort)
            % Constructor, connects to the board and creates an Arduino object
            % comPort [String]: contains the serials directory
            % check nargin
            if nargin<1,
                comPort = 'DEMO';
                disp('Note: a DEMO connection will be created');
                disp('Use a the com port, e.g. ''COM5'' as input argument to connect to the real board');
            end
            % check port
            if ~ischar(comPort),
                error('The input argument must be a string, e.g. ''COM8'' ');
            end
            % check if we are already connected
            if isa(a.aser,'serial') && isvalid(a.aser) && strcmpi(get(a.aser,'Status'),'open'),
                disp(['It looks like a board is already connected to port ' comPort ]);
                disp('Delete the object to force disconnection');
                disp('before attempting a connection to a different port.');
                return;
            end
            % check whether serial port is currently used by MATLAB
            if ~isempty(instrfind({'Port'},{comPort})),
                disp(['The port ' comPort ' is already used by MATLAB']);
                disp(['If you are sure that the board is connected to ' comPort]);
                disp('then delete the object, execute:');
                disp(['  delete(instrfind({''Port''},{''' comPort '''}))']);
                disp('to delete the port, disconnect the cable, reconnect it,');
                disp('and then create a new arduino object');
                error(['Port ' comPort ' already used by MATLAB']);
            end
            a.aser = serial(comPort,'BaudRate',115200); % define serial object
            % connection
            if strcmpi(get(a.aser,'Port'),'DEMO'),
                fprintf(1,'Demo mode connection .'); % handle demo mode
                for i=1:6,
                    pause(1);
                    fprintf(1,'.');
                end
                fprintf(1,'\n');
                % chk is equal to 4, (more general server running)
                a.sktc=4;
            else
                %% Actual connection
                % open port
                try
                    fopen(a.aser);
                catch ME,
                    disp(ME.message)
                    delete(a);
                    error(['Could not open port: ' comPort]);
                end
                % it takes several seconds before any operation could be attempted
                fprintf(1,'Attempting connection .');
                for i=1:12,
                    pause(1);
                    fprintf(1,'.');
                end
                
                fprintf(1,'\n');
                flush(a);   % flush serial buffer before sending anything
                fwrite(a.aser,[57 57],'uchar'); % query sketch type
                a.sktc=fscanf(a.aser,'%d');
                
                % exit if there was no answer
                if isempty(a.sktc)
                    delete(a);
                    error('Connection unsuccessful, please make sure that the board is powered on, running a sketch provided with the package, and connected to the indicated serial port. You might also try to unplug and re-plug the USB cable before attempting a reconnection.');
                end
            end
            %% check returned value
            if a.sktc==0,
                disp('Basic Analog and Digital I/O (adio.pde) sketch detected !');
            elseif a.sktc==1,
                disp('Analog & Digital I/O + Encoders (adioe.pde) sketch detected !');
            elseif a.sktc==2,
                disp('Analog & Digital I/O + Encoders + Servos (adioes.pde) sketch detected !');
            elseif a.sktc==3,
                disp('Motor Shield V1 (plus adioes.pde functions) sketch detected !');
            elseif a.sktc==4,
                disp('Motor Shield V2 (plus adioes.pde functions) sketch detected !');
            else
                delete(a);
                error('Unknown sketch. Please make sure that a sketch provided with the package is running on the board');
            end
            a.aser.Tag = 'ok';    % set a.aser tag
            % initialize pin vector (-1 is unassigned, 0 is input, 1 is output)
            a.pins = -1*ones(1,69);
            % initialize servo vector (0 is detached, 1 is attached)
            a.srvs = 0*ones(1,69);
            % initialize encoder vector (0 is detached, 1 is attached)
            a.encs = 0*ones(1,3);
            % initialize motor vector (0 to 255 is the speed)
            a.mspd = 0*ones(1,4);
            % initialize stepper vector (0 to 255 is the speed)
            a.sspd = 0*ones(1,2);
            % notify successful installation
            disp('Arduino successfully connected !');
        end % arduino

        function delete(a)
            % Destructor, deletes the object
            % Use delete(a) or a.delete to delete the arduino object
            % If it is a serial, valid and open then close it
            if isa(a.aser,'serial') && isvalid(a.aser) && strcmpi(get(a.aser,'Status'),'open'),
                if ~isempty(a.aser.Tag),
                    try % trying to leave it in a known unharmful state
                        for i = 2:69
                            a.pinMode(i,'output');
                            a.digitalWrite(i,0);
                            a.pinMode(i,'input');
                        end
                    catch ME    % disp but proceed anyway
                        disp(ME.message);
                        disp('Proceeding to deletion anyway');
                    end
                end
                fclose(a.aser);
            end
            % if it's an object delete it
            if isobject(a.aser),
                delete(a.aser);
            end
        end % delete
        
        function str = serial(a)
            % serial(a) (or a.serial)
            % Returns the name of the serial port
            % The first and only argument is the arduino object, the output
            % is a string containing the name of the serial port to which
            % the arduino board is connected (e.g. 'COM9', 'DEMO', or
            % '/dev/ttyS101'). The string 'Invalid' is returned if
            % the serial port is invalid
            if isvalid(a.aser),
                str = a.aser.port;
            else
                str = 'Invalid';
            end
        end  % serial

        function val = flush(a)
            % val = flush(a)
            % Clears the pc's serial port buffer and reads all the bytes 
            % available (if any) in the computer's serial port buffer, 
            % therefore clearing said buffer.
            % The first and only argument is the arduino object, the 
            % output is a vector of bytes that were still in the buffer.
            % The value '-1' is returned if the buffer was already empty.
            val = -1;
            if a.aser.BytesAvailable>0,
                val=fread(a.aser,a.aser.BytesAvailable);
            end
        end  % flush

        function digitalWrite(a,pin,val)
            % digitalWrite(a,pin,val); 
            % Performs digital output on a given pin.
            % The first argument, a, is the arduino object.
            % The second argument, pin, is the number of the digital pin 
            % (2 to 69) where the digital output value needs to be written.
            % The third argument, val, is the output value (either 0 or 1).
            % On the Arduino Uno  the digital pins from 0 to 13 are located
            % on the upper right part of the board, while the digital pins
            % from 14 to 19 are better known as "analog input" pins and are
            % located in the lower right corner of the board  (in fact are 
            % often referred to as "analog pins from 0 to 5").
            %
            % Examples:
            % digitalWrite(a,13,1); % sets pin #13 high
            % digitalWrite(a,13,0); % sets pin #13 low
            % a.digitalWrite(13,0); % just as above (sets pin #13 to low)
            
            %% ARGUMENT CHECKING
            if a.chkp
                % check nargin
                if nargin ~= 3,
                    error('Function must have the "pin" and "val" arguments');
                end
                errstr = arduino.checknum(pin,'pin number',2:69); % check pin
                if ~isempty(errstr), error(errstr); end
                errstr=arduino.checknum(val,'value',0:1); % check val
                if ~isempty(errstr), error(errstr); end
                % pin should be configured as output
                if a.pins(pin)~=1,
                    warning('MATLAB:Arduino:digitalWrite','pin should be configured as output');
                end
                
            end
            % check a.aser for validity if a.chks is true
            if a.chks,
                errstr=arduino.checkser(a.aser,'valid');
                if ~isempty(errstr), error(errstr); end
            end
            %% PERFORM DIGITAL OUTPUT
            
            if strcmpi(get(a.aser,'Port'),'DEMO'),
                % handle demo mode
                pause(0.0014); % minimum digital output delay
            else
                % check a.aser for openness if a.chks is true
                if a.chks,
                    errstr=arduino.checkser(a.aser,'open');
                    if ~isempty(errstr), error(errstr); end
                end
                % send mode, pin and value
                fwrite(a.aser,[50 97+pin 48+val],'uchar');
            end
        end % digitalwrite
        
        function val = analogRead(a,pin)
            % val = analogRead(a,pin) 
            % Performs analog input on a given arduino pin.
            % The first argument, a, is the arduino object. The second argument, 
            % pin, is the number of the analog input pin (0 to 15) from which the 
            % analog value needs to be read. The returned value, val, ranges from 
            % 0 to 1023, with 0 corresponding to an input voltage of 0 volts,
            % and 1023 to a reference value that is typically 5 volts (this voltage can
            % be set up by the analogReference function). Therefore, assuming a range
            % from 0 to 5 V the resolution is .0049 volts (4.9 mV) per unit.
            % Note that in the Arduino Uno board the analog input pins 0 to 5 are also
            % the digital pins from 14 to 19, and are located on the lower right corner.
            % Specifically, analog input pin 0 corresponds to digital pin 14, and analog
            % input pin 5 corresponds to digital pin 19. Performing analog input does
            % not affect the digital state (high, low, digital input) of the pin.
            %
            % Examples:
            % val=analogRead(a,0); % reads analog input pin # 0
            % val=a.analogRead(0); % just as above, reads analog input pin # 0
            
            %% ARGUMENT CHECKING
            if a.chkp,
                % check nargin
                if nargin~=2,
                    error('Function must have the "pin" argument');
                end
                % check pin
                errstr=arduino.checknum(pin,'analog input pin number',0:15);
                if ~isempty(errstr), error(errstr); end
                
            end
            % check a.aser for validity if a.chks is true
            if a.chks,
                errstr=arduino.checkser(a.aser,'valid');
                if ~isempty(errstr), error(errstr); end
            end
            
            %% PERFORM ANALOG INPUT            
            if strcmpi(get(a.aser,'Port'),'DEMO'),
                % handle demo mode
                pause(0.0074); % minimum analog input delay
                val = round(1023*rand); % output a random value between 0 and 1023
            else
                % check a.aser for openness if a.chks is true
                if a.chks,
                    errstr=arduino.checkser(a.aser,'open');
                    if ~isempty(errstr), error(errstr); end
                end
                fwrite(a.aser,[51 97+pin],'uchar'); % send mode and pin
                val=fscanf(a.aser,'%d');            % get value
            end
        end % analogread
        
        function analogWrite(a,pin,val)
            % analogWrite(a,pin,val);
            % Performs analog output on a given arduino pin.
            % The first argument, a, is the arduino object. The second argument, 
            % pin, is the number of the DIGITAL pin where the analog (PWM) output 
            % needs to be performed. Allowed pins for AO on the Mega board
            % are 2 to 13 and 44 to 46, (3,5,6,9,10,11 on the Uno board).
            % The second argument, val, is the value from 0 to 255 for the level of
            % analog output. Note that the digital pins from 0 to 13 are located on the
            % upper right part of the board.
            %
            % Examples:
            % analogWrite(a,11,90); % sets pin #11 to 90/255
            % a.analogWrite(3,10); % sets pin #3 to 10/255
            
            %% ARGUMENT CHECKING
            if a.chkp,
                % check nargin
                if nargin~=3,
                    error('Function must have the "pin" and "val" arguments');
                end
                % check pin
                errstr=arduino.checknum(pin,'pwm pin number',[2:13 44:46]);
                if ~isempty(errstr), error(errstr); end
                % check val
                errstr=arduino.checknum(val,'analog output level',0:255);
                if ~isempty(errstr), error(errstr); end
            end
            % check a.aser for validity if a.chks is true
            if a.chks,
                errstr=arduino.checkser(a.aser,'valid');
                if ~isempty(errstr), error(errstr); end
            end
            
            %% PERFORM ANALOG OUTPUT
            if strcmpi(get(a.aser,'Port'),'DEMO'),
                % handle demo mode
                pause(0.0014); % minimum analog output delay
            else
                % check a.aser for openness if a.chks is true
                if a.chks,
                    errstr=arduino.checkser(a.aser,'open');
                    if ~isempty(errstr), error(errstr); end
                end
                fwrite(a.aser,[52 97+pin val],'uchar'); % send mode, pin and value
            end
        end % analogwrite

        function val = sample(a)
            % val = sample(a)
            % Analog read from a determined port
            % check a.aser for validity if a.chks is true
            if a.chks,
                errstr=arduino.checkser(a.aser,'valid');
                if ~isempty(errstr), error(errstr); end
            end
            % check a.aser for openness if a.chks is true
            if a.chks,
                errstr=arduino.checkser(a.aser,'open');
                if ~isempty(errstr), error(errstr); end
            end

            fwrite(a.aser,[89],'uchar'); % send mode and pin
            val=fscanf(a.aser,'%d'); % get value
        end

        function roundTrip(a,dir_val,analog_val)
            % roundTrip(a,dir_val,analog_val)
            % Sends an Analog value and a digital value together
            %% Checks
            % Check Arduino Object for validity
            if a.chks,
                errstr = arduino.checkser(a.aser,'valid');
                if ~isempty(errstr), error(errstr); end
            end
            % Check arguments
            if (dir_val > 1 || analog_val > 255)
                error('WrongRanges');
            end
            % check a.aser for openness if a.chks is true
            if a.chks,
                errstr = arduino.checkser(a.aser,'open');
                if ~isempty(errstr), error(errstr); end
            end
            %% Send mode dir_val and analog_val
            fwrite(a.aser,[88 48+dir_val analog_val],'uchar');
        end % roundtrip
        
        function piezo_actuate(a,V)
            % piezo_actuate(a,V)
            [n,dir] = Arduino.V_to_N(V);
            a.roundTrip(dir,n);
        end

    end % methods
    
    methods (Static)
        function g = n_to_g(coord,n)
            % g = n_to_g(coord,n)
            % g [Float]: acceleration value in gs
            % coord [Int]: coordinate number, 1 for x, 2 for y, 3 for z
            % n [Int]: acceleration measured by ADC [0-1023]
            n_table = [ 315 310 160
                560 570 410
                803 820 655];
            
            g_table = [-1 0 1];
            offset = -0.0061;
            g = interp1(n_table(:,coord),g_table,n,'linear','extrap')+offset;
            
        end
        function [n, dir] = V_to_N(V)
            % [n, dir] = V_to_N(V)
            % Transforms a Voltage V into  an integer for the PWM and a
            % direction
            % n [Int]: 0-MAX_ADC
            % dir [Bool]
            MAX_ADC = 245;
            n = floor((MAX_ADC/150)*abs(V));
            if n > MAX_ADC
                n = MAX_ADC;
            end
            if V > 0
                dir = 1;
            else
                dir = 0;
            end
        end
        function obj = initialize()
            %% Initialize Arduino
            obj = Arduino('/dev/ttyS101');
            obj.roundTrip(0,0);
        end
        function errstr = checknum(num,description,allowed)
            % errstr=arduino.checknum(num,description,allowed); Checks numeric argument.
            % This function checks the first argument, num, described in the string
            % given as a second argument, to make sure that it is real, scalar,
            % and that it is equal to one of the entries of the vector of allowed
            % values given as a third argument. If the check is successful then the
            % returned argument is empty, otherwise it is a string specifying
            % the type of error.
            
            % initialize error string
            errstr=[];
            % check num for type
            if ~isnumeric(num),
                errstr=['The ' description ' must be numeric'];
                return
            end
            % check num for size
            if numel(num)~=1,
                errstr=['The ' description ' must be a scalar'];
                return
            end
            % check num for realness
            if ~isreal(num),
                errstr=['The ' description ' must be a real value'];
                return
            end
            % check num against allowed values
            if ~any(allowed==num),
                % form right error string
                if numel(allowed) == 1,
                    errstr = ['Unallowed value for ' description ', the value must be exactly ' num2str(allowed(1))];
                elseif numel(allowed)==2,
                    errstr = ['Unallowed value for ' description ', the value must be either ' num2str(allowed(1)) ' or ' num2str(allowed(2))];
                elseif max(diff(allowed))==1,
                    errstr = ['Unallowed value for ' description ', the value must be an integer going from ' num2str(allowed(1)) ' to ' num2str(allowed(end))];
                else
                    errstr = ['Unallowed value for ' description ', the value must be one of the following: ' mat2str(allowed)];
                end
            end
        end % checknum
        
        function errstr=checkstr(str,description,allowed)
            % errstr=arduino.checkstr(str,description,allowed); Checks string argument.
            % This function checks the first argument, str, described in the string
            % given as a second argument, to make sure that it is a string, and that
            % its first character is equal to one of the entries in the cell of
            % allowed characters given as a third argument. If the check is successful
            % then the returned argument is empty, otherwise it is a string specifying
            % the type of error.
            
            % initialize error string
            errstr = [];
            if ~ischar(str)     % check string for type
                errstr=['The ' description ' argument must be a string'];
                return
            end
            if numel(str) < 1   % check string for size
                errstr=['The ' description ' argument cannot be empty'];
                return
            end            
            if ~any(strcmpi(str,allowed)) % check str against allowed values
                % make sure this is a hozizontal vector
                allowed=allowed(:)';
                % add a comma at the end of each value
                for i=1:length(allowed)-1,
                    allowed{i}=['''' allowed{i} ''', '];
                end
                % form error string
                errstr=['Unallowed value for ' description ', the value must be either: ' allowed{1:end-1} 'or ''' allowed{end} ''''];
                return
            end
        end % checkstr
        
        function errstr = checkser(ser,chk)
            % errstr=arduino.checkser(ser,chk); Checks serial connection argument.
            % This function checks the first argument, ser, to make sure that either:
            % 1) it is a valid serial connection (if the second argument is 'valid')
            % 3) it is open (if the second argument is 'open')
            % If the check is successful then the returned argument is empty,
            % otherwise it is a string specifying the type of error.
            
            errstr = []; % initialize error string
            % check serial connection
            switch lower(chk),
                case 'valid',  % make sure is valid
                    if ~isvalid(ser),
                        disp('Serial connection invalid, please recreate the object to reconnect to a serial port.');
                        errstr='Serial connection invalid';
                        return
                    end
                case 'open',
                    % check openness
                    if ~strcmpi(get(ser,'Status'),'open'),
                        disp('Serial connection not opened, please recreate the object to reconnect to a serial port.');
                        errstr='Serial connection not opened';
                        return
                    end
                otherwise % complain
                    error('second argument must be either ''valid'' or ''open''');
            end
        end     % chackser
    end
    
end % classdef