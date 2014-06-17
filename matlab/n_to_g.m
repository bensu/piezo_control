function g = n_to_g(coord,n)
% g = n_to_g(coord,n
% g [Float]: acceleration value in gs
% coord [Int]: coordinate number, 1 for x, 2 for y, 3 for z
% n [Int]: acceleration measured by ADC [0-1023]

n_table = [ 315 310 155
            560 570 410
            803 820 650];

g_table = [-1 0 1];
offset = 0;
g = interp1(n_table(:,coord),g_table,n,'linear','extrap')+offset;
    
end