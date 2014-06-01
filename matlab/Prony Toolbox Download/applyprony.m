
function [iapp,ai,a_list,tau_list,omega_list,SUB_IND,energy,p]=applyprony(test_time,test_data,N,SUB_N,criteria_val)
% Implements MATLAB Signal Processing Tooltbox prony function 
% performprony GUI

test_t_increment=test_time(2)-test_time(1);
fs=1/test_t_increment; % Sampling frequency=5 e8
[inumz,idenz]=prony(test_data,N,N);
% Compute and plot the impulse response of the Prony approximating system
[iapp,tapp]=impz(inumz,idenz,length(test_time),fs);
[r,p,k]=residuez(inumz,idenz);
a_list=r(:);
spoles=log(p(:))*fs;
tau_list=1./real(spoles);
omega_list=imag(spoles);
n_size=size(test_time,1); 
n=0:1:n_size;
for ct=1:N
    energy(ct)=abs(a_list(ct)^2)*(sum(abs(p(ct).^n).^2));
end

if (criteria_val==1)
    [Mag, ISort]=sort(abs(a_list));
else
    [En,ISort]=sort(energy);
end
ISort=ISort(end:-1:1);
FULL_IND=[ISort(:)]' ;
ai=zeros(size(test_time));
SUB_IND=FULL_IND(1:SUB_N);
for i=SUB_IND
   ai=ai+a_list(i)*exp(spoles(i)*tapp);
end
ai=real(ai);
% Remove bug, PA should be same if modes are equal to model order
if(SUB_N==N)
    ai(1)=iapp(1);
end
% Update the SUB_N for prony fit when no. of modes is not specified
if(SUB_N==0)
    SUB_IND=FULL_IND;
end