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

total_t   = 30;
actuate_t = 20;
T = 0.03;
N = floor(total_t / T);
t = zeros(N,1);
t_act = zeros(N,1);
acc = zeros(N,1);
dummy = zeros(N,2);
x = zeros(3,N);
V = zeros(N,1);

f = 3.07;          % [Hz]
amplitude = 150;    % [V]
prev = 0;

tic
elapsed_time = toc;
time_tol = 1e-3;

first_read = true;
i = 1;
while (elapsed_time < total_t)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < time_tol
        acc(i) = a.sample();
        dummy(i,1) = a.analogRead(0);
        dummy(i,2) = a.analogRead(1);
        if (elapsed_time < actuate_t)
            V(i) = amplitude*sin(2*pi*f*elapsed_time);
%             V(i) = amplitude*(elapsed_time)/actuate_t;
            [n,dir] = V_to_N(V(i));
%             [n,dir] = V_to_N(150);
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

a.roundTrip(0,0);

%% Normalize

run = Run(T,t,acc,x,V);
run.store();

t = run.t;
V = run.V;
acc = run.acc;




%% Filter
g   = n_to_g(3,acc);
alpha = 0.01;
B = alpha;
A = [1 alpha-1];
g = filter(B,A,g);
index_val = t ~= 0;
dummy_f1 = filter(B,A,n_to_g(1,dummy(index_val,1)));
dummy_f2 = filter(B,A,n_to_g(2,dummy(index_val,2)));

% dummy_f1 = dummy_f1 - mean(dummy_f1);

hold on
plot(t,g)
plot(t,dummy_f1,'k')
plot(t,dummy_f2,'r')
% plot(t,g,'r')
hold off
%%

figure
run.plot(3,[3,5])
