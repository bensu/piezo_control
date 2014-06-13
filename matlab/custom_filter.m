function y = custom_filter(x)
    % Only to keep track of this two global variables
    original_rms = rms(x);
    alpha_high = 0.2;
    x = filter([1-alpha_high alpha_high-1],[1 alpha_high-1], x);
%     x = original_rms*x/rms(x);
    new_rms = rms(x);
    alpha_low = 0.1;
    y = filter(alpha_low, [1 alpha_low-1], x);
%     y = new_rms*y/rms(y);
end