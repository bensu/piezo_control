
runU = run;
runC = run_c;
dU = DSP.get_damping(runU.T,runU.t,runU.g);
dC = DSP.get_damping(runC.T,runC.t,runC.g);
message = { DSP.to_str('\zeta_{uncontrolled}',dU,''), ...
            DSP.to_str('\zeta_{controlled}',dC,'')};
hold on
title('Compare Runs')
grid on
plot(runU.t,runU.g)
plot(runC.t,runC.g,'k')
legend('Uncontrolled','Controlled')
text(0.7*runU.t(end),0.5*max(runU.g),message)
ylabel('g [gs]')
xlabel('t [sec]')
hold off