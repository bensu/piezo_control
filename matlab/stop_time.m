load('g_interp2')
g = g(1:length(t));

[g_peaks, p_locs] = findpeaks(g);

g_min_res = 0.1;

for i = 3:length(p_locs)
    if all([g_peaks(i-2),g_peaks(i-1),g_peaks(i)] < g_min_res)
        break
    end
end
i
%%
figure
hax = axes;
grid on
hold on
% plot(t(p_locs),g_peaks,'k')
plot(t,g)
line(get(hax,'XLim'),[g_peaks(i) g_peaks(i)])
line([t(p_locs(i)) t(p_locs(i))], get(hax,'YLim'));
hold off
