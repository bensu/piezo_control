%% Velocity and Displacement Integration

acc_g = n_to_g(3,acc);

%% High pass filter

low_freq = 1;       % [Hz]
high_freq   = 10;
% Cutoff frequency is that frequency where the magnitude response of the 
% filter is . For butter, the normalized cutoff frequency Wn must be a 
% number between 0 and 1, where 1 corresponds to the Nyquist frequency, 
% π radians per sample.
Ny_freq     = 1/2/T;        % [Hz]

butter_order = 10;
butter_freq  = [low_freq high_freq]/Ny_freq;
[B,A] = butter(butter_order,butter_freq,'bandpass' );
filtered_g = filter(B,A,acc_g);

%%
hold on
plot(t,acc_g)
% plot(t,filtered_g,'k')
hold off

%% V Integration and filtering

v = cumtrapz(t,filtered_g);

filtered_v = filter(B,A,v);

%%
hold on
plot(t,v)
plot(t,filtered_v,'k')
hold off

%% X Integration and filtering

x = cumtrapz(t,filtered_v);
filtered_x = filter(B,A,x);


%%
hold on
% plot(t,9.8*x)
% plot(t,9.8*filtered_g/((2*pi*2)^2),'k')
plot(t,500*filtered_x)
hold off