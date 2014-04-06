% arduinoCleanup(customData)
% Performs cleanup for the Arduino object (corresponding to Arduino IO Block,
% specified by ioBlockHandle) This is called from the Terminate function
% in msfun_arduino_io_setup
%
% The first argument is the customData taken from the stetup block's handle
% the second is the type of arduino var (temporary or existing), in the
% first case the temporary variable must be deleted in the second, the
% variable is left alone after making sure the motors are released and the
% servos are detached.
%
% Note: This function should be used for ALL Arduino-related cleanup. I.e.,
% don't use the Terminate functions of the individual blocks. The reason: we
% cannot guarantee that the Terminate functions for individual blocks will be
% called BEFORE the Terminate function for msfun_arduino_io, so to have a
% coherent teardown, we need to do it all in one place.

%   Copyright 2011 The MathWorks, Inc.

function arduinoCleanup(customData,arduinoVar)

assert(isa(customData,'containers.Map') && customData.isKey('arduinoHandle'));

arduinoObj = customData('arduinoHandle');
if ~isvalid(arduinoObj)
    warning('arduinoCleanup:InvalidObject', 'Arduino object is not valid');
    return;
end

% disconnect servos
for pinNum = 2:69;
    servoVar = sprintf('servo%d', pinNum);
    if customData.isKey(servoVar)
        arduinoObj.servoDetach(pinNum);
        customData.remove(servoVar);
    end
end

% disconnect encoders
for encNum = 0:2;
    encVar = sprintf('enc%d', encNum);
    if customData.isKey(encVar)
        arduinoObj.encoderDetach(encNum);
        customData.remove(encVar);
    end
end

% reinstate checks
arduinoObj.chkp=1;

% release steppers
for stepperNum = 1:2
    arduinoObj.stepperStep(stepperNum,'release');
end

% release motors
for motorNum = 1:4
    arduinoObj.motorRun(motorNum,'release');
end

% delete the object if it's temporary otherwise just flush serial buffer
if ~isempty(strfind(arduinoVar,'Existing')),
    arduinoObj.flush;
else
    delete(arduinoObj);
    fprintf('Connection to ''%s'' successfully closed\n', arduinoVar(end-7:end));
end
