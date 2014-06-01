function varargout = exportresults(varargin)
% EXPORTRESULTS M-file for exportresults.fig
%      EXPORTRESULTS, by itself, creates a new EXPORTRESULTS or raises the existing
%      singleton*.
%
%      H = EXPORTRESULTS returns the handle to a new EXPORTRESULTS or the handle to
%      the existing singleton*.
%
%      EXPORTRESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORTRESULTS.M with the given input arguments.
%
%      EXPORTRESULTS('Property','Value',...) creates a new EXPORTRESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before exportresults_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to exportresults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exportresults

% Last Modified by GUIDE v2.5 06-Jul-2003 12:19:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exportresults_OpeningFcn, ...
                   'gui_OutputFcn',  @exportresults_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before exportresults is made visible.
function exportresults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to exportresults (see VARARGIN)

% Choose default command line output for exportresults
handles.output = hObject;
set(hObject,'Color','white');
% Set the toolbar for the figure
pronytoolbar(hObject,'on');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exportresults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exportresults_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in push_exportwspace.
function push_exportwspace_Callback(hObject, eventdata, handles)
% hObject    handle to push_exportwspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(evalin('base','exist(''PronyData'',''var'')')==0)
        msgbox('Please Prepare Prony Analysis Data to Export the Results','Prepare Prony Analysis GUI Data is Empty','replace')
        whitebg('white');
else    
    IGuiData=evalin('base','PronyData');
    if (get(handles.chkbx_all1,'Value') == get(handles.chkbx_all1,'Max'))
            assignin('base',get(handles.edit_all1,'String'),IGuiData)
    end

    if (get(handles.chkbx_raw,'Value') == get(handles.chkbx_raw,'Max'))
            name=get(handles.edit_raw,'String');
            name= struct('x',[],'y',[]);
            name.x=IGuiData.x_val;
            name.y=IGuiData.y_val;
            assignin('base',get(handles.edit_raw,'String'),name);
    end

    if (get(handles.chkbx_range,'Value') == get(handles.chkbx_range,'Max'))
    % then checkbox is checked-take approriate action
            name=get(handles.edit_range,'String');
            name= struct('x',[],'y',[]);
            name.x=IGuiData.window_x;
            name.y=IGuiData.window_y;
            assignin('base',get(handles.edit_range,'String'),name);
    end


    if (get(handles.chkbx_decimated,'Value') == get(handles.chkbx_decimated,'Max'))
    % then checkbox is checked-take approriate action
            name=get(handles.edit_decimated,'String');
            name= struct('x',[],'y',[]);
            name.x=IGuiData.deci_x;
            name.y=IGuiData.deci_y;
            assignin('base',get(handles.edit_decimated,'String'),name);
    end

    if (get(handles.chkbx_preprocess,'Value') == get(handles.chkbx_preprocess,'Max'))
    % then checkbox is checked-take approriate action
            name=get(handles.edit_preprocess,'String');
            name= struct('x',[],'y',[]);
            name.x=IGuiData.dp_x;
            name.y=IGuiData.dp_y;
            assignin('base',get(handles.edit_preprocess,'String'),name);
    end
    
end  % outermost condition which checks if the data exists or not

    % Export the data related to Perform Prony Analysis GUI
 %----------------------------------------------------------------------
 %----------------------------------------------------------------------
if(evalin('base','exist(''IIGuiData'',''var'')')==0)
        msgbox('Please Perform Prony Analysis to Export the Results','Perform Prony Analysis GUI Data is Empty','replace')
        whitebg('white');
else
    IIGuiData=evalin('base','IIGuiData');
    if (get(handles.chkbx_all2,'Value') == get(handles.chkbx_all2,'Max'))
         assignin('base',get(handles.edit_preprocess,'String'),IIGuiData);
    end
    
    if (get(handles.chkbx_pronyfit,'Value') == get(handles.chkbx_pronyfit,'Max'))
            name=get(handles.edit_pronyfit,'String');
            name= struct('x',[],'y',[],'prony_y',[],'f',[],'fft_y',[],'fft_prony_y',[]);
            name.x=IIGuiData.test_time;
            name.y=IIGuiData.test_data;
            name.prony_y=IIGuiData.iapp;
            name.f=IIGuiData.f1;
            name.fft_y=IIGuiData.fft_data1;
            name.fft_prony_y=IIGuiData.fft_iapp1;
            assignin('base',get(handles.edit_pronyfit,'String'),name);
    end
    
    % Export the results associated with the second plot of Prony Analysis GUI
   
    if (get(handles.chkbx_pronymodes,'Value') == get(handles.chkbx_pronymodes,'Max'))
            name=get(handles.edit_pronymodes,'String');
            name=struct('x',[],'y',[],'prony_y',[],'f',[],'fft_y',[],'fft_prony_y',[]);
            name.x=IIGuiData.test_time;
            name.y=IIGuiData.test_data;
            name.prony_y=IIGuiData.ai;
            name.f=IIGuiData.f2;
            name.fft_y=IIGuiData.fft_data2;
            name.fft_prony_y=IIGuiData.fft_iapp2;
            assignin('base',get(handles.edit_pronymodes,'String'),name);
    end
        

    % Export the results associated with the Pole Diagram of Prony Analysis GUI
    if (get(handles.chkbx_poles,'Value') == get(handles.chkbx_poles,'Max'))
            name=get(handles.edit_poles,'String');
            name=struct('zeros',[],'poles',[]);
            name.poles=IIGuiData.idennz;
            name.zeros=0;
            assignin('base',get(handles.edit_poles,'String'),name);
    end

% Export the results associated with the Pole-Zero Diagram of Prony Analysis GUI
    if (get(handles.chkbx_polezero,'Value') == get(handles.chkbx_polezero,'Max'))
            name=get(handles.edit_polezero,'String');
            name=struct('zeros',[],'poles',[]);
            name.poles=IIGuiData.idennz;
            name.zeros=IIGuiData.inummz;
            assignin('base',get(handles.edit_polezero,'String'),name);
    end


% Export the results associated with the Sorted Residues of Prony Analysis GUI
    if (get(handles.chkbx_sortedres,'Value') == get(handles.chkbx_sortedres,'Max'))
            name=get(handles.edit_sortedres,'String');
            name=struct('index',[],'residues',[]);
            name.index=1:size(IIGuiData.SUB_IND,2);
            name.residues=IIGuiData.aa_list;
            assignin('base',get(handles.edit_sortedres,'String'),name);
    end


% Export the results associated with the All Residues of Prony Analysis GUI
    if (get(handles.chkbx_allres,'Value') == get(handles.chkbx_allres,'Max'))
            name=get(handles.edit_allres,'String');
            name=struct('index',[],'residues',[]);
            name.index=1:size(IIGuiData.res_SUBIND,2);
            name.residues=IIGuiData.all_res;
            assignin('base',get(handles.edit_allres,'String'),name);
    end


% Export the results associated with the Pole Diagram of Prony Analysis GUI
    if (get(handles.chkbx_seerror,'Value') == get(handles.chkbx_seerror,'Max'))
            name=get(handles.edit_seerror,'String');
            name=struct('time',[],'squarederror',[]);
            name.time=IIGuiData.test_time;
            name.squarederror=IIGuiData.seerror;
            assignin('base',get(handles.edit_seerror,'String'),name);
    end


% Export the results associated with the All Energy of Prony Analysis GUI
    if (get(handles.chkbx_energy,'Value') == get(handles.chkbx_energy,'Max'))
            name=get(handles.edit_energy,'String');
            name=struct('index',[],'energy',[]);
            name.index=1:size(IIGuiData.res_SUBIND,2);
            name.energy=IIGuiData.energy;
            assignin('base',get(handles.edit_energy,'String'),name);
    end
    
end  % Outermost condition which checks if the data is empty

% Export Compare Sessions GUI Data
%----------------------------------------------------------------------
%----------------------------------------------------------------------
if(evalin('base','exist(''IIIGuiData'',''var'')')==0)
        msgbox('Please Compare Sessions to Export the Results','Compare Sessions GUI Data is Empty','replace')
        whitebg('white');
else
    IIIGuiData=evalin('base','IIIGuiData');
    SaveData=evalin('base','SaveData');
    size_limit=size(IIIGuiData,2);
% Export the results associated with the All data of Compare Sessions GUI
    if (get(handles.chkbx_all3,'Value') == get(handles.chkbx_all3,'Max'))
        assignin('base',get(handles.edit_all3,'String'),SaveData)
    end

% Export the Poles data
    if (get(handles.chkbx_comparepoles,'Value') == get(handles.chkbx_comparepoles,'Max'))
         assignin('base',get(handles.edit_comparepoles,'String'),{IIIGuiData(1:size_limit).poles})
    end

% Export the Residues data
    if (get(handles.chkbx_compareres,'Value') == get(handles.chkbx_compareres,'Max'))
         assignin('base',get(handles.edit_compareres,'String'),{IIIGuiData(1:size_limit).residues})
    end

% Export the Squared Error Data
    if (get(handles.chkbx_compareseerror,'Value') == get(handles.chkbx_compareseerror,'Max'))
         assignin('base',get(handles.edit_compareseerror,'String'),{IIIGuiData(1:size_limit).seerror})
    end

% Export the Energy data
    if (get(handles.chkbx_compareenergy,'Value') == get(handles.chkbx_compareenergy,'Max'))
        assignin('base',get(handles.edit_compareenergy,'String'),{IIIGuiData(1:size_limit).energy})
    end
end % Outermost condition to check if the data exists



% --- Executes on button press in push_exporthelp.
function push_exportfile_Callback(hObject, eventdata, handles)
% hObject    handle to push_exporthelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Name(1)={get(handles.edit_all1,'String')};
Name(2)={get(handles.edit_raw,'String')};
Name(3)={get(handles.edit_decimated,'String')};
Name(4)={get(handles.edit_range,'String')};
Name(5)={get(handles.edit_preprocess,'String')};
Name(6)={get(handles.edit_all2,'String')};
Name(7)={get(handles.edit_pronyfit,'String')};
Name(8)={get(handles.edit_pronymodes,'String')};
Name(9)={get(handles.edit_poles,'String')};
Name(10)={get(handles.edit_polezero,'String')};
Name(11)={get(handles.edit_sortedres,'String')};
Name(12)={get(handles.edit_allres,'String')};
Name(13)={get(handles.edit_seerror,'String')};
Name(14)={get(handles.edit_energy,'String')};
Name(15)={get(handles.edit_all3,'String')};
Name(16)={get(handles.edit_comparepoles,'String')};
Name(17)={get(handles.edit_compareres,'String')};
Name(18)={get(handles.edit_compareseerror,'String')};
Name(19)={get(handles.edit_compareenergy,'String')};

if(evalin('base','exist(''PronyData'',''var'')')==0)
        msgbox('Please Prepare Prony Analysis Data to Export the Results','Prepare Prony Analysis GUI Data is Empty','replace')
        whitebg('white');
else    
    IGuiData=evalin('base','PronyData');
    if (get(handles.chkbx_all1,'Value') == get(handles.chkbx_all1,'Max'))
    % then checkbox is checked-take approriate action
         Data(1)={IGuiData};
    else
          Data(1)={'Empty'};
    end

    if (get(handles.chkbx_raw,'Value') == get(handles.chkbx_raw,'Max'))
    % then checkbox is checked-take approriate action
          Data(2)={[IGuiData.x_val IGuiData.y_val]};
    else
         Data(2)={'Empty'};
    end

    if (get(handles.chkbx_decimated,'Value') == get(handles.chkbx_decimated,'Max'))
    % then checkbox is checked-take approriate action
         Data(3)={[IGuiData.deci_x IGuiData.deci_y]};
    else
         Data(3)={'Empty'};
    end

    if (get(handles.chkbx_range,'Value') == get(handles.chkbx_range,'Max'))
    % then checkbox is checked-take approriate action
         Data(4)={[IGuiData.window_x IGuiData.window_y]};
    else
         Data(4)={'Empty'};
    end

    if (get(handles.chkbx_preprocess,'Value') == get(handles.chkbx_preprocess,'Max'))
    % then checkbox is checked-take approriate action
         Data(5)={[IGuiData.dp_x IGuiData.dp_y]};
    else
        Data(5)={'Empty'};
    end
end % close the test of existance of IGuiData

% Data associated with Perform Prony Analysis GUI
%------------------------------------------------------
%------------------------------------------------------
if(evalin('base','exist(''IIGuiData'',''var'')')==0)
        msgbox('Please Perform Prony Analysis to Export the Results','Perform Prony Analysis GUI Data is Empty','replace')
        whitebg('white');
else
    IIGuiData=evalin('base','IIGuiData');
    if (get(handles.chkbx_all2,'Value') == get(handles.chkbx_all2,'Max'))
        Data(6)={IIGuiData};
    else
        Data(6)={'Empty'};
    end

    if (get(handles.chkbx_pronyfit,'Value') == get(handles.chkbx_pronyfit,'Max'))
        Data(7)= {[IIGuiData.test_time IIGuiData.test_data IIGuiData.iapp ]};
    else
        Data(7)={'Empty'};
    end

        
    if (get(handles.chkbx_pronymodes,'Value') == get(handles.chkbx_pronymodes,'Max'))
        Data(8)= {[IIGuiData.test_time IIGuiData.test_data IIGuiData.ai]};
    else
        Data(8)={'Empty'};
    end

% Export the results associated with the Pole Diagram of Prony Analysis GUI
    if (get(handles.chkbx_poles,'Value') == get(handles.chkbx_poles,'Max'))
        Data(9)={IIGuiData.idennz};
    else
        Data(9)={'Empty'};
    end

    if (get(handles.chkbx_polezero,'Value') == get(handles.chkbx_polezero,'Max'))
        Data(10)={[IIGuiData.inummz IIGuiData.idennz]};
    else
        Data(10)={'Empty'};
    end

    if (get(handles.chkbx_sortedres,'Value') == get(handles.chkbx_sortedres,'Max'))
        index=1:size(IIGuiData.SUB_IND,2);
        index=index';
        Data(11)={[index IIGuiData.aa_list]};
    else
        Data(11)={'Empty'};
    end

    if (get(handles.chkbx_allres,'Value') == get(handles.chkbx_allres,'Max'))
        index=1:size(IIGuiData.res_SUBIND,2);
        index=index';
        Data(12)={[index IIGuiData.all_res]};
    else
        Data(12)={'Empty'};
    end

    if (get(handles.chkbx_seerror,'Value') == get(handles.chkbx_seerror,'Max'))
        Data(13)={[IIGuiData.test_time IIGuiData.seerror]};
    else
        Data(13)={'Empty'};
    end

    if (get(handles.chkbx_energy,'Value') == get(handles.chkbx_energy,'Max'))
       index=1:size(IIGuiData.res_SUBIND,2);
       Data(14)={[index IIGuiData.energy]};
    else
        Data(14)={'Empty'};
    end
end % Close the test of existance of IIGuiData
% Data associated with Compare Sessions GUI
%------------------------------------------------------
%------------------------------------------------------
if(evalin('base','exist(''IIIGuiData'',''var'')')==0)
        msgbox('Please Compare Sessions to Export the Results','Compare Sessions GUI Data is Empty','replace')
        whitebg('white');
else
    IIIGuiData=evalin('base','IIIGuiData');
    SaveData=evalin('base','SaveData');
    size_limit=size(IIIGuiData,2);
    if (get(handles.chkbx_all3,'Value') == get(handles.chkbx_all3,'Max'))
        Data(15)={SaveData};
    else
        Data(15)={'Empty'};
    end

    if (get(handles.chkbx_comparepoles,'Value') == get(handles.chkbx_comparepoles,'Max'))
        temp={IIIGuiData(1:size_limit).poles};
        Data(16)={temp};
    else
        Data(16)={'Empty'};
    end

    if (get(handles.chkbx_compareres,'Value') == get(handles.chkbx_compareres,'Max'))
        temp={IIIGuiData(1:size_limit).residues};
        Data(17)={temp};
    else
        Data(17)={'Empty'};
    end

    if (get(handles.chkbx_compareseerror,'Value') == get(handles.chkbx_compareseerror,'Max'))
        temp={IIIGuiData(1:size_limit).seerror};
        Data(18)={temp};
    else
        Data(18)={'Empty'};
    end

    if (get(handles.chkbx_compareenergy,'Value') == get(handles.chkbx_compareenergy,'Max'))
        temp={IIIGuiData(1:size_limit).energy};
        Data(19)={temp};
    else
        Data(19)={'Empty'};
    end
    
end % Close the test which checks the existance of IIIGuiData
    
    Data=Data';
    fields = [Name]';
    DataStruct = cell2struct(Data, fields, 1);


if(ischar(getfield(DataStruct,{1},get(handles.edit_all1,'String')))==1)
    Data1=rmfield(DataStruct,get(handles.edit_all1,'String'));
else
    Data1=DataStruct;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_raw,'String')))==1)
    Data2=rmfield(Data1,get(handles.edit_raw,'String'));
else
    Data2=Data1;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_decimated,'String')))==1)
    Data3=rmfield(Data2,get(handles.edit_decimated,'String'));
else
    Data3=Data2;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_range,'String')))==1)
    Data4=rmfield(Data3,get(handles.edit_range,'String'));
else
    Data4=Data3;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_preprocess,'String')))==1)
    Data5=rmfield(Data4,get(handles.edit_preprocess,'String'));
else
    Data5=Data4;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_all2,'String')))==1)
    Data6=rmfield(Data5,get(handles.edit_all2,'String'));
else
    Data6=Data5;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_pronyfit,'String')))==1)
    Data7=rmfield(Data6,get(handles.edit_pronyfit,'String'));
else
    Data7=Data6;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_pronymodes,'String')))==1)
    Data8=rmfield(Data7,get(handles.edit_pronymodes,'String'));
else
    Data8=Data7;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_poles,'String')))==1)
    Data9=rmfield(Data8,get(handles.edit_poles,'String'));
else
    Data9=Data8;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_polezero,'String')))==1)
    Data10=rmfield(Data9,get(handles.edit_polezero,'String'));
else
    Data10=Data9;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_sortedres,'String')))==1)
    Data11=rmfield(Data10,get(handles.edit_sortedres,'String'));
else
    Data11=Data10;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_allres,'String')))==1)
    Data12=rmfield(Data11,get(handles.edit_allres,'String'));
else
    Data12=Data11;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_seerror,'String')))==1)
    Data13=rmfield(Data12,get(handles.edit_seerror,'String'));
else
    Data13=Data12;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_energy,'String')))==1)
    Data14=rmfield(Data13,get(handles.edit_energy,'String'));
else
    Data14=Data13;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_all3,'String')))==1)
    Data15=rmfield(Data14,get(handles.edit_all3,'String'));
else
    Data15=Data14;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_comparepoles,'String')))==1)
    Data16=rmfield(Data15,get(handles.edit_comparepoles,'String'));
else
    Data16=Data15;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_compareres,'String')))==1)
    Data17=rmfield(Data16,get(handles.edit_compareres,'String'));
else
    Data17=Data16;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_compareseerror,'String')))==1)
    Data18=rmfield(Data17,get(handles.edit_compareseerror,'String'));
else
    Data18=Data17;
end

if(ischar(getfield(DataStruct,{1},get(handles.edit_compareenergy,'String')))==1)
    Data19=rmfield(Data18,get(handles.edit_compareenergy,'String'));
else
    Data19=Data18;
end
Exported_FileData=Data19;
    [exptfile, exptpath] = uiputfile( ...
        {'*.mat', 'All mat-Files (*.mat)'},...
        'Save as a file');
    if isequal(exptfile,0) | isequal(exptpath,0)
         ok = 0;
         return
    end
    if ~ismember('.',exptfile)
         exptfile = [exptfile '.mat'];
    end
     exptfullname=fullfile(exptpath,exptfile);
    save(exptfullname,'Exported_FileData','-mat');


% --- Executes on button press in push_cancel.
function push_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to push_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


% --- Executes on button press in chkbx_compareenergy.
function chkbx_compareenergy_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_compareenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_compareenergy


% --- Executes during object creation, after setting all properties.
function edit_compareenergy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_compareenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_compareenergy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_compareenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_compareenergy as text
%        str2double(get(hObject,'String')) returns contents of edit_compareenergy as a double


% --- Executes on button press in chkbx_energy.
function chkbx_energy_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_energy


% --- Executes during object creation, after setting all properties.
function edit_energy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_energy_Callback(hObject, eventdata, handles)
% hObject    handle to edit_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_energy as text
%        str2double(get(hObject,'String')) returns contents of edit_energy as a double


% --- Executes on button press in chkbx_range.
function chkbx_range_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_range


% --- Executes during object creation, after setting all properties.
function edit_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range as text
%        str2double(get(hObject,'String')) returns contents of edit_range as a double


% --- Executes on button press in chkbx_all.
function chkbx_all_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_all


% --- Executes during object creation, after setting all properties.
function edit_all1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_all1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_all1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_all1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_all1 as text
%        str2double(get(hObject,'String')) returns contents of edit_all1 as a double


% --- Executes on button press in chkbx_rawdata.
function chkbx_rawdata_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_rawdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_rawdata


% --- Executes during object creation, after setting all properties.
function edit_raw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_raw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_raw as text
%        str2double(get(hObject,'String')) returns contents of edit_raw as a double


% --- Executes on button press in chkbx_decimated.
function chkbx_decimated_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_decimated


% --- Executes during object creation, after setting all properties.
function edit_decimated_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_decimated_Callback(hObject, eventdata, handles)
% hObject    handle to edit_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_decimated as text
%        str2double(get(hObject,'String')) returns contents of edit_decimated as a double


% --- Executes on button press in chkbx_preprocess.
function chkbx_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_preprocess


% --- Executes during object creation, after setting all properties.
function edit_datapreprocess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_datapreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_datapreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to edit_datapreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_datapreprocess as text
%        str2double(get(hObject,'String')) returns contents of edit_datapreprocess as a double


% --- Executes on button press in txt_specific.
function txt_specific_Callback(hObject, eventdata, handles)
% hObject    handle to txt_specific (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of txt_specific


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes during object creation, after setting all properties.
function edit_all2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_all2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_all2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_all2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_all2 as text
%        str2double(get(hObject,'String')) returns contents of edit_all2 as a double


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes during object creation, after setting all properties.
function edit_all3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_all3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_all3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_all3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_all3 as text
%        str2double(get(hObject,'String')) returns contents of edit_all3 as a double


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit_comparedata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_all3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_comparedata_Callback(hObject, eventdata, handles)
% hObject    handle to edit_all3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_all3 as text
%        str2double(get(hObject,'String')) returns contents of edit_all3 as a double


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17


% --- Executes during object creation, after setting all properties.
function edit_comparepoles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_comparepoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_comparepoles_Callback(hObject, eventdata, handles)
% hObject    handle to edit_comparepoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_comparepoles as text
%        str2double(get(hObject,'String')) returns contents of edit_comparepoles as a double


% --- Executes on button press in chkbx_compareres.
function chkbx_compareres_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_compareres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_compareres


% --- Executes during object creation, after setting all properties.
function edit_compareres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_compareres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_compareres_Callback(hObject, eventdata, handles)
% hObject    handle to edit_compareres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_compareres as text
%        str2double(get(hObject,'String')) returns contents of edit_compareres as a double


% --- Executes on button press in chkbx_compareseerror.
function chkbx_compareseerror_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_compareseerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_compareseerror


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes on button press in checkbox23.
function checkbox23_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox23


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes on button press in chkbx_raw.
function chkbx_raw_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_raw


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit_raw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_raw as text
%        str2double(get(hObject,'String')) returns contents of edit_raw as a double


% --- Executes on button press in chkbx_decimated.
function checkbox25_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_decimated


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit_decimated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_decimated as text
%        str2double(get(hObject,'String')) returns contents of edit_decimated as a double


% --- Executes on button press in chkbx_preprocess.
function checkbox26_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_preprocess


% --- Executes during object creation, after setting all properties.
function edit_preprocess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to edit_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_preprocess as text
%        str2double(get(hObject,'String')) returns contents of edit_preprocess as a double


% --- Executes on button press in chkbx_all1.
function chkbx_all1_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_all1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_all1


% --- Executes on button press in chkbx_all3.
function chkbx_all3_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_all3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_all3


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_all2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit_all2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_all2 as text
%        str2double(get(hObject,'String')) returns contents of edit_all2 as a double


% --- Executes on button press in chkbx_pronyfit.
function chkbx_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_pronyfit


% --- Executes during object creation, after setting all properties.
function edit_pronyfit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pronyfit as text
%        str2double(get(hObject,'String')) returns contents of edit_pronyfit as a double


% --- Executes on button press in chkbx_pronymodes.
function chkbx_pronymodes_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_pronymodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_pronymodes


% --- Executes during object creation, after setting all properties.
function edit_pronymodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pronymodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_pronymodes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pronymodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pronymodes as text
%        str2double(get(hObject,'String')) returns contents of edit_pronymodes as a double


% --- Executes on button press in chkbx_poles.
function chkbx_poles_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_poles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_poles


% --- Executes during object creation, after setting all properties.
function edit_poles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_poles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_poles_Callback(hObject, eventdata, handles)
% hObject    handle to edit_poles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_poles as text
%        str2double(get(hObject,'String')) returns contents of edit_poles as a double


% --- Executes on button press in chkbx_all2.
function chkbx_all2_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_all2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_all2


% --- Executes on button press in chkbx_sortedres.
function chkbx_sortedres_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_sortedres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_sortedres


% --- Executes during object creation, after setting all properties.
function edit_sortedres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sortedres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_sortedres_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sortedres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sortedres as text
%        str2double(get(hObject,'String')) returns contents of edit_sortedres as a double


% --- Executes on button press in chkbx_polezero.
function chkbx_polezero_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_polezero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_polezero


% --- Executes during object creation, after setting all properties.
function edit_polezero_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_polezero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_polezero_Callback(hObject, eventdata, handles)
% hObject    handle to edit_polezero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_polezero as text
%        str2double(get(hObject,'String')) returns contents of edit_polezero as a double


% --- Executes on button press in chkbx_allres.
function chkbx_allres_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_allres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_allres


% --- Executes during object creation, after setting all properties.
function edit_allres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_allres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_allres_Callback(hObject, eventdata, handles)
% hObject    handle to edit_allres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_allres as text
%        str2double(get(hObject,'String')) returns contents of edit_allres as a double


% --- Executes on button press in chkbx_seerror.
function chkbx_seerror_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_seerror


% --- Executes during object creation, after setting all properties.
function edit_seerror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_seerror_Callback(hObject, eventdata, handles)
% hObject    handle to edit_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_seerror as text
%        str2double(get(hObject,'String')) returns contents of edit_seerror as a double


% --- Executes on button press in chkbx_comparepoles.
function chkbx_comparepoles_Callback(hObject, eventdata, handles)
% hObject    handle to chkbx_comparepoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkbx_comparepoles


% --- Executes during object creation, after setting all properties.
function edit_compareseerror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_compareseerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_compareseerror_Callback(hObject, eventdata, handles)
% hObject    handle to edit_compareseerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_compareseerror as text
%        str2double(get(hObject,'String')) returns contents of edit_compareseerror as a double


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_pronytool_Callback(hObject, eventdata, handles)
% hObject    handle to menu_pronytool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath = which ('pronytoolhelp.html');
web(HelpPath,'-browser');

% --------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath = which ('about.html');
web(HelpPath,'-browser'); 


% --------------------------------------------------------------------
function menu_demos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_demos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HelpPath = which ('demos.html');
web(HelpPath,'-browser');




