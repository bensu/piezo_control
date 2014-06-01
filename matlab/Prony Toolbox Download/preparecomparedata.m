function  [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run)
   dp_x=SaveData(Run).dp_x;
   dp_y=SaveData(Run).dp_y;
   criteria_val=SaveData(Run).criteriaid;     
   NewVal=SaveData(Run).modelorder;
   SUB_N=SaveData(Run).modes;
   [iapp,Nused_ai,a_list,tau_list,omega_list,Nused_IND,energy,p]=applyprony(dp_x,dp_y,NewVal,SUB_N,criteria_val);
    SUB_IND=SaveData(Run).SUB_IND;
    ai=zeros(size(dp_x));
    test_t_increment=dp_x(2)-dp_x(1);
    fs=1/test_t_increment ;% Sampling frequency
    spoles=log(p(:))*fs; 
    for i=SUB_IND
        ai=ai+a_list(i)*exp(spoles(i)*dp_x);
    end
    ai=real(ai);
    % Remove bug, PA should be same if modes are equal to model order
    if(SUB_N==NewVal)
      ai(1)=iapp(1);
    end
    
    % Get the energy only of the specific modes chosen in PA
    [En,ISort]=sort(energy);
    ISort=ISort(end:-1:1);
    FULL_IND=[ISort(:)]' ;
    EN_IND=FULL_IND(1:SUB_N);
    energy=energy(SUB_IND);