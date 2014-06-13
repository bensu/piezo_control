% 1. Connect the Arduino and load the Arduino I/O program.
% 2. Create a link between the connected port
% (ACM0, ACM1, ACM2, etc.) and ttyS101 by typing:
%       sudo ln -s /dev/ttyACM0 /dev/ttyS101 
% in the terminal.
% 
% 3. While the Arduino is connected type:
%       a = arduino('/dev/ttyS101');
% in the MATLAB REPL.
%
% Connect pins
% run reads

clear acc
clear t

total_t   = 20;
actuate_t = 10;
T = 0.01;
N = (total_t) / T;
t = zeros(N,1);
t_act = zeros(N,1);
acc = zeros(N,1);
V = zeros(N,1);

dir_pin     = 7;
enable_pin  = 10;


f = 3.07;          % [Hz]
amplitude = 120;    % [V]
prev = 0;

tic
elapsed_time = toc;

for p = 50:69
    a.pinMode(p,'input');
end
for p = [13 dir_pin enable_pin]
    a.pinMode(p,'output');
end

first_read = true;
i = 1;
while (elapsed_time < total_t)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < 1e-5
        acc(i) = a.analogRead(2);
        if (elapsed_time < actuate_t)
            V(i) = amplitude*sin(2*pi*f*elapsed_time);
            [n,dir] = V_to_N(V(i));
            a.roundTrip(dir,n);
            t_act(i) = toc;
        else
            if first_read
                first_read = false;
                a.roundTrip(0,0);
            end
        end
        t(i) = elapsed_time;
        prev = elapsed_time;
        i = i + 1;
    end
end

% a.analogWrite(enable_pin,0);
% a.digitalWrite(dir_pin,0);
a.roundTrip(0,0);

%% Normalize

index_values = (t ~= 0);
t   = t(index_values);
t_act   = t_act(index_values);
V = V(index_values);
acc = acc(index_values);
g   = n_to_g(3,acc);

%% Plot

for i = 1:length(V)
   [aux,aux2] = V_to_N(V(i));
   n(i) = aux;
   dir(i) = aux2;
end
gf = custom_filter(g);
figure
hax = axes;
hold on
grid on
plot(t,V,'r')
line(get(hax,'XLim'),[150 150])
line(get(hax,'XLim'),-[150 150])
% plot(t,n)
% plot(t,g)
% plot(t,(acc-mean(acc))/rms(acc))
plot(t_act,gf*rms(V)/rms(gf))
hold off