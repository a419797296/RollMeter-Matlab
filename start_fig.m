function varargout = start_fig(varargin)
% START_FIG MATLAB code for start_fig.fig
%      START_FIG, by itself, creates a new START_FIG or raises the existing
%      singleton*.
%
%      H = START_FIG returns the handle to a new START_FIG or the handle to
%      the existing singleton*.
%
%      START_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in START_FIG.M with the given input arguments.
%
%      START_FIG('Property','Value',...) creates a new START_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before start_fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to start_fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help start_fig

% Last Modified by GUIDE v2.5 01-Dec-2015 09:44:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @start_fig_OpeningFcn, ...
                   'gui_OutputFcn',  @start_fig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before start_fig is made visible.
function start_fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to start_fig (see VARARGIN)

% Choose default command line output for start_fig
handles.output = hObject;
im=imread('RollMeter.jpg'); % 加载你的图
% im=imresize(im,0.5);
% axes(handles.axes1); % 添加的axes的tag为axes1
hIm=imshow(im); % 显示
% hSP = imscrollpanel(gcf,hIm);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes start_fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = start_fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
