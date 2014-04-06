% This files installs the MATLAB support package for Arduino (ArduinoIO package).

%   Copyright 2011 The MathWorks, Inc.

% look for arduino.m
wa=which('arduino.m','-all');

% make sure we are in the right folder and there are no other arduino.m files
if length(wa) < 1, 
    msg=' Cannot find arduino.m, please run this file from the folder containing arduino.m';
    error(msg);
end
if length(wa) > 1,
    msg=' There is at least another arduino.m file in the path, please delete any other versions before installing this one';
    error(msg);
end

% get the main arduino folder
ap=wa{1};ap=ap(1:end-10);

% Add target directories and save the updated path
addpath(fullfile(ap,''));
addpath(fullfile(ap,'simulink',''));
addpath(fullfile(ap,'examples',''));
disp(' Arduino folders added to the path');

result = savepath;
if result==1
    nl = char(10);
    msg = [' Unable to save updated MATLAB path (<a href="http://www.mathworks.com/support/solutions/en/data/1-9574H9/index.html?solution=1-9574H9">why?</a>)' nl ...
           ' On Windows, exit MATLAB, right-click on the MATLAB icon, select "Run as administrator", and re-run install_arduino.m' nl ...
           ' On Linux, exit MATLAB, issue a command like this: sudo chmod 777 usr/local/matlab/R2011a/toolbox/local/pathdef.m' nl ...
           ' (depending on where MATLAB is installed), and then re open MATLAB and re-run install_arduino.m' nl ...
           ];
    error(msg);
else
    disp(' Saved updated MATLAB path');
    disp(' ');
end

clear wa ap result nl msg 
