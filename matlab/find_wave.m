function [t_wave, wave] = find_wave(max_n,t,acc)

n_to_a = @(n) 9.8*n_to_g(3,n);

[pks, loc] = findpeaks(acc);
small_pks = (pks < max_n);
aux = find(small_pks);
first_small_peak = loc(aux(1));

t_wave = t(1:first_small_peak);
wave = n_to_a(acc(1:first_small_peak));

end