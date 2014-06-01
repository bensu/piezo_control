function varargout = pronyanalysistool(varargin)
% PRONYANALYSISTOOL M-file for pronyanalysistool.fig
%      PRONYANALYSISTOOL, by itself, creates a new PRONYANALYSISTOOL or raises the existing
%      singleton*.
%
%      H = PRONYANALYSISTOOL returns the handle to a new PRONYANALYSISTOOL or the handle to
%      the existing singleton*.
%
%      PRONYANALYSISTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRONYANALYSISTOOL.M with the given input arguments.
%
%      PRONYANALYSISTOOL('Property','Value',...) creates a new PRONYANALYSISTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pronyanalysistool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pronyanalysistool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pronyanalysistool

% Last Modified by GUIDE v2.5 15-May-2003 15:12:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pronyanalysistool_OpeningFcn, ...
                   'gui_OutputFcn',  @pronyanalysistool_OutputFcn, ...
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


% --- Executes just before pronyanalysistool is made visible.
function pronyanalysistool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pronyanalysistool (see VARARGIN)

% Choose default command line output for pronyanalysistool
handles.output = hObject;
% Set the background of the figure to Black
%whitebg('white');
%colordef white;
set(hObject,'Color','white');
% Set the toolbar for the figure
pronytoolbar(hObject,'on');
% Set the default for decimation as off
set(handles.rdbutton_off,'Value',1);
% Set the default for data range as off
set(handles.rdbutton_rangeoff,'Value',1);
% Set the starting colors of axes as black

% Set the flag if signal is decimated
handles.exportout=0;
handles.flagdecimate=0;
handles.filename=0;
handles.pathname=0;
handles.preprocessid=0;
handles.window_x=0;
handles.window_y=0;
handles.flagwindow=0;
handles.dp_x=0;
handles.dp_y=0;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes pronyanalysistool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pronyanalysistool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.exportout;

% --- Executes on button press in push_importdata.
function push_importdata_Callback(hObject, eventdata, handles)
% hObject    handle to push_importdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uiimport;

%--Enable the Orignal Data Plot push button
set(handles.push_plot,'Enable','on'); 
setstatus(gcbf,'Select Variables and Press "Plot"');
[filename, pathname] = uigetfile( ...
    {'*.mat', 'All MAT-Files (*.mat)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Data File');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise load the file.
else
    cd (pathname);
    vars=load(eval('filename'));
    assignin('base','vars',vars);
    newvars = evalin('base','fieldnames(vars)');
    % Unpack the struct vars in base. mmv2struct function is taken from
    % Mastering MATLAB book
    evalin('base','mmv2struct(vars)');
end
    % update the listbox
    set(handles.lstbx_depvar,'String',newvars)
    set(handles.lstbx_indepvar,'String',newvars)
    handles.filename=filename;
    handles.pathname=pathname;
    guidata(hObject,handles);
    
function [x,y,x_val,y_val] = get_var_names(handles)
% Returns the names of the two variables to plot
list_entries1 = get(handles.lstbx_depvar,'String');
index_selected1 = get(handles.lstbx_depvar,'Value');
list_entries2 = get(handles.lstbx_indepvar,'String');
index_selected2 = get(handles.lstbx_indepvar,'Value');
if length(index_selected1) ~= 1
    errordlg('You Must Select Only One Variable','Incorrect Selection','modal')
else
    x = list_entries1{index_selected1(1)};
end 

if length(index_selected2) ~= 1
    errordlg('You Must Select Only One Variable','Incorrect Selection','modal')
else
    y= list_entries2{index_selected2(1)};
end 
x_val=evalin('base',x);
y_val=evalin('base',y);
% Check whether data is a column vector or not
% if it is row vector convert it to column vector
if(size(x_val,1)==1)
   x_val=x_val';
end
if(size(y_val,1)==1)
   y_val=y_val';
end
   
    
function varargout = push_plot_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to push_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_data);
[x,y,x_val,y_val] = get_var_names(handles);
plot(x_val,y_val,'b');
xlabel('Time'),ylabel('Signal'), title('Original Data Plot');
[deci_x,deci_y,dfactor]=decimate_data(handles);
handles.window_x=deci_x;
handles.window_y=deci_y;
guidata(hObject,handles);
 %--Enable the data preprocessing popup menu 
set([handles.edit_sample,handles.rdbutton_on,handles.rdbutton_off,handles.push_decimate],'Enable','on');
setstatus(gcbf,'Apply "Decimation"');
    
    
    
% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


function mutual_exclude(off)
    set(off,'Value',0)

% --- Executes on button press in rdbutton_on.
function rdbutton_on_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_on
mutual_exclude(handles.rdbutton_off) ;
handles.flagdecimate=1;
guidata(hObject, handles);



% --- Executes on button press in rdbutton_off.
function rdbutton_off_Callback(hObject, eventdata, handles)

% hObject    handle to rdbutton_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_off
mutual_exclude(handles.rdbutton_on) ;
handles.flagdecimate=0;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit_sample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_sample_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sample as text
%        str2double(get(hObject,'String')) returns contents of edit_sample as a double


% --- Executes on button press in push_decimate.
function push_decimate_Callback(hObject, eventdata, handles)
% hObject    handle to push_decimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
[deci_x,deci_y,dfactor]=decimate_data(handles);
 axes(handles.axes_data);
 plot(deci_x,deci_y,'b');
if (get(handles.rdbutton_on,'Value') == get(handles.rdbutton_on,'Max'))
    xlabel('Time'), ylabel('Decimated Signal'),...
    title(sprintf('Signal after Down Sampling of %d ',dfactor));
else
    xlabel('Time'),ylabel('Original Signal'),...
    title('No Decimation is Applied');
end
    handles.window_x=deci_x;
    handles.window_y=deci_y;
    guidata(hObject,handles);
set([handles.rdbutton_rangeon,handles.rdbutton_rangeoff,handles.push_range],'Enable','on')
setstatus(gcbf,'Specify the Data Range');   
    



function[deci_x,deci_y,dfactor]= decimate_data(handles)

[x,y,x_val,y_val] = get_var_names(handles);
dfactor= round(str2num(get(handles.edit_sample,'String')));

if (get(handles.rdbutton_on,'Value') == get(handles.rdbutton_on,'Max'))
    deci_x=x_val(1:dfactor:length(x_val));
    deci_y=y_val(1:dfactor:length(y_val));
else
    deci_x=x_val;
    deci_y=y_val;
end



% --- Executes on button press in push_pronyanalysis.
function push_pronyanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to push_pronyanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PronyData=export_data(handles);
assignin('base','PronyData',PronyData);
performprony;


function [PronyData]=export_data(handles)
    [x,y,x_val,y_val] = get_var_names(handles);
    [deci_x,deci_y,dfactor]= decimate_data(handles);
    PronyData = struct('filename',[],'pathname',[],...
		'depvariable',[],'indepvariable',[],'x_val',[],'y_val',[],...
        'flagdecimate',[],'dfactor',[],...
        'deci_x',[],'deci_y',[],'preprocessid',[],'flagwindow',[],...
        'window_x',[],'window_y',[],'dp_x',[],'dp_y',[]);
    % save export data
    PronyData.filename=handles.filename;
    PronyData.pathname=handles.pathname;
    PronyData.indepvariable=x;
    PronyData.depvariable=y;
    PronyData.x_val=x_val;
    PronyData.y_val=y_val;
    PronyData.flagdecimate=handles.flagdecimate;
    PronyData.dfactor=dfactor;
    PronyData.deci_x=deci_x;
    PronyData.deci_y=deci_y;
    PronyData.preprocessid=handles.preprocessid;
    PronyData.flagwindow=handles.flagwindow;
    PronyData.window_x=handles.window_x;
    PronyData.window_y=handles.window_y;
    PronyData.dp_x=handles.dp_x;
    PronyData.dp_y=handles.dp_y;
    

% --- Executes on button press in rdbutton_rangeoff.
function rdbutton_rangeoff_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_rangeoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_rangeoff
mutual_exclude(handles.rdbutton_rangeon) ;
 

% --- Executes on button press in rdbutton_rangeon.
function rdbutton_rangeon_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_rangeon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_rangeon
mutual_exclude(handles.rdbutton_rangeoff) ;

% --- Executes on button press in push_range.
function push_range_Callback(hObject, eventdata, handles)
% hObject    handle to push_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set([handles.push_datapreprocess,handles.ppmnu_datapreprocess],'Enable','on')
[deci_x,deci_y,dfactor]=decimate_data(handles);
if (get(handles.rdbutton_rangeon,'Value') == get(handles.rdbutton_rangeon,'Max')) 
    setstatus(gcbf,'Press Left Mouse Button to Choose 2 Points in Original Data Plot');
    [handles.window_x,handles.window_y]= windowing_data(deci_x,deci_y);
    handles.flagwindow=1;
    guidata(hObject, handles);
    axes(handles.axes_data_process);
    plot(handles.window_x,handles.window_y,'b');
    xlabel('Time'), ylabel('Signal'),...
    title('Signal of defined Data Range');
end

if (get(handles.rdbutton_rangeoff,'Value') == get(handles.rdbutton_rangeoff,'Max'))
    
    handles.window_x=deci_x;   
    handles.window_y=deci_y;
    handles.flagwindow=0;
    guidata(hObject, handles);
    axes(handles.axes_data_process);
    plot(handles.window_x,handles.window_y,'b');
    xlabel('Time'), ylabel('Signal'),...
    title('No Data Range is Applied');
end
setstatus(gcbf,'Apply the "Data Preprocessing" '); 

% --- Executes on selection change in ppmnu_datapreprocess.
function ppmnu_datapreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to ppmnu_datapreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ppmnu_datapreprocess contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ppmnu_datapreprocess


% --- Executes on button press in push_datapreprocess.
function push_datapreprocess_Callback(hObject, eventdata, handles)
% hObject    handle to push_datapreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y,x_val,y_val] = get_var_names(handles);
    val = get(handles.ppmnu_datapreprocess,'Value');  
    switch val
        case 1 % The user selected the remove mean
            [dp_x,dp_y]=remove_mean(handles.window_x,handles.window_y,y);
            preprocessid=1;

        case 2 % The user selected the no change
            dp_x=handles.window_x; dp_y=handles.window_y;
            preprocessid=2;    
    
        case 3 % The user selected the Detrend
            dp_x=handles.window_x;
            dp_y=detrend(handles.window_y);
            preprocessid=3;
    end
    handles.preprocessid=preprocessid;
    %--Enable the Prony Analysis push button
    set(handles.push_pronyanalysis,'Enable','on');
    handles.dp_x=dp_x;
    handles.dp_y=dp_y;
    guidata(hObject,handles);
    axes(handles.axes_data_process);
    plot(dp_x,dp_y,'b');
    xlabel('Time'), ylabel('Signal');
    switch preprocessid
        case 1
            title('Signal after Removing Mean')
        case 2
            title('No Changes in the Decimated / Specific Range Signal')
        case 3
            title('Signal after Detrending')
        case 4
            title('Signal after Windowing')
    end
    setstatus(gcbf,'Press " Perform Prony Analysis"');

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


% --------------------------------------------------------------------
function cmenu_data_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_data_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_plotnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function cmenu_data_process_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_data_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_data_process_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_data_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function plotnew_deci_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_deci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the Decimated Signal
PronyData=export_data(handles);
figure('Color','White');
plot(PronyData.deci_x,PronyData.deci_y);
xlabel('Time'), ylabel('Decimated Signal'),...
if(handles.flagdecimate==1)    
    title(sprintf('Signal after Down Sampling of %d ',PronyData.dfactor));
else
    title('No Decimation is Applied');
end

% --------------------------------------------------------------------
function plotnew_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Plot the Preprocessed Signal
PronyData=export_data(handles);
figure('Color','White');
plot(PronyData.dp_x,PronyData.dp_y);
xlabel('Time'), ylabel('Preprocessed Signal'),...
title('Signal after Data Preprocessing ');

% --- Executes on selection change in lstbx_depvar.
function lstbx_depvar_Callback(hObject, eventdata, handles)
% hObject    handle to lstbx_depvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstbx_depvar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstbx_depvar

% --- Executes during object creation, after setting all properties.
function lstbx_depvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstbx_depvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function lstbx_indepvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstbx_indepvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in lstbx_indepvar.
function lstbx_indepvar_Callback(hObject, eventdata, handles)
% hObject    handle to lstbx_indepvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstbx_indepvar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstbx_indepvar


% --- Executes during object creation, after setting all properties.
function ppmnu_datapreprocess_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppmnu_datapreprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function axes_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_data




% --------------------------------------------------------------------
function menu_gridoff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes_data_process);
grid off;
axes(handles.axes_data);
grid off;

% --------------------------------------------------------------------
function menu_gridon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes_data_process);
grid on;
axes(handles.axes_data);
grid on;

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_view_Callback(hObject, eventdata, handles)
% hObject    handle to menu_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_close_Callback(hObject, eventdata, handles)
% hObject    handle to menu_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes during object creation, after setting all properties.
function Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --------------------------------------------------------------------
function plotnew_orig_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_orig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PronyData=export_data(handles);
figure('Color','White');
plot(PronyData.x_val,PronyData.y_val);
xlabel('Time'), ylabel('Original Signal'),...
title('Original Signal Plot ');

% --------------------------------------------------------------------
function plotnew_window_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_orig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PronyData=export_data(handles);
figure('Color','White');
plot(PronyData.window_x,PronyData.window_y);
xlabel('Time'), ylabel('Signal');
if(handles.flagwindow==1)
    title('Specific Data Range Signal Plot ');
else
    title('No Data Range is Applied');
end



    

