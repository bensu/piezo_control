function varargout = pronytool(varargin)
% PRONYTOOL M-file for pronytool.fig
%      PRONYTOOL, by itself, creates a new PRONYTOOL or raises the existing
%      singleton*.
%
%      H = PRONYTOOL returns the handle to a new PRONYTOOL or the handle to
%      the existing singleton*.
%
%      PRONYTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRONYTOOL.M with the given input arguments.
%
%      PRONYTOOL('Property','Value',...) creates a new PRONYTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pronytool_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pronytool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pronytool

% Last Modified by GUIDE v2.5 26-Apr-2003 19:22:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pronytool_OpeningFcn, ...
                   'gui_OutputFcn',  @pronytool_OutputFcn, ...
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


% --- Executes just before pronytool is made visible.
function pronytool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pronytool (see VARARGIN)

% Choose default command line output for pronytool
handles.output = hObject;

set(hObject,'Color','white');
% Update handles structure
guidata(hObject, handles);
load imageicons.mat;
% Xup=load(evalin('base',imageicons));
image_up=image(Xup);axis off;
cmap=colormap(winter);
set(gcf,'userdata',image_up);


% UIWAIT makes pronytool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pronytool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_about.
function push_about_Callback(hObject, eventdata, handles)
% hObject    handle to push_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath = which ('about.html');
web(HelpPath,'-browser'); 

% --- Executes on button press in push_start.
function push_start_Callback(hObject, eventdata, handles)
% hObject    handle to push_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start Prony Analysis
pronyanalysistool;
%close(gcf)



