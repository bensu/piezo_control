function [n, dir] = V_to_N(V)
    MAX_ADC = 230;
    n = floor((MAX_ADC/150)*abs(V));
    if n > MAX_ADC
        n = MAX_ADC;
    end
    if V > 0
        dir = 1;
    else 
        dir = 0;
    end
end