%% Initialize Arduino

a = arduino('/dev/ttyS101');
%%
dir_pin = 7;
enable_pin = 10;
for p = 50:69
    a.pinMode(p,'input');
end
for p = [dir_pin enable_pin]
    a.pinMode(p,'output');
end

a.analogWrite(enable_pin,0);
a.digitalWrite(dir_pin,0);