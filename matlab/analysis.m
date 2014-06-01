%% Wave analysis

% I want to find omega and zeta for any wave.

%% Load files

clc
clear all

addpath('Prony Toolbox Download')

static_space  = load('acc_static');
acc_static  = static_space.acc;

%% What acc sample do I use? 

sample = 3;
switch (sample)
    case 1
        space	= load('acc_soft');
    case 2
        space	= load('acc_medium');
    case 3
        space	= load('acc_hard');
end

acc = space.acc(:,3);
t = space.t;

%%

zero_g = mean(acc_static(:,3));   % Value the ADC takes for 0g
max_n = max(acc_static(:,3));
min_n = min(acc_static(:,3));
n_delta = max_n - min_n;        % Error size in ADC.

%%
one_g = max(acc_static(:,1));

g_table = [zero_g; one_g];
g_vals = [0; 1];

g = @(n_val) to_g(g_table,g_vals,n_val);
a = @(n_val) 9.8*g(n_val);

%% Find where acc_hard becomes noise

[pks, loc] = findpeaks(acc);
small_pks = (pks < max_n);
aux = find(small_pks);
first_small_peak = loc(aux(1));

%% 
% fig = figure;
% hax = axes; 
% hold on
% plot(t,acc,'k')
% line([t(first_small_peak) t(first_small_peak)],get(hax,'YLim'))
% line([t(first_small_peak) t(end)],[max_n max_n])
% line([t(first_small_peak) t(end)],[min_n min_n])
% get(hax,'XLim')
% hold off


%% Analyze envelope

t_wave = t(1:first_small_peak);
wave = a(acc(1:first_small_peak));
[envelope, envelop_loc] = findpeaks(wave);
% Fit with exponential

model = fit(t_wave(envelop_loc), (envelope), 'exp1');
k_fit = model.a;
tau_fit = -1/model.b;
% p = polyfit(t_wave(envelop_loc), log(envelope), 1);
% tau_fit = -1/p(1);
% k_fit = exp(p(2));
% plot(t_wave, wave, t_wave(envelop_loc), envelope, 'or', t_wave, k_fit * exp(-t_wave / tau_fit), '-k')

%%
T = 0.04;
clear Y
clear f
NFFT = 2^nextpow2(length(t_wave)); % Next power of 2 from length of y
% NFFT = 4;
Y = fft(wave,NFFT);
f = 1/2/T*linspace(0,1,NFFT/2+1)';

%%

new_Y = Y(1:NFFT/2+1);

[pvals, pplaces] = findpeaks(abs(new_Y(f>1)));
new_f = f(f>1);
[NOT_USED, max_place] = max(pvals);
f_1 = new_f(pplaces(max_place));
w_damped = 2*pi*f_1;

phase_1 = angle(new_Y(pplaces(max_place)))

% Plot single-sided amplitude spectrum.
fig = figure;
hax = axes;
hold on
plot(f,abs(new_Y),'k')
title('Single-Sided Amplitude Spectrum of a_z(t)')
line([f_1 f_1],get(hax,'YLim'));
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
hold off

%% Solve for natural frequency and damping ratio

damping = sqrt(1/(1 + (w_damped*tau_fit)^2))
w_natural = 1/(tau_fit*damping)
f_natural = w_natural / (2*pi)

%% Plot Fitted function

fit_damped = @(t) (k_fit*exp(-t_wave/tau_fit).*sin(w_damped*t-phase_1));

error = abs(wave - fit_damped(t_wave))./abs(a(max_n)-a(min_n));
% plot(t_wave,error)

hold on
plot(t_wave,fit_damped(t_wave),'k')
plot(t_wave,wave)
hold off

%%

% v = cumtrapz(t,a(acc));
% x = cumtrapz(t,v);
% 
% hold on
% % plot(t,a(acc))
% % plot(t,v)
% % plot(t,x)
% hold off



