function varargout = FullDisp1(varargin)
% FULLDISP1 MATLAB code for FullDisp1.fig
%      FULLDISP1, by itself, creates a new FULLDISP1 or raises the existing
%      singleton*.
%
%      H = FULLDISP1 returns the handle to a new FULLDISP1 or the handle to
%      the existing singleton*.
%
%      FULLDISP1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FULLDISP1.M with the given input arguments.
%
%      FULLDISP1('Property','Value',...) creates a new FULLDISP1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FullDisp1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FullDisp1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FullDisp1

% Last Modified by GUIDE v2.5 16-Dec-2015 17:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FullDisp1_OpeningFcn, ...
                   'gui_OutputFcn',  @FullDisp1_OutputFcn, ...
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


% --- Executes just before FullDisp1 is made visible.
function FullDisp1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FullDisp1 (see VARARGIN)
% warning('off','MATLAB:HndleGraphics:obsoletedProperty:JaveFrame');
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('rollmeter.png'));
chgicon(gcf,'rollmeter.png')
RM_handles =getappdata(0,'RollMeter');
if strcmp(get(RM_handles.language,'userdata'),'Chinese')
    set(hObject,'name','辊子中高测量曲线')
end

%delete the unuse toolbar
hToolbar = findall(gcf,'Type','uitoolbar');
% allchild(hToolbar)
hChildren=allchild(hToolbar);
delnum=[1 2 3 4 5 6 8 10 12 15 16];
delete(hChildren(delnum));
%initialize
disp_info.linex=0;
disp_info.liney=0;
disp_info.leg=0;
disp_info.point=0;


% ssize=get(0,'screensize');
% set(hObject,'position',ssize);
RM_handles = getappdata(0,'RollMeter');
a=get(RM_handles.rollnum,'string');
b=get(RM_handles.date,'string');
c=get(RM_handles.time,'string');

filename=[a,b,c];

filename=[a,'\_',b(3:4),b(6:7),b(9:10),'\_',c(1:2),c(4:5)];
% filename{i}=get(hdisp(i),'string'); 

% axes(handles.axes1);
  hold on
h_line=findobj(RM_handles.axes1,'type','line');
    x=get(h_line,'xdata');
    y=get(h_line,'ydata');
    disp_info.curve=plot(x,y,'color',get(h_line,'color'),'linewidth',2);
    
    
  
    [max_y,max_idx]=max(y);
    [min_y,min_idx]=min(y);
    disp_info.h_pt=plot(x(max_idx),y(max_idx),'o',x(min_idx),y(min_idx),'*','linewidth',2);
%     [legh,objh]=legend([h_pt(1),h_pt(2)],['x=',num2str(x(max_idx)),', y=',num2str(y(max_idx))],['x=',num2str(x(min_idx)),', y=',num2str(y(min_idx))],2);

    if strcmp(get(RM_handles.language,'userdata'),'English')
        legh=legend([disp_info.curve,disp_info.h_pt(1),disp_info.h_pt(2)],filename,['Max: x=',num2str(x(max_idx)),', y=',num2str(y(max_idx))],['Min: x=',num2str(x(min_idx)),', y=',num2str(y(min_idx))],2);
        set(handles.back,'string','Back')
        set(handles.reset,'string','Reset')
    end

    if strcmp(get(RM_handles.language,'userdata'),'Chinese')
        legh=legend([disp_info.curve,disp_info.h_pt(1),disp_info.h_pt(2)],filename,['最大值: x=',num2str(x(max_idx)),', y=',num2str(y(max_idx))],['最小值: x=',num2str(x(min_idx)),', y=',num2str(y(min_idx))],2);
        set(handles.back,'string','返回')
        set(handles.reset,'string','重置')
    end
    title(get(get(RM_handles.axes1,'title'),'string'),'Fontsize',14)
    xlabel(get(get(RM_handles.axes1,'xlabel'),'string'),'Fontsize',12)
    ylabel(get(get(RM_handles.axes1,'ylabel'),'string'),'Fontsize',12)
    set(gca,'Fontsize',12)
    grid on
    disp_info.xlim=get(handles.axes1,'xlim');
    disp_info.ylim=get(handles.axes1,'ylim');
    disp_info.leg=copyobj(legh,gcf);
    set(disp_info.leg,'position',get(legh,'position'),'visible','off')  %复制leg并隐藏
   

 %%%%%%%%%%%%%%%change the save as callback%%%%%%%%%%%%%%%%
hToolbar=findall(gcf,'Type','uitoolbar');
if isempty(hToolbar)
    return
end
hChildren=allchild(hToolbar);
if isempty(hChildren)
    return
end
% hTags = get(hChildren, 'Tag'); 
SaveAs=findobj(hChildren,'Tag','Standard.SaveFigure');
set(SaveAs,'ClickedCallback',@SaveAs_Callback);       
        
% Choose default command line output for FullDisp1
handles.output = hObject;
% handles.legh=legh;
% handles.objh=objh;
% Update handles structure
handles.RM_handles=RM_handles;
handles.disp_info=disp_info;
guidata(hObject, handles);

% UIWAIT makes FullDisp1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FullDisp1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_info=handles.disp_info;
% legh=handles.legh;
% objh=handles.objh;
if strcmp(get(gcf,'selectiontype'),'normal')
    set(gcf,'pointer','cross');
    if disp_info.point
         if ishandle(disp_info.point)
             delete(disp_info.point);
         end
     end
    wpt=get(handles.axes1,'currentpoint');
    xdata=get(disp_info.curve,'xdata');
    ydata=get(disp_info.curve,'ydata'); 
        [dif,idx]=min(abs(xdata-wpt(1,1)));
            disp_info.point=plot(handles.axes1,xdata(idx),ydata(idx),'*','color','k','linewidth',2);
    %         pt(i)=plot(xdata{1}(i)(idx(i)),ydata{1}(i)(idx(i)),'b*');
            xx=xdata(idx);
            yy=ydata(idx);
            ylim=get(handles.axes1,'ylim');
            xlim=get(handles.axes1,'xlim');
            disp_info.liney=line([xx,xx],ylim);
            if ishandle(disp_info.leg)   %如果该句柄存在
                set(disp_info.leg,'visible','on')  %复制leg并隐藏
            end
            disp_info.leg=legend(disp_info.point,['x=',num2str(xx),', ','y=',num2str(yy)],1);
%     
    disp_info.linex=line(xlim,[wpt(1,2),wpt(1,2)]);
    handles.disp_info=disp_info;
    set(gca,'Fontsize',12);
    guidata(hObject, handles);
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp_info=handles.disp_info;
% legh=handles.legh;
% objh=handles.objh;
    delete(disp_info.linex);
    delete(disp_info.liney);
    set(gcf,'pointer','arrow');
    
    
%%%%%%%%%%%SaveAs_Callback%%%%%%%%%%%
function SaveAs_Callback(hObject,eventdata)
filemenufcn(gcf,'FileSaveAs') 
% name=get(gcf,'name');
% % default_name=['C:\Users\',name]
%         uiputfile({
%            '*.jpg','JPEG file (*.jpg)';... 
%            '*.png','Portable Networking Graphics file (*.png)';...
%            '*.tif','TIFF inamge (*.tif)';...
%            },'Save Image')

% --- Executes on button press in back.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filemenufcn(gcbf,'FileClose')


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_info=handles.disp_info;
% delete(disp_info.curve)
% delete(disp_info.h_pt)
if disp_info.leg
    if ishandle(disp_info.leg)
        delete(disp_info.leg);
    end
end
delete(findobj(handles.axes1,'type','line'))
RM_handles = getappdata(0,'RollMeter');

h_line=findobj(RM_handles.axes1,'type','line');
    x=get(h_line,'xdata');
    y=get(h_line,'ydata');
    disp_info.curve=plot(x,y,'color',get(h_line,'color'),'linewidth',2);
 
    [max_y,max_idx]=max(y);
    [min_y,min_idx]=min(y);
    disp_info.h_pt=plot(x(max_idx),y(max_idx),'o',x(min_idx),y(min_idx),'*','linewidth',2);
    xlim(disp_info.xlim)
    ylim(disp_info.ylim)
handles.disp_info=disp_info;
guidata(hObject, handles);
