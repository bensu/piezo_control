function [k,tau] = fit_exp(t,x)
    % [k,tau] = fit_exp(t,x)
    % x(t) = k*exp(-t/tau);
    % k [Float]
    % tau [Float]
    model = fit(t,abs(hilbert(x)), 'exp1');
    k = model.a;
    tau = -1/model.b;
end