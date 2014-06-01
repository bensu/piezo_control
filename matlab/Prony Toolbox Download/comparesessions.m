function varargout = comparesessions(varargin)
% Implements Compare Sessions GUI
% COMPARESESSIONS M-file for comparesessions.fig
%      COMPARESESSIONS, by itself, creates a new COMPARESESSIONS or raises the existing
%      singleton*.
%
%      H = COMPARESESSIONS returns the handle to a new COMPARESESSIONS or the handle to
%      the existing singleton*.
%
%      COMPARESESSIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARESESSIONS.M with the given input arguments.
%
%      COMPARESESSIONS('Property','Value',...) creates a new COMPARESESSIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comparesessions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comparesessions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comparesessions

% Last Modified by GUIDE v2.5 22-May-2003 12:54:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comparesessions_OpeningFcn, ...
                   'gui_OutputFcn',  @comparesessions_OutputFcn, ...
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


% --- Executes just before comparesessions is made visible.
function comparesessions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comparesessions (see VARARGIN)

% Choose default command line output for comparesessions
handles.output = hObject;
% Set the background of the figure to White
set(hObject,'Color','white');
% Set the toolbar for the figure
pronytoolbar(hObject,'on');
% Flag to check if the GUI is picking up data from file or from workspace
handles.flag_menuopen=0;
handles.idennz_mat=0;
handles.Index_Selected=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comparesessions wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = comparesessions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function lstbx_session_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstbx_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in lstbx_session.
function lstbx_session_Callback(hObject, eventdata, handles)
% hObject    handle to lstbx_session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstbx_session contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstbx_session


% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --------------------------------------------------------------------
function menu_compareset_Callback(hObject, eventdata, handles)
% hObject    handle to menu_compareset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_open_Callback(hObject, eventdata, handles)
% hObject    handle to menu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Flag to check if the GUI is picking up data from file or from workspace

% Update handles structure

[filename, pathname] = uigetfile( ...
    {'*.cmp', 'All CMP-Files (*.cmp)'},...
    'Open Prony Comparator File');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    handles.flag_menuopen=0;
    guidata(hObject, handles);
    return
    % Otherwise load the file.
else
    cd (pathname);
    CmpData=load(eval('filename'),'-mat');
    assignin('base','CmpData',CmpData);
    handles.flag_menuopen=1;
    guidata(hObject, handles);
end
setstatus(gcbf,'Select Sessions from Listbox and Choose an Option from "Plots"');
set(handles.ppmenu_plots,'enable','on');
maxNum=evalin('base','CmpData.maxNum');
SaveData=evalin('base','CmpData.SaveData');
[promptstr]=  prepare_comparelist(maxNum,SaveData);
set(handles.lstbx_session,'String',promptstr)

% --------------------------------------------------------------------
function menu_close_Callback(hObject, eventdata, handles)
% hObject    handle to menu_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --------------------------------------------------------------------
function menu_view_Callback(hObject, eventdata, handles)
% hObject    handle to menu_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setstatus(gcbf,'Select Sessions from Listbox and Choose an Option from "Plots"');
set(handles.ppmenu_plots,'enable','on');
maxNum=evalin('base','maxNum');
SaveData=evalin('base','SaveData');
[promptstr]=  prepare_comparelist(maxNum,SaveData);
set(handles.lstbx_session,'ForegroundColor','black');
set(handles.lstbx_session,'String',promptstr);



% --- Executes during object creation, after setting all properties.
function ppmenu_plots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppmenu_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ppmenu_plots.
function ppmenu_plots_Callback(hObject, eventdata, handles)
% hObject    handle to ppmenu_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ppmenu_plots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ppmenu_plots

% --- Executes on button press in push_compareplots.
function push_compareplots_Callback(hObject, eventdata, handles)
% hObject    handle to push_compareplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    %evalin('base','clc');
    if(handles.flag_menuopen==1)
        SaveData=evalin('base','CmpData.SaveData');
    else
        SaveData=evalin('base','SaveData');
    end
    Index_Selected=get(handles.lstbx_session,'Value');
    handles.Index_Selected=Index_Selected;
    guidata(hObject, handles);
    % Get the column size of Index_Selected
    Run_limit=size(Index_Selected,2);
    % if nothing is selected
    if (isempty(Index_Selected))
        errordlg('Please Select the Sessions to be Compared','No Session Selected !!');
        whitebg('white'); 
    end
    
    for index=1:Run_limit
        Run=Index_Selected(index);
        mode_sizes(index)=SaveData(Run).modes;
    end
        max_modes=max(mode_sizes);
        
    
val=get(handles.ppmenu_plots,'Value');
switch val
    case 1 % poles plot
        
        for index=1:Run_limit
            Run=Index_Selected(index);
            [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run);
            [inummz,idennz]=residuez(a_list(SUB_IND),p(SUB_IND),1);
            [z,p,k] = tf2zp(inummz,idennz);
            p_size=size(p,1); % Get the column size of p
            diff_size=max_modes-p_size;
            if (p_size<max_modes)
                dummy(1:diff_size,1)=-9;   % Create dummy poles of -9
                dummy_rowsize=size(dummy,1);
                if(dummy_rowsize>diff_size)
                    dummy_new=dummy(1:diff_size);
                else
                    dummy_new=dummy(1:diff_size);
                end
                p1=vertcat(p,dummy_new);
            else
                p1=p;
            end
            idennz_mat(:,index)=p1;
        end
        zplane(-9,idennz_mat,{'w^','x'});  % dummy zero at -9
        axis([-1.1 1.1 -1.1 1.1]);xlabel('Real Part'), ylabel('Imaginary Part');
        title('Poles Plot');
        legend_poles(handles,Index_Selected,Run_limit);
        handles.idennz_mat=idennz_mat;
        % Update handles structure
        guidata(hObject, handles);
        
        
    case 2 % Squared Error
        S=['m:';'b-';'y:';'r-';'g:'];
        row_S=size(S,1);
        
        for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            Run=Index_Selected(index);
            [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run);
            seerror=(dp_y(:)-ai(:)).^2;
            axes(handles.axes_pole);
            plot(dp_x,seerror,S(colorindex));
            hold on;
        end
         xlabel('Time'), ylabel('Squared Error')
         title('Squared Error Plot');
         legend_seerror(handles,Index_Selected,Run_limit);
         hold off;
            
     case 3 % Residue Plot
         S=['m:';'b-';'y:';'r-';'g:'];
         row_S=size(S,1);
         for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            Run=Index_Selected(index);
            [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run);
            SUB_N=size(SUB_IND,2);
            aa_list=abs(2*a_list(SUB_IND'));
            axes(handles.axes_pole);
            Index=1:SUB_N;
            semilogy(Index,aa_list,S(colorindex))
            if(Run_limit==1)
                axis([0 max(SUB_N)+1 0 1.1*max(aa_list)]);
            end
            hold on;
        end
        xlabel('Index'), ylabel('Residue Magnitude')
        title('Prony Residue Magnitude "Decay"')
        legend_seerror(handles,Index_Selected,Run_limit);
        hold off;
        
   case 4 % Energy Plot
         S=['m:';'b-';'y:';'r-';'g:'];
         row_S=size(S,1);
         for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            Run=Index_Selected(index);
            [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run);
            axes(handles.axes_pole);
            index=1:size(SUB_IND,2);
            energy_size=size(energy,2);
            semilogy(index,energy,S(colorindex));
            axis([0 energy_size+1 0 1.1*max(energy)]);
            hold on;
        end
        xlabel('Index'),ylabel('Energy')
        title('Energy of Prony Modes');
        legend_seerror(handles,Index_Selected,Run_limit);
        hold off;
end % switch end

% Legend for the Poles plot
function legend_poles(handles,Index_Selected,Run_limit)
        string_matrix=sprintf('Poles Only ');
        for index=1:Run_limit
            if(Index_Selected(:)>=10)
                string_matrix=[string_matrix; sprintf('Session %d ',Index_Selected(index))];
            else
                string_matrix=[string_matrix; sprintf('Session %2d ',Index_Selected(index))];
            end
        end
        legend(string_matrix,-1);
        
% Legend for the squared error, residues and energy plot        
        
function legend_seerror(handles,Index_Selected,Run_limit)
        
        string_matrix=sprintf('  Session %2d  ',Index_Selected(1));
            for index=2:Run_limit
                if(Index_Selected(:)>=10)
                    string_matrix=[string_matrix; sprintf('  Session %d  ',Index_Selected(index))];
                else
                    string_matrix=[string_matrix; sprintf('  Session %2d  ',Index_Selected(index))];
                end
            end
        legend(string_matrix,-1);
        


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
function menu_gridoff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes_pole);
grid off;

% --------------------------------------------------------------------
function menu_gridon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


axes(handles.axes_pole);
grid on;


% --------------------------------------------------------------------
function plotnew_poles_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_poles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        % Get the column size of Index_Selected
        [IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles);
        Run_limit=size(Index_Selected,2);
        for index=1:Run_limit
            p=IIIGuiData(index).poles;
            p_size=size(p,1); % Get the column size of p
            diff_size=max_modes-p_size;
            if (p_size<max_modes)
                dummy(1:diff_size,1)=-9;   % Create dummy poles of -9
                dummy_rowsize=size(dummy,1);
                if(dummy_rowsize>diff_size)
                    dummy_new=dummy(1:diff_size);
                else
                    dummy_new=dummy(1:diff_size);
                end
                p1=vertcat(p,dummy_new);
            else
                p1=p;
            end
            idennz_mat(:,index)=p1;
        end
        figure('Color','White'),zplane(-9,idennz_mat,{'w^','x'});  % dummy zero at -9
        axis([-1.1 1.1 -1.1 1.1]);xlabel('Real Part'), ylabel('Imaginary Part');
        title('Poles Plot');
        legend_poles(handles,Index_Selected,Run_limit);
        
% --------------------------------------------------------------------
function plotnew_seerror_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        [IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles);
        Run_limit=size(Index_Selected,2);
        S=['m:';'b-';'k:';'r-';'g:'];
        row_S=size(S,1);
        figure('Color','White');
        for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            plot(IIIGuiData(index).x_data,IIIGuiData(index).seerror,S(colorindex));
            hold on;
        end
         xlabel('Time'), ylabel('Squared Error')
         title('Squared Error Plot');
         legend_seerror(handles,Index_Selected,Run_limit);
         hold off;

% --------------------------------------------------------------------
function plotnew_res_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_res (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
         [IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles);
         Run_limit=size(Index_Selected,2);
         S=['m:';'b-';'k:';'r-';'g:'];
         row_S=size(S,1);
         figure('Color','White');
         for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            new_index=1:IIIGuiData(index).SUB_N;
            aa_list=IIIGuiData(index).residues;
            semilogy(new_index,aa_list,S(colorindex))
            if(Run_limit==1)
                axis([0 max(new_index)+1 0 1.1*max(aa_list)]);
            end
            hold on;
        end
        xlabel('Index'), ylabel('Residue Magnitude')
        title('Prony Residue Magnitude "Decay"')
        legend_seerror(handles,Index_Selected,Run_limit);
        hold off;

% --------------------------------------------------------------------
function plotnew_energy_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_energy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
         [IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles); 
         Run_limit=size(Index_Selected,2);
         S=['m:';'b-';'k:';'r-';'g:'];
         row_S=size(S,1);
         figure('Color','White');
         for index=1:Run_limit
            colorindex=mod(index,row_S);% limit colorindex to the row size of S
            % avoid zero value of colorindex, it will happen when row_
            if (colorindex==0)
                colorindex=row_S;
            end
            new_index=1:IIIGuiData(index).SUB_N;
            energy=IIIGuiData(index).energy;
            energy_size=size(energy,2);
            semilogy(new_index,energy,S(colorindex));
            axis([0 energy_size+1 0 1.1*max(energy)]);
            hold on;
        end
        xlabel('Index'),ylabel('Energy')
        title('Energy of Prony Modes');
        legend_seerror(handles,Index_Selected,Run_limit);
        hold off;

% --------------------------------------------------------------------
function Cmenu_plots_Callback(hObject, eventdata, handles)
% hObject    handle to Cmenu_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Plot_new_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles)
    
    IIIGuiData = struct('runname',[],...
        'poles',[],'residues',[],...
        'energy',[],'seerror',[],'x_data',[],'SUB_N',[]);
    ResultNum = 1;
    % save export data
   if(handles.flag_menuopen==1)
        SaveData=evalin('base','CmpData.SaveData');
    else
        SaveData=evalin('base','SaveData');
    end
    Index_Selected=get(handles.lstbx_session,'Value');
    % Get the column size of Index_Selected
    Run_limit=size(Index_Selected,2);
    % if nothing is selected
    if (isempty(Index_Selected))
        errordlg('Please Select the Sessions to be Compared','No Session Selected !!');
        whitebg('k'); 
    end
    
        for index=1:Run_limit
            Run=Index_Selected(index);
            mode_sizes(index)=SaveData(Run).modes;
        end
         
         max_modes=max(mode_sizes);
         for index=1:Run_limit
             Run=Index_Selected(index);
            [dp_x,dp_y,ai,a_list,SUB_IND,p,energy]= preparecomparedata(SaveData,Run);
            seerror=(dp_y(:)-ai(:)).^2;
            IIIGuiData(index).runname=['Session ',num2str(Run)];
            IIIGuiData(index).seerror=seerror;
            IIIGuiData(index).x_data=dp_x;
            [inummz,idennz]=residuez(a_list(SUB_IND),p(SUB_IND),1);
            [z,p,k] = tf2zp(inummz,idennz);
            IIIGuiData(index).poles=p;
            aa_list=abs(2*a_list(SUB_IND'));
            IIIGuiData(index).SUB_N=size(SUB_IND,2);
            IIIGuiData(index).residues=aa_list;
            IIIGuiData(index).energy=energy;
        end
        
  


% --------------------------------------------------------------------
function menu_export_Callback(hObject, eventdata, handles)
% hObject    handle to menu_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[IIIGuiData,Index_Selected,max_modes]=export_compare_data(handles);
assignin('base','IIIGuiData',IIIGuiData);
exportresults;


% --------------------------------------------------------------------
function menu_data_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


