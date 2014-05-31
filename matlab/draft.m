%a = arduino('/dev/ttyS101');
%sudo ln -s /dev/ttyACM0 /dev/ttyS101 
% Connect pins
% run reads

N = 40;
clear acc
clear t
prev = 0;
T = 0.04;
t = zeros(N,1);
acc = zeros(N,3);
tic
elapsed_time = toc;
i = 1;
for i = 2:69
    a.pinMode(i,'input');
end
i = 1;
while (elapsed_time < 30)
    elapsed_time = toc;
    if (prev + T < elapsed_time) || abs(prev + T - elapsed_time) < 1e-5
        prev = elapsed_time;
        t(i) = elapsed_time;
        acc(i,1) = a.analogRead(0);
        acc(i,2) = a.analogRead(1);
        acc(i,3) = a.analogRead(2);
        i = i + 1;
    end
end

V = zeros(size(acc));
g = zeros(size(acc));
figure
hold on
for coord = 1:3
    V(:,coord) = interp1([0 1023],[0 3.3],acc(:,coord));
    g(:,coord) = G(v_table,coord,V(:,coord));
    plot(t,g(:,coord));
end
hold off

% g_mean = mean(g);
% for i = 1:size(g,2)
%     g(i,:) = g(i,:) - g_mean;
% end
%%
clear Y
clear f
NFFT = 2^nextpow2(length(t)); % Next power of 2 from length of y
Y = fft(g(:,3));
f = 1/2/T*linspace(0,1,NFFT/2+1)';
new_Y = abs(Y(1:NFFT/2+1));
% Plot single-sided amplitude spectrum.
plot(f,abs(new_Y))
title('Single-Sided Amplitude Spectrum of a_z(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

[pvals, pplaces] = findpeaks(new_Y(f>1));
new_f = f(f>1);
[NOT_USED, max_place] = max(pvals);
f_1 = new_f(pplaces(max_place))
