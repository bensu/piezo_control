function [SaveData,maxNum]= prepare_savedata(FinalResults,handles,hObject);
    % Retreive old data structure
%     handles.menu_saveasflag
    if (isfield(handles,'SaveData') & ~isempty(handles.SaveData)& (handles.menu_saveasflag==0)) 
        SaveData = handles.SaveData;
       % Determine the maximum run number currently used.
	    maxNum = SaveData(length(SaveData)).RunNumber;
	    ResultNum = maxNum+1;
    else, % Set up the results data structure
	    SaveData = struct('RunName',[],'RunNumber',[],...
                'file_name',[],'path_name',[],...
		        'depvariable',[],'indepvariable',[],'preprocessid',[],...
                'flagwindow',[],'dp_x',[],'dp_y',[],...
                'flagdecimate',[],'dfactor',[],...
                'modelorder',[],'modes',[],'criteriaid',[],...
                'SUB_IND',[],'mode_selectionid',[]);
        ResultNum = 1;
        maxNum=0;
    end
    PronyData=evalin('base','PronyData'); 
    SaveData(ResultNum).file_name=PronyData.filename;
    SaveData(ResultNum).path_name=PronyData.pathname;
    SaveData(ResultNum).depvariable=PronyData.depvariable;
    SaveData(ResultNum).indepvariable=PronyData.indepvariable;
    SaveData(ResultNum).preprocessid=PronyData.preprocessid;
    SaveData(ResultNum).flagdecimate=PronyData.flagdecimate;
    SaveData(ResultNum).dfactor=PronyData.dfactor;
    SaveData(ResultNum).flagwindow=PronyData.flagwindow;
    SaveData(ResultNum).dp_x=PronyData.dp_x;
    SaveData(ResultNum).dp_y=PronyData.dp_y;
    SaveData(ResultNum).RunName = ['Session ',num2str(ResultNum)];
    SaveData(ResultNum).RunNumber = ResultNum;
    SaveData(ResultNum).modelorder=FinalResults.NewVal;
    SaveData(ResultNum).modes=FinalResults.SUB_N;
    SaveData(ResultNum).criteriaid=FinalResults.criteria_val;
    SaveData(ResultNum).SUB_IND=FinalResults.SUB_IND;
    SaveData(ResultNum).mode_selectionid=FinalResults.mode_selectionid;
    %Store the new SaveData
    handles.SaveData = SaveData; 
    guidata(hObject,handles);
    if(isfield(handles,'SaveData') & ~isempty(handles.SaveData) & (handles.menu_saveasflag==1))
        SaveData=evalin('base','SaveData');
        maxNum=evalin('base','maxNum');
    end
%     size(SaveData)
   
    