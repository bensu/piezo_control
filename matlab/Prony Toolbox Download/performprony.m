function varargout = performprony(varargin)
% PERFORMPRONY M-file for performprony.fig
%      PERFORMPRONY, by itself, creates a new PERFORMPRONY or raises the existing
%      singleton*.
%
%      H = PERFORMPRONY returns the handle to a new PERFORMPRONY or the handle to
%      the existing singleton*.
%
%      PERFORMPRONY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERFORMPRONY.M with the given input arguments.
%
%      PERFORMPRONY('Property','Value',...) creates a new PERFORMPRONY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before performprony_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to performprony_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help performprony

% Last Modified by GUIDE v2.5 06-Jul-2003 20:56:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @performprony_OpeningFcn, ...
                   'gui_OutputFcn',  @performprony_OutputFcn, ...
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



% --- Executes just before performprony is made visible.
function performprony_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to performprony (see VARARGIN)

% Choose default command line output for performprony
handles.output = hObject;


% Set the background of the figure to Black
% Set the background of the figure to Black
%whitebg('white');
%colordef white;
set(hObject,'Color','white');
% Have the toolbar
pronytoolbar(hObject,'on');
% Flag to check if the user has saved any session
handles.menu_saveflag=0;
handles.menu_saveasflag=0;
handles.test_time=evalin('base','PronyData.dp_x');
handles.test_data=evalin('base','PronyData.dp_y');
handles.criteria_val = get(handles.ppmenu_criteria,'Value');
% Set the starting colors of axes as black
%set(handles.axes_pronyfit,'XColor','k');
%set(handles.axes_pronyfit,'YColor','k');
%set(handles.axes_modesfit,'XColor','k');
%set(handles.axes_modesfit,'YColor','k');
%set(handles.axes_seerror,'XColor','k');
%set(handles.axes_seerror,'YColor','k');
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes performprony wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = performprony_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
 %set(hObject,'BackgroundColor',[0.5 0.5 0.5]);


% --- Executes on button press in rdbutton_mordertime.
function rdbutton_mordertime_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_mordertime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_mordertime
mutual_exclude(handles.rdbutton_morderfreq) ;


% --- Executes on button press in rdbutton_morderfreq.
function rdbutton_morderfreq_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_morderfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_morderfreq
mutual_exclude(handles.rdbutton_mordertime) ;


% --- Executes on button press in push_morder.
function push_morder_Callback(hObject, eventdata, handles)
% hObject    handle to push_morder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setstatus(gcbf,'Choose "Model Order Selection" Criteria');
set([handles.rdbutton_time,handles.rdbutton_frequency,handles.ppmenu_criteria,handles.edittxtmodes],'enable','on');
set(handles.ppmenu_modesfit,'enable','on');
% Set the default for model order graphic mode as time domain
if (get(handles.rdbutton_morderfreq,'Value') == get(handles.rdbutton_morderfreq,'Min'))
    set(handles.rdbutton_mordertime,'Value',1);
end
FirstResults=save_FirstResults(handles);
axes(handles.axes_pronyfit);
    % implement time domain prony
    if (get(handles.rdbutton_mordertime,'Value') == get(handles.rdbutton_mordertime,'Max'))
        plot(handles.test_time,FirstResults.iapp,'r',handles.test_time,handles.test_data,'b');xlabel('Time');
        ylabel('Signal');
        title(sprintf('Prony Analysis of Model Order %d in Time Domain',FirstResults.NewVal))
        legend('Prony Approximate', 'Measured')
    end
     % implement frequency domain prony
     if (get(handles.rdbutton_morderfreq,'Value') == get(handles.rdbutton_morderfreq,'Max'))
        [f,fft_data_plot,fft_iapp_plot]= fft_analysis(handles.test_time,handles.test_data,FirstResults.iapp);
        plot(f,fft_iapp_plot,'r',f,fft_data_plot,'b');xlabel('Frequency');
        ylabel('  Magnitude (dB)  ');
        title(sprintf('Prony Analysis of Model Order %d in Frequency Domain',FirstResults.NewVal))
        legend('Prony Approximate', 'Measured')
    end


function[FirstResults]= save_FirstResults(handles)
    NewVal=fetch_NewVal(handles);
    [iapp,ai,a_list,tau_list,omega_list,SUB_IND,energy,p]=applyprony(handles.test_time,handles.test_data,NewVal,0,1);
    FirstResults =struct('NewVal',[],'iapp',[],'ai',[],...
		             'a_list',[],'tau_list',[],'omega_list',[],...
                     'SUB_IND',[],'energy',[],'p',[]);
    FirstResults.NewVal=NewVal;
    FirstResults.iapp = iapp;
    FirstResults.a_list=a_list;
    FirstResults.tau_list=tau_list;
    FirstResults.omega_list=omega_list;
    FirstResults.SUB_IND=SUB_IND;
    FirstResults.energy=energy;
    FirstResults.p=p;
    FirstResults.ai=ai;



function mutual_exclude(off)
    set(off,'Value',0)
% --- Executes on button press in rdbutton_time.
function rdbutton_time_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_time
mutual_exclude(handles.rdbutton_frequency) ;

% --- Executes on button press in rdbutton_frequency.
function rdbutton_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to rdbutton_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdbutton_frequency
mutual_exclude(handles.rdbutton_time) ;

% --- Executes during object creation, after setting all properties.
function ppmenu_criteria_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppmenu_criteria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in push_mode.
function push_mode_Callback(hObject, eventdata, handles)
% hObject    handle to push_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.criteria_val = get(handles.ppmenu_criteria,'Value');
 guidata(hObject,handles); % store the changes
 % Set the default for modes selection graphic mode as time domain
if (get(handles.rdbutton_frequency,'Value') == get(handles.rdbutton_frequency,'Min'))
    set(handles.rdbutton_time,'Value',1);
end
PronyResults=getPronyResults(handles);
promptstr=perform_resultslist(handles.test_time,handles.test_data,PronyResults.NewVal,PronyResults.SUB_N,handles.criteria_val);
set(handles.lstbx_numeric,'String',promptstr); 
perform_plotcriteria(handles,PronyResults);
set(handles.ppmenu_modesfit,'Value',1);
set(handles.lstbx_numeric,'Value',1);

% --- Executes on selection change in ppmenu_criteria.
function ppmenu_criteria_Callback(hObject, eventdata, handles)
% hObject    handle to ppmenu_criteria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ppmenu_criteria contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ppmenu_criteria

%-------------------------------------------------------------
function perform_plotcriteria(handles,Results)
    switch handles.criteria_val
    case 1 % User selects Residue Amplitude Criteria
        if (get(handles.rdbutton_time,'Value') == get(handles.rdbutton_time,'Max'));
            prony_time(handles,Results);
        elseif(get(handles.rdbutton_frequency,'Value') == get(handles.rdbutton_frequency,'Max'));
            prony_frequency(handles,Results);
        else
            set(handles.rdbutton_time,'Value',1);
            prony_time(handles,Results);
        end
    
    case 2 % Minimum Energy Criteria
        if (get(handles.rdbutton_time,'Value') == get(handles.rdbutton_time,'Max'));
            prony_time(handles,Results);
        elseif(get(handles.rdbutton_frequency,'Value') == get(handles.rdbutton_frequency,'Max'));
            prony_frequency(handles,Results);
        else
            set(handles.rdbutton_time,'Value',1);
            prony_time(handles,Results);
        end
    end    
     axes(handles.axes_seerror);
     FirstResults=save_FirstResults(handles);
     choose_pronyplots(handles,Results,FirstResults)
     
function choose_pronyplots(handles,Results,FirstResults)
    pp_val = get(handles.ppmenu_pronyplots,'Value');
    sqerror=(handles.test_data(:)-Results.ai(:)).^2;
    % Compute the normalized mean squared error
    nmse=sum(sqerror)/size(sqerror,1);
    set(handles.edit_mse,'String',nmse);
    switch pp_val
    case 1% Squared Error
        seerror(handles,Results);
    case 2  % User selects Poles Plot
        polesplot(handles,Results);
    case 3 % Sorted Residues
        Resplot(handles,Results);
    case 4 % pole zero
        PZplot(handles,Results);
    case 5 % All Residues
        Resplot(handles,FirstResults);
    case 6 % Energy
        Energyplot(handles,FirstResults);
    otherwise
        seerror(handles,Results);
    end
    
%---------------------------------
%---------------------------------
function [PronyResults]=getPronyResults(handles)
   PronyResults =struct('NewVal',[],'SUB_N',[],'iapp',[],'ai',[],...
		        'a_list',[],'tau_list',[],'omega_list',[],...
                'SUB_IND',[],'energy',[],'criteria_val',[],...
                'p',[],'mode_selectionid',[]);
    PronyResults.mode_selectionid=1;       
    PronyResults.criteria_val = get(handles.ppmenu_criteria,'Value');
    PronyResults.NewVal=fetch_NewVal(handles);
    PronyResults.SUB_N=fetch_SUB_N(handles,PronyResults.NewVal);
    [iapp,ai,a_list,tau_list,omega_list,SUB_IND,energy,p]=applyprony(handles.test_time,handles.test_data,PronyResults.NewVal,PronyResults.SUB_N,PronyResults.criteria_val);
    PronyResults.iapp = iapp;
    PronyResults.a_list=a_list;
    PronyResults.tau_list=tau_list;
    PronyResults.omega_list=omega_list;
    PronyResults.SUB_IND=SUB_IND;
    PronyResults.energy=energy;
    PronyResults.p=p;
    PronyResults.ai=ai;
    
  function [FinalResults]= selectedmodes_results(handles,PronyResults)
    
  FinalResults= struct('NewVal',[],'SUB_N',[],'iapp',[],'ai',[],...
		        'a_list',[],'tau_list',[],'omega_list',[],...
                'SUB_IND',[],'energy',[],'criteria_val',[],...
                'p',[],'mode_selectionid',[]);
           
    FinalResults=PronyResults;
    FinalResults.mode_selectionid=get(handles.ppmenu_modesfit,'Value');
    val_modesfit = get(handles.ppmenu_modesfit,'Value');
    switch val_modesfit
        case 1  % All Modes
             selected_SUBIND=PronyResults.SUB_IND;
             set(handles.lstbx_numeric,'Value',1);
        case 2 % Selected Modes only
             Index_Selected=get(handles.lstbx_numeric,'Value');
             % if nothing is selected
                if (isempty(Index_Selected))
                    errordlg('Please select modes','No Mode Selected !!');
                    whitebg('k'); 
                end
                if(size(Index_Selected,2) < size(PronyResults.SUB_IND,2))
                    selected_SUBIND=PronyResults.SUB_IND(Index_Selected);
                else
                    selected_SUBIND=PronyResults.SUB_IND;
                end
        case 3 % All but selected
            Index_Selected=get(handles.lstbx_numeric,'Value');
            % if nothing is selected
                if (isempty(Index_Selected))
                    errordlg('Please select modes','No Mode Selected !!');
                    whitebg('k'); 
                end
            index=1:size(PronyResults.SUB_IND,2);
            n=1;
            for m=1:size(index,2)
                if(m~=Index_Selected(:))
                    not_selected(n)=m;
                    n=n+1;
                end
            end
            selected_SUBIND=PronyResults.SUB_IND(not_selected);
    end % end the switch
    % Save the results
    FinalResults.SUB_IND=selected_SUBIND;
    ai=zeros(size(handles.test_time));
    test_t_increment=handles.test_time(2)-handles.test_time(1);
    fs=1/test_t_increment; % Sampling frequency
    spoles=log(FinalResults.p(:))*fs; 
    for index=selected_SUBIND
        ai=ai+FinalResults.a_list(index)*exp(spoles(index)*handles.test_time);
    end
    ai=real(ai);
    FinalResults.ai = ai;
    % if all the modes are selected then fit should be same
    if(get(handles.ppmenu_modesfit,'Value')==1)
        FinalResults.ai= PronyResults.ai;
    end
    
%--------------------

% --- Executes amplitude criteria for time domain
function prony_time(handles,Results);

% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_modesfit);
order=size(Results.p,1);
suborder=size(Results.SUB_IND,2);
plot(handles.test_time,Results.ai,'r',handles.test_time,handles.test_data,'b');
title(sprintf('Prony Approximation of Model Order %d, Picking %d Residues',order,suborder));
legend('Prony Sub-Approximate','Measured');
ylabel('Signal'),xlabel('Time');



%----------------------------------
% Function to show amplitude residue criteria in frequency domain
function prony_frequency(handles,Results)

[f,fft_data_plot,fft_iapp_plot]= fft_analysis(handles.test_time,handles.test_data,Results.ai);
axes(handles.axes_modesfit);
plot(f,fft_iapp_plot,'r',f,fft_data_plot,'b');
title(sprintf('Prony Approximation of Model Order %d, Picking %d Residues in Frequency Domain',Results.NewVal,size(Results.SUB_IND,2)));
legend('Prony Sub-Approximate','Measured');% place it at lower right corner of the axis
xlabel('Frequency');
ylabel('Magnitude (dB)');



%-----------------------------------------------------
%---------------------------------------------------
function PZplot(handles,Results)
    [inummz,idennz]=residuez(Results.a_list(Results.SUB_IND),Results.p(Results.SUB_IND),1);
    zplane(inummz,idennz,'y');axis([-1.1 1.1 -1.1 1.1]),xlabel('Real Part'), ylabel('Imaginary Part')
    title('Poles Zero Plot')

  
function seerror(handles,Results)
    seerror=(handles.test_data(:)-Results.ai(:)).^2;
    plot(handles.test_time,seerror,'b');xlabel('Time'), ylabel('Squared Error')
    title(sprintf('Squared Error for Model Order %d and Picking %d Residues',Results.NewVal,size(Results.SUB_IND,2)))
    % Compute the normalized mean squared error
    mse=sum(seerror)/size(seerror,1);
    %nmse=sum(seerror)/sum((handles.test_data).^2);
    set(handles.edit_mse,'String',sprintf('%10.1f',mse));
    
function Resplot(handles,Results)
    
    aa_list=abs(2*Results.a_list(Results.SUB_IND'));
    Index=1:size(Results.SUB_IND,2);
    semilogy(Index,aa_list,'b'); 
    axis([0 max(Index)+1 0 1.1*max(aa_list)]),xlabel('Index'), ylabel('Residue Magnitude')
    title(sprintf('Prony Residue Magnitude "Decay" for %d Modes',max(Index)))

    
function Energyplot(handles,Results)
    Index=1:Results.NewVal;
    semilogy(Index,Results.energy(Results.SUB_IND'),'b');
    axis([0 max(Index)+1 0 1.1*max(Results.energy)]),xlabel('Index'),ylabel('Energy')
    title('Energy of Prony Modes');
  
 function polesplot(handles,Results)
    
    [inummz,idennz]=residuez(Results.a_list(Results.SUB_IND),Results.p(Results.SUB_IND),1);
    inummz=0;
    zplane(inummz,idennz,'y');axis([-1.1 1.1 -1.1 1.1]);xlabel('Real Part')
    ylabel('Imaginary Part'),title('Poles Plot');
    

    
    
function edittxtmodes_Callback(hObject, eventdata, handles)
% hObject    handle to edittxtmodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edittxtmodes as text
%        str2double(get(hObject,'String')) returns contents of edittxtmodes as a double

function [SUB_N]=fetch_SUB_N(handles,NewVal)
set(handles.ppmenu_pronyplots,'enable','on');
setstatus(gcbf,'Choose "Save" from "Session" Menu to Save');
SUBN=str2double(get(handles.edittxtmodes,'String'));
if(SUBN > NewVal)
    answer=inputdlg('Number of Modes has to be Less than Model Order !!                                 Please input the Number of Modes','Change Input Number of Modes',1);
    SUBN=str2double(answer);
    SUB_N=check_SUB_N(handles,SUBN,NewVal);% to make sure that complex conjugate is selected
    set(handles.edittxtmodes,'String',SUB_N);
end
SUB_N=check_SUB_N(handles,SUBN,NewVal);

% Make sure that user cannot select one mode , if the user selects
% one pole then check if the next pole is complex conjugate of it or not 
% if it is, then change SUB_N value accordingly
% fix the SUBN so that it does not exceed the NewVal
% SUBN is no. of modes inserted by user
% SUB_N is the checked and correct modes
function [SUB_N]=check_SUB_N(handles,SUBN,NewVal)
if (SUBN==NewVal)
    SUBN=SUBN-1;
end
[iapp,ai,a_list,tau_list,omega_list,SUB_IND,energy,p]=applyprony(handles.test_time,handles.test_data,NewVal,0,handles.criteria_val);
aa_list=2*abs(a_list(SUB_IND));
ttau_list=abs(tau_list(SUB_IND));
oomega_list=abs(omega_list(SUB_IND));
Acond=abs(aa_list(SUBN+1)-aa_list(SUBN));
taucond=abs((1/ttau_list(SUBN+1))-(1/ttau_list(SUBN)));
omegacond=abs(oomega_list(SUBN+1)-oomega_list(SUBN));
if((Acond<0.01) & (taucond<0.001) & (omegacond<0.0001))
    SUB_N=SUBN+1;
    set(handles.edittxtmodes,'String',SUB_N);
else
    SUB_N=SUBN;
end



function [NewVal]=fetch_NewVal(handles)

NewVal = round(str2num(get(handles.edit_morder,'String')));
if (NewVal<=0)
    answer=inputdlg('Model Order Must be a Postive Integer','Correct Model Order',1);
    NewVal=str2double(answer)
    set(handles.edit_morder,'String',NewVal);
end


% --- Executes on button press in push_modeselection.
function push_modeselection_Callback(hObject, eventdata, handles)
% hObject    handle to push_modeselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     PronyResults=getPronyResults(handles);
    FinalResults=selectedmodes_results(handles,PronyResults);
    perform_plotcriteria(handles,FinalResults);


% --- Executes on button press in push_plots.
function push_plots_Callback(hObject, eventdata, handles)
% hObject    handle to push_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    PronyResults=getPronyResults(handles);
    FinalResults=selectedmodes_results(handles,PronyResults);
    perform_plotcriteria(handles,FinalResults);
    
    
% --- Executes on button press in ppmenu_modesfit.
function ppmenu_modesfit_Callback(hObject,eventdata,handles)
% hObject    handle to ppmenu_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ppmenu_modesfit
 
% --------------------------------------------------------------------
function menu_saveworkspace_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveworkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Flag to say that user has saved atleast one session
     handles.menu_saveflag=1;
     handles.menu_saveasflag=0; % saveas flag as 
    guidata(hObject,handles); % store the changes
set(handles.push_sessionscompare,'enable','on');
%Run=handles.RunNum;
% Retrieve old results data structure
setstatus(gcbf,'Press "Compare Sessions" To compare');
PronyResults=getPronyResults(handles);
FinalResults= selectedmodes_results(handles,PronyResults);
[SaveData,maxNum]= prepare_savedata(FinalResults,handles,hObject);
% Assign the data to Base Workspace
assignin('base','SaveData',SaveData);
assignin('base','maxNum',maxNum);
% Message to the user that data is saved
h_msg=msgbox('The Session is Successfully Saved','Save Session','replace');
whitebg('white');

% --------------------------------------------------------------------
function menu_saveinfile_Callback(hObject, eventdata, handles)
% hObject    handle to menu_saveinfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Flag to say that user has saved atleast one session
% Flag to say that user has saved atleast one session
     
[cmpfile, cmppath] = uiputfile( ...
    {'*.cmp', 'All CMP-Files (*.cmp)'},...
    'Save as a file');
if isequal(cmpfile,0) | isequal(cmppath,0)
         return
end
if ~ismember('.',cmpfile)
         cmpfile = [cmpfile '.cmp'];
end
set(handles.push_sessionscompare,'enable','on');
handles.menu_saveflag=1;
handles.menu_saveasflag=1;% flag to check option of save  Is it save as ??
guidata(hObject,handles); % store the changes
PronyResults=getPronyResults(handles);
FinalResults= selectedmodes_results(handles,PronyResults);
[SaveData,maxNum]= prepare_savedata(FinalResults,handles,hObject);
 cmpfullname=fullfile(cmppath,cmpfile);
 save(cmpfullname,'SaveData','maxNum','-mat');
guidata(hObject,handles); % store the changes
% Message to the user that data is saved
h_msg=msgbox('The Sessions are saved in Successfully in the file','Save Session','replace');
whitebg('white');
  

% --- Executes on button press in push_close.
function push_close_Callback(hObject, eventdata, handles)
% hObject    handle to push_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);

% --- Executes on button press in push_sessionscompare.
function push_sessionscompare_Callback(hObject, eventdata, handles)
% hObject    handle to push_sessionscompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.menu_saveflag==1)
    comparesessions;
    IIGuiData = prepare_guidata(handles);
    assignin('base','IIGuiData',IIGuiData);
else
    % Message to the user that data is saved
    warndlg('Please Save the Session to Use the Compare Sessions Tool !!',' Warning Save Session');
    whitebg('white');    
end


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

function [IIGuiData]= prepare_guidata(handles)
IIGuiData= struct('NewVal',[],'SUB_N',[],'iapp',[],'ai',[],...
		        'a_list',[],'tau_list',[],'omega_list',[],...
                'SUB_IND',[],'energy',[],'criteria_val',[],...
                'p',[],'mode_selectionid',[],'test_time',[],'test_data',[],...
                'f1',[],'fft_iapp1',[],'fft_data1',[],...
                'f2',[],'fft_iapp2',[],'fft_data2',[],...
                'inummz',[],'idennz',[],'seerror',[],'aa_list',[],...
                'all_res',[],'res_SUBIND',[]);
                
PronyResults=getPronyResults(handles);
FinalResults=selectedmodes_results(handles,PronyResults);  
IIGuiData=FinalResults;
FirstResults=save_FirstResults(handles);
IIGuiData.iapp=FirstResults.iapp;
IIGuiData.test_time=handles.test_time;
IIGuiData.test_data=handles.test_data;
[f1,fft_data1,fft_iapp1]= fft_analysis(handles.test_time,handles.test_data,FirstResults.iapp);
IIGuiData.f1=f1;
IIGuiData.fft_iapp1=fft_iapp1;
IIGuiData.fft_data1=fft_data1;
[f2,fft_data2,fft_iapp2]= fft_analysis(handles.test_time,handles.test_data,FinalResults.ai);
IIGuiData.f2=f2;
IIGuiData.fft_iapp2=fft_iapp2;
IIGuiData.fft_data2=fft_data2;
[IIGuiData.inummz,IIGuiData.idennz]=residuez(FinalResults.a_list(FinalResults.SUB_IND),FinalResults.p(FinalResults.SUB_IND),1);
IIGuiData.seerror=(handles.test_data(:)-FinalResults.ai(:)).^2;
IIGuiData.aa_list=abs(2*FinalResults.a_list(FinalResults.SUB_IND'));
IIGuiData.all_res= abs(2*FirstResults.a_list(FirstResults.SUB_IND'));
IIGuiData.res_SUBIND=FirstResults.SUB_IND;
IIGuiData.energy=FirstResults.energy;


% --------------------------------------------------------------------
function cmenu_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_time_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_time_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IIGuiData = prepare_guidata(handles);
figure('Color','White');
plot(IIGuiData.test_time,IIGuiData.iapp,'r',IIGuiData.test_time,IIGuiData.test_data,'b');
xlabel('Time'),ylabel('Signal');
title(sprintf('Prony Analysis of Model Order %d in Time Domain',IIGuiData.NewVal))
legend('Prony Approximate', 'Measured')
        
    
% --------------------------------------------------------------------
function plotnew_frequency_pronyfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_frequency_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % implement frequency domain prony
IIGuiData = prepare_guidata(handles);
figure('Color','White');
plot(IIGuiData.f1,IIGuiData.fft_iapp1,'r',IIGuiData.f1,IIGuiData.fft_data1,'b');
xlabel('Frequency'),ylabel('  Magnitude (dB)  ');
title(sprintf('Prony Analysis of Model Order %d in Frequency Domain',IIGuiData.NewVal))
legend('Prony Approximate', 'Measured')



% --------------------------------------------------------------------
function cmenu_modesfit_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_modesfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_time_modesfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_time_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IIGuiData = prepare_guidata(handles);
figure('Color','White');
plot(IIGuiData.test_time,IIGuiData.ai,'r',IIGuiData.test_time,IIGuiData.test_data,'b');
title(sprintf('Prony Approximation of Model Order %d, Picking %d Residues',IIGuiData.NewVal,IIGuiData.SUB_N));
legend('Prony Sub-Approximate','Measured');
ylabel('Signal'),xlabel('Time');


% --------------------------------------------------------------------
function plotnew_frequency_modesfit_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_frequency_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IIGuiData = prepare_guidata(handles);
figure('Color','White');
plot(IIGuiData.f2,IIGuiData.fft_iapp2,'r',IIGuiData.f2,IIGuiData.fft_data2,'b');
title(sprintf('Prony Approximation of Model Order %d, Picking %d Residues in Frequency Domain',IIGuiData.NewVal,IIGuiData.SUB_N));
legend('Prony Sub-Approximate','Measured');% place it at lower right corner of the axis
xlabel('Frequency');
ylabel('Magnitude (dB)');

% --------------------------------------------------------------------
function cmenu_seerror_Callback(hObject, eventdata, handles)
% hObject    handle to cmenu_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_seerror_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotnew_serror_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_serror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    plot(IIGuiData.test_time,IIGuiData.seerror,'b');xlabel('Time'), ylabel('Squared Error')
    title(sprintf('Squared Error for Model Order %d and Picking %d Residues',IIGuiData.NewVal,size(IIGuiData.SUB_IND,2)))
     
% --------------------------------------------------------------------
function plotnew_polezero_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_polezero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    zplane(IIGuiData.inummz,IIGuiData.idennz,'y');axis([-1.1 1.1 -1.1 1.1]),xlabel('Real Part'), ylabel('Imaginary Part')
    title('Poles Zero Plot')
    

% --------------------------------------------------------------------
function plotnew_sortedres_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_sortedres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    max_aa=max(IIGuiData.aa_list)+1;
    Index=1:size(IIGuiData.SUB_IND,2);
    plot(Index,IIGuiData.aa_list,'b'), axis([0.9 max(Index)+0.1 0 max_aa]),xlabel('Index'), ylabel('Residue Magnitude')
    title(sprintf('Prony Residue Magnitude "Decay" for %d Modes',max(Index)))



% --------------------------------------------------------------------
function plotnew_poles_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_poles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    zplane(0,IIGuiData.idennz,'y');axis([-1.1 1.1 -1.1 1.1]);xlabel('Real Part')
    ylabel('Imaginary Part'),title('Poles Plot');

% --------------------------------------------------------------------
function plotnew_allres_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_allres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    max_aa=max(IIGuiData.all_res)+1;
    Index=1:size(IIGuiData.res_SUBIND,2);
    plot(Index,IIGuiData.all_res,'b'), axis([0.9 max(Index)+0.1 0 max_aa]),xlabel('Index'), ylabel('Residue Magnitude')
    title(sprintf('Prony Residue Magnitude "Decay" for %d Modes',max(Index)))

% --------------------------------------------------------------------
function plotnew_allenergy_Callback(hObject, eventdata, handles)
% hObject    handle to plotnew_allenergy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    IIGuiData = prepare_guidata(handles);
    figure('Color','White');
    Index=1:IIGuiData.NewVal;
    semilogy(Index,IIGuiData.energy(IIGuiData.SUB_IND'),'b');
    axis([0 max(Index)+1 0 1.1*max(IIGuiData.energy)]),xlabel('Index'),ylabel('Energy')
    title('Energy of Prony Modes');


    
% --------------------------------------------------------------------
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function numsummary_Callback(hObject, eventdata, handles)
% hObject    handle to numsummary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Session_Callback(hObject, eventdata, handles)
% hObject    handle to Session (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_save_Callback(hObject, eventdata, handles)
% hObject    handle to savesession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_close_Callback(hObject, eventdata, handles)
% hObject    handle to closesession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);

% --- Executes during object creation, after setting all properties.
function axes_pronyfit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_pronyfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_pronyfit


% --- Executes during object creation, after setting all properties.
function axes_modesfit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_modesfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_modesfit


% --- Executes during object creation, after setting all properties.
function axes_seerror_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_seerror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_seerror


% --- Executes during object creation, after setting all properties.
function lstbx_numeric_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstbx_numeric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function lstbx_numeric_Callback(hObject, eventdata, handles)
% hObject    handle to lstbx_numeric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lstbx_numeric as text
%        str2double(get(hObject,'String')) returns contents of lstbx_numeric as a double

%mcwHndl=handles.lstbx_numeric;
%set(gcf,'UserData',mcwHndl);




% --- Executes during object creation, after setting all properties.
function edittxtmodes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edittxtmodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --------------------------------------------------------------------
function menu_gridon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_pronyfit);
grid on;
axes(handles.axes_seerror);
grid on;
axes(handles.axes_modesfit);
grid on;
% --------------------------------------------------------------------
function menu_gridoff_Callback(hObject, eventdata, handles)
% hObject    handle to menu_gridoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_pronyfit);
grid off;
axes(handles.axes_seerror);
grid off;
axes(handles.axes_modesfit);
grid off;

% --------------------------------------------------------------------
function menu_numsumarry_Callback(hObject, eventdata, handles)
% hObject    handle to menu_numsumarry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_tools_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%5 handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_compare_Callback(hObject, eventdata, handles)
% hObject    handle to menu_compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Call CompareSessions GUI if any session is saved else give a message to
% the user to save the session

if (handles.menu_saveflag==1)
    comparesessions;
    IIGuiData = prepare_guidata(handles);
    assignin('base','IIGuiData',IIGuiData);

else
    % Message to the user that data is saved
    warndlg('Please Save the Session to Use the Compare Sessions Tool !!',' Warning Save Session');
    whitebg('white');    
end



% --- Executes during object creation, after setting all properties.
function edit_morder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_morder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_morder_Callback(hObject, eventdata, handles)
% hObject    handle to edit_morder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_morder as text
%        str2double(get(hObject,'String')) returns contents of edit_morder as a double


% --- Executes during object creation, after setting all properties.
function ppmenu_pronyplots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppmenu_pronyplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ppmenu_pronyplots.
function ppmenu_pronyplots_Callback(hObject, eventdata, handles)
% hObject    handle to ppmenu_pronyplots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ppmenu_pronyplots contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ppmenu_pronyplots
    


% --- Executes during object creation, after setting all properties.
function edit_mse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc
    set(hObject,'BackgroundColor',[0.6 0.6 0.6]);
    %else
    %set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    %end



function edit_mse_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double





