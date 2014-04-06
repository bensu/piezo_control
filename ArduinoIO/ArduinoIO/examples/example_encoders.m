%% Basic example for encoders

% This is a very simple example that shows how to use encoders.

%% create arduino object and connect to board
if exist('a','var') && isa(a,'arduino') && isvalid(a),
    % nothing to do    
else
    a=arduino('DEMO');
end

%% encoders

% attach encoder #0 on pins 3 (pin A) and 2 (pin B)
encoderAttach(a,0,3,2)

% read the encoder position
encoderRead(a,0)

% attach encoder #2 on pins 18 (pin A) and 21 (pin B)
encoderAttach(a,2,18,21)

% sets debouncing delay to 17 (~1.7ms) for encoder #2
encoderDebounce(a,2,17)

% read position or encoder #2
encoderRead(a,2)

% sets debouncing delay to 20 (~2ms) for encoder #0
encoderDebounce(a,0,20)

% read position or encoder #0
encoderRead(a,0)

% reset position of encoder #0
encoderReset(a,0)

% get status of all three encoders
encoderStatus(a);

% detach encoder #0
encoderDetach(a,0);

% detach encoder #2
encoderDetach(a,2);

%% close session
delete(a)

% Copyright 2013 The MathWorks, Inc.