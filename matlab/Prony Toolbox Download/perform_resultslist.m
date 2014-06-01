function [promptstr]=perform_resultslist(test_time,test_data,NewVal,SUB_N,criteria_val)
% Prepares the list box data in Perform PA GUI
% call apply prony function
[iapp,ai,a_list,tau_list,omega_list,SUB_IND,energy,p]=applyprony(test_time,test_data,NewVal,SUB_N,criteria_val);
ct=0;
promptstr={};
for i=SUB_IND
    ct=ct+1;    
    promptstr=[promptstr;{[num2str(ct,'%2d'),blanks(12),num2str(abs(2*a_list(i)),'%10.1e'),...
                    blanks(12),num2str(1/tau_list(i),'%12.1e'),...
                    blanks(12),num2str(abs(omega_list(i)/(2*pi)),'%12.1e'),...
                    blanks(12),num2str(abs(energy(i)),'%12.1e')]}]; 
             
end