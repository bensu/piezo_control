%a = arduino('/dev/ttyS101');

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
while (elapsed_time < 5)
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
g = V;
figure
hold on
for coord = 1:3
    V(:,coord) = interp1([0 1023],[0 3.3],acc(:,coord));
    g(:,coord) = G(v_table,coord,V(:,coord));
    plot(t,g(:,coord));
end
hold off

%%
clear Y
clear f
NFFT = 2^nextpow2(length(t)); % Next power of 2 from length of y
Y = fft(g(:,3));
f = 1/2/T*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,abs(Y(1:NFFT/2+1)))
title('Single-Sided Amplitude Spectrum of a_z(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

[pvals, pplaces] = findpeaks(abs(Y));
[NOT_USED, max_place] = max(pvals);
f_1 = f(pplaces(max_place))
