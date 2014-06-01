function [promptstr]=  prepare_comparelist(maxNum,SaveData)
promptstr={};
for ResultNum=1:(maxNum+1)
    if(SaveData(ResultNum).preprocessid==1)
        DataPreprocess='Remove Mean  ';
    elseif(SaveData(ResultNum).preprocessid==2)
        DataPreprocess='No Change    ';
    else(SaveData(ResultNum).preprocessid==3)
        DataPreprocess='Detrend      ';
    end
    %------------------------------
    if(SaveData(ResultNum).flagdecimate==1)
        decimation='Yes';
    else
        decimation='No ';
    end
    %------------------------
    %------------------------------
    if(SaveData(ResultNum).flagwindow==1)
        windowing='Yes';
    else
        windowing='No ';
    end
    %------------------------
    if(SaveData(ResultNum).criteriaid==1)
        Criteria='Amplitude Criteria';
    else
        Criteria='Energy Criteria   ';
    end
    %----------------------
    switch SaveData(ResultNum).mode_selectionid
        case 1
            selectionid='All Modes       ';
        case 2
            selectionid='Selected Modes  ';
        case 3
            selectionid='All but Selected';
    end
    %--------------------------   
    promptstr=[promptstr;{[SaveData(ResultNum).RunName,blanks(10),...
                    SaveData(ResultNum).file_name,...
                    blanks(10),SaveData(ResultNum).indepvariable,blanks(2),...
                    '&',blanks(2),SaveData(ResultNum).depvariable,...
                    blanks(15),DataPreprocess,blanks(10),decimation...
                    blanks(2),num2str(SaveData(ResultNum).dfactor,'%2d'),....
                    blanks(10),windowing,...
                    blanks(12),num2str(SaveData(ResultNum).modelorder,'%4d'),...
                    blanks(12),num2str(SaveData(ResultNum).modes,'%4d'),...
                    blanks(12),Criteria,blanks(10),selectionid,...
            ]}]; 
end