function varargout = FullDisp2(varargin)
% FULLDISP2 MATLAB code for FullDisp2.fig
%      FULLDISP2, by itself, creates a new FULLDISP2 or raises the existing
%      singleton*.
%
%      H = FULLDISP2 returns the handle to a new FULLDISP2 or the handle to
%      the existing singleton*.
%
%      FULLDISP2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FULLDISP2.M with the given input arguments.
%
%      FULLDISP2('Property','Value',...) creates a new FULLDISP2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FullDisp2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FullDisp2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FullDisp2

% Last Modified by GUIDE v2.5 17-Jul-2016 13:12:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FullDisp2_OpeningFcn, ...
    'gui_OutputFcn',  @FullDisp2_OutputFcn, ...
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


% --- Executes just before FullDisp2 is made visible.
function FullDisp2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FullDisp2 (see VARARGIN)
%
% warning('off','MATLAB:HndleGraphics:obsoletedProperty:JaveFrame');
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('rollmeter.png'));
chgicon(gcf,'rollmeter.png')
% set(gcf,'position',get(0,'ScreenSize'))
% Delete the toolbar menu
hToolbar = findall(gcf,'Type','uitoolbar');
hChildren=allchild(hToolbar);
delnum=[1 2 3 4 5 6 8 10 12 15 16];
delete(hChildren(delnum));

handles.output = hObject;
% Choose default command line output for FullDisp2
RM_handles = getappdata(0,'RollMeter');
disp=get(RM_handles.axes1,'userdata');
set(handles.axes2,'userdata',disp)
disp_init(hObject, eventdata, handles);

disp=get(handles.axes2,'userdata');
Nline=size(findobj(RM_handles.axes1,'type','line'),1);%曲线条数
filenames=cell(1,Nline);
hline=zeros(1,Nline);  %临时存放曲线句柄
hold on
for i=1:Nline
    x=get(disp.line(i).handle,'xdata');
    y=get(disp.line(i).handle,'ydata');
    disp.line(i).xdata=x;
    disp.line(i).ydata=y;
    color=get(disp.line(i).handle,'color');
    lineStyle=get(disp.line(i).handle,'LineStyle');
    linewidth=get(disp.line(i).handle,'linewidth');
    disp.line(i).handle=plot(handles.axes2,x,y,'color',color,'linewidth',linewidth,'LineStyle',lineStyle);
    disp.cur_line_idx(i)=i;
    hline(i)=disp.line(i).handle;
    set(disp.curv(i),'foregroundcolor',color);
    filenames{i}= strrep(disp.line(i).filename,'_','\_'); %替换成反义字符
    
    %     disp_info.h_pt(2*i-1)=scatter(x(disp_info.max_idx(i)),y(disp_info.max_idx(i)),...
    %        100,1000,'filled');
    %     disp_info.h_pt(2*i)=scatter(x(disp_info.min_idx(i)),y(disp_info.min_idx(i)),...
    %        100,-1000,'filled');
    
end
%     set(findobj(disp_info.curve,'color','r'),'linewidth',2);
title(get(get(RM_handles.axes1,'title'),'string'),'Fontsize',14)
xlabel(get(get(RM_handles.axes1,'xlabel'),'string'),'Fontsize',12)
ylabel(get(get(RM_handles.axes1,'ylabel'),'string'),'Fontsize',12)
set(gca,'Fontsize',12)

[xlim,ylim]=change_margain(handles.axes2,1.05);
disp.axes_xlim=xlim;
disp.axes_ylim=ylim;
% disp.axes_xlim=get(handles.axes2,'xlim');
% disp.axes_ylim=get(handles.axes2,'ylim');

grid on

if strcmp(disp.language,'Chinese')
    
    langu=2;
else
    langu=3;
end
%     fid = fopen('languages.txt');
%     C_head= textscan(fid, '%s %s %s ','CollectOutput', 1, 'delimiter', '	')
%     fclose(fid);
%     heading=C_head{1}(:,1)';
%     info = cell2struct(C_head{1}, heading, 1);
%     save('languages.mat','info')
% 
h_info=load('languages.mat');
info=h_info.info;
set(hObject,'name',info(langu).title)
set(handles.mappanel,'title',info(langu).mappanel)
set(handles.movepanel,'title',info(langu).movepanel)
set(handles.mapping,'string',info(langu).mapping)
set(handles.residual,'string',info(langu).residual)
set(handles.similarity0,'string',info(langu).similarity0)
set(handles.lock,'string',info(langu).lock)
set(handles.curv1,'string',info(langu).curv1)
set(handles.curv2,'string',info(langu).curv2)
set(handles.curv3,'string',info(langu).curv3)
set(handles.curv4,'string',info(langu).curv4)
set(handles.curv5,'string',info(langu).curv5)
set(handles.curv6,'string',info(langu).curv6)
set(handles.back,'string',info(langu).back)
set(handles.reset,'string',info(langu).reset)

set(handles.find_pannel,'title',info(langu).find_pannel)
set(handles.find0,'string',info(langu).find0)
set(handles.error0,'string',info(langu).error0)
set(handles.up_error_text,'string',info(langu).up_error)
set(handles.low_error_text,'string',info(langu).low_error)


disp.leg.filenames=legend(hline,filenames,2);
copyobj(disp.leg.filenames,gcf);
disp.leg.point=legend(hline,filenames,1);
set(disp.leg.point,'visible','off')  %复制leg并隐藏

%disp.line_bk=disp.line;  %备份曲线句柄
set(handles.axes2,'userdata',disp)
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
guidata(hObject, handles);

% UIWAIT makes FullDisp1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FullDisp2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in mapping.
function mapping_Callback(hObject, eventdata, handles)
% hObject    handle to mapping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
idx=disp.cur_line_idx;%有效曲线小标数组
if ~disp.mapping
    
    
%     if size(disp.cur_line_idx,2)~=2%获得已经显示的曲线条数
%         h=msgbox('显示曲线不是2条，无法比较！');
%         chgicon(h,'rollmeter.png')  %h更改GUI图标;
%     else
        disp.mapping=1;
        %         if disp.residual
        %             residual_Callback(hObject, eventdata, handles)
        %         end
        
%         hline1=disp.line(idx(1)).handle;
%         hline2=disp.line(idx(2)).handle;
%         
%         
%         [move_curve,cor_max,shift_xy]=mapping(hline1,hline2,20,80); %20:最大允许误差，50：比较点密度,20，50对应量数字越小，精度越高，但比较时间越长
        if strcmp(disp.language,'Chinese')
            choice = MyQuestdlg('请选择自动匹配模式', ...
             '自动匹配', ...
             '自动','仅x轴','仅y轴','自动');
        else
            choice = MyQuestdlg('Please choose the mapping model', ...
             'Auto Mapping', ...
             'Auto','Just x','Just y','Auto');       
        end
        shift_xy_mode=ones(1,2)
        if strcmp(choice,'仅x轴')||strcmp(choice,'Just x')
            shift_xy_mode(2)=0;
        end
        if strcmp(choice,'仅y轴')||strcmp(choice,'Just y')
            shift_xy_mode(1)=0;
        end
        struct_lines=disp.line(idx);
%         N=max(size(struct_lines));
%         line_err_idx=[];
%         for i=1:N
%             if ~isempty(strfind(struct_lines(i).filename, 'theory_line_err'))
%                 line_err_idx=i;
%             end
%         end
%         struct_lines(line_err_idx)=[];
        [disp.line(idx) cor_max]=mapping_all(struct_lines,shift_xy_mode);
        if ~strcmp(cor_max,'')  %如果是多条曲线，则返回空值
            set(handles.similarity,'string',num2str(cor_max));
        end
        
%         [new_x,new_y]=curve_shift(disp.line(idx(move_curve)).handle,shift_xy);
%         color=get(disp.line(idx(move_curve)).handle,'color');
%         linewidth=get(disp.line(idx(move_curve)).handle,'linewidth');
%         delete(disp.line(idx(move_curve)).handle)
%         disp.line(idx(move_curve)).handle=plot(new_x,new_y,'color',color,'linewidth',linewidth);%%产生一条新的曲线
%         
%         x=get(disp.line(idx(move_curve)).handle,'xdata');
%         y=get(disp.line(idx(move_curve)).handle,'ydata');
%         disp.line(idx(move_curve)).xdata=x;
%         disp.line(idx(move_curve)).ydata=y;
%         sys.line(idx(move_curve)).xlim=[x(1) x(end)];
%         sys.line(idx(move_curve)).ylim=[min(y) max(y)];
%         [sys.line(idx(move_curve)).max_pt,disp.line(idx(move_curve)).min_pt]=line_max_min(disp.line(idx(move_curve)).handle);
        set(handles.mapping,'backgroundcolor',[0.5 0.5 0.5]);
        %             disp_hide_Callback(hObject, eventdata, handles,move_curve)
%     end
else
    if disp.residual
        residual_Callback(hObject, eventdata, handles)
        disp.residual=0;
    end
    disp.mapping=0;
    %         if ishandle(disp.curve_fit)
    %             delete(disp.curve_fit)
    %         end
    set(handles.similarity,'string','');
    set(handles.mapping,'backgroundcolor',[0.9 0.9 0.9]);
    %         disp_hide_Callback(hObject, eventdata, handles,2)  %默认改变的是第二条曲线
end
set(handles.axes2,'userdata',disp)
%     disp_hide_Callback(hObject, eventdata, handles,2)


function similarity_Callback(hObject, eventdata, handles)
% hObject    handle to similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of similarity as text
%        str2double(get(hObject,'String')) returns contents of similarity as a double


% --- Executes during object creation, after setting all properties.
function similarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in movepanel.
function movepanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in movepanel
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
disp.move_stat=get(eventdata.NewValue,'Tag');
if ~strcmp(disp.move_stat,'lock')
    [xlim,ylim]=change_margain(handles.axes2,1);%固定坐标轴
    disp.axes_xlim=xlim;
    disp.axes_ylim=ylim;
    
%     if ishandle(disp.leg.point)
%         delete(disp.leg.point);
%     end
        if strcmp(get(disp.leg.point,'visible'),'on')
            set(disp.leg.point,'visible','off')
        end
%     end
    
    for i=1:size(disp.pt,2)
        %       if point(i)
        if ishandle(disp.pt(i).handle)
            delete(disp.pt(i).handle);
        end
        %       end
    end
else
    axis auto
end
set(handles.axes2,'userdata',disp);
guidata(hObject, handles);

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%
disp=get(handles.axes2,'userdata');
ready_move_curve=disp.move_stat;
if strcmp(ready_move_curve,'lock')
    return
end
N=str2double(ready_move_curve(end));
if strcmp(disp.disp_stat{N},'disp_stat')  %如果曲线处于显示状态
    if disp.ButtonDown==1
        step=1;
    else
        step=20;
    end
    char=get(gcf,'currentcharacter');
    color=get(disp.line(N).handle,'color');
    switch char
        case 'w'
            [new_x,new_y]= curve_shift(disp.line(N).handle,[0,step]);
        case 's'
            [new_x,new_y]= curve_shift(disp.line(N).handle,[0,-step]);
        case 'a'
            [new_x,new_y]= curve_shift(disp.line(N).handle,[-step,0]);
        case 'd'
            [new_x,new_y]= curve_shift(disp.line(N).handle,[step,0]);
        otherwise
            return
    end
    delete(disp.line(N).handle);
    disp.line(N).handle=plot(new_x,new_y,'color',color,'linewidth',2) ;
    disp.line(N).xlim=[new_x(1) new_x(end)];
    disp.line(N).xdata=new_x;
    disp.line(N).ydata=new_y;
    disp.line(N).ylim=[min(new_y) max(new_y)];
    [disp.line(N).max_pt,disp.line(N).min_pt]=line_max_min(disp.line(N).handle);
    if disp.mapping
        mapping_Callback(hObject, eventdata, handles);
        disp.mapping=0;
    end
    if disp.residual
        disp.residual=0;
    end
    set(handles.find,'string','')
    set(handles.diff,'string','')
end

set(handles.axes2,'userdata',disp);
guidata(hObject, handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
Nline=size(disp.line,2);
if Nline
    ready_move_curve=disp.move_stat;
    disp.ButtonDown=0;
    disp.last_pos(1,1)=0;    %为了忽略当前坐标
    set(gcf,'pointer','arrow');
    if strcmp(ready_move_curve,'lock')
        if strcmp(get(gcf,'selectiontype'),'normal')
            if ishandle(disp.h_xline)
                delete(disp.h_xline);
            end
            if ishandle(disp.h_yline)
                delete(disp.h_yline);
            end
            
        end
    end
    set(handles.axes2,'userdata',disp);
    guidata(hObject, handles);
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in movstep.
function movstep_Callback(hObject, eventdata, handles)
% hObject    handle to movstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns movstep contents as cell array
%        contents{get(hObject,'Value')} returns selected item from movstep


% --- Executes during object creation, after setting all properties.
function movstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in residual.
function residual_Callback(hObject, eventdata, handles)
% hObject    handle to residual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
if disp.mapping==1  %this function is valuable only after mapping
    if ~disp.residual
        
        %         sys.line=findobj(handles.axes2,'')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         hline1=disp.     disp_info.curve(1);
        idx=disp.cur_line_idx;
        if size(idx,2)==2
            disp.residual=1;
            [x,dif_y]=residual(disp.line(idx(1)).handle,disp.line(idx(2)).handle,20);%两曲线句柄，采样距离
            disp.line_residual=plot(x,dif_y,'--*','linewidth',2);
            set(handles.up_error,'string',num2str(max(abs(dif_y))))
            set(handles.low_error,'string',num2str(min(abs(dif_y))))
            set(handles.residual,'backgroundcolor',[0.5 0.5 0.5])
        end
        
    else
        disp.residual=0;
        if ishandle(disp.line_residual)
            delete(disp.line_residual)
        end
        set(handles.up_error,'string','')
        set(handles.low_error,'string','')
        set(handles.residual,'userdata','nodisplayed','backgroundcolor',[0.95 0.95 0.95])
    end
    set(handles.axes2,'userdata',disp);
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
if disp.ButtonDown==1
    
    set(gcf,'pointer','fleur');
    ready_move_curve=disp.move_stat;
    N=str2double(ready_move_curve(end));
    if strcmp(disp.disp_stat{N},'disp_stat')  %如果曲线处于显示状态
        wpt=get(handles.axes2,'currentpoint');
        pt_x=round(wpt(1,1));
        pt_y=round(wpt(1,2));
        disp.cur_pos=[pt_x pt_y];
        %         [new_x,new_y]= curve_shift(h,shift_x,shift_y);
        %
        
        %         x=get(disp.line(curve_num).handle,'Xdata');
        %         y=get(disp.line(curve_num).handle,'Ydata');
        color=get(disp.line(N).handle,'color');
        if disp.last_pos(1,1)~=0
            shift_xy=disp.cur_pos-disp.last_pos;
            [new_x,new_y]= curve_shift(disp.line(N).handle,shift_xy);
            delete(disp.line(N).handle);
            disp.line(N).handle=plot(new_x,new_y,'color',color,'linewidth',2) ;
            disp.line(N).xlim=[new_x(1) new_x(end)];
            disp.line(N).xdata=new_x;
            disp.line(N).ydata=new_y;
            disp.line(N).ylim=[min(new_y) max(new_y)];
            [disp.line(N).max_pt,disp.line(N).min_pt]=line_max_min(disp.line(N).handle);
            
            
            %disp.line_bk(N)=disp.line(N);  %备份移动后的曲线句柄
            
            %             delete(disp_info.h_pt(2*curve_num-1:2*curve_num));
            %             delete(disp_info.curve(curve_num));
            %             x=x+cur_pos(1,1)-disp_info.last_pos(1,1);
            %             x=round(x);
            %             y=y+cur_pos(1,2)-disp_info.last_pos(1,2);
            %             y=round(y);  %取整数
            %     %         disp_info.h_pt(1:2)=plot(x(disp_info.max_idx(1)),y(disp_info.max_idx(1)),'o',x(disp_info.min_idx(1)),y(disp_info.min_idx(1)),'*','linewidth',2);
            %             disp_info.h_pt(2*curve_num-1)=scatter(x(disp_info.max_idx(curve_num)),y(disp_info.max_idx(curve_num)),...
            %                100,1000,'filled');
            %             disp_info.h_pt(2*curve_num)=scatter(x(disp_info.min_idx(curve_num)),y(disp_info.min_idx(curve_num)),...
            %                100,-1000,'filled');
            %             disp_info.curve(curve_num)=plot(x,y,'color',color) ;
        end
        disp.last_pos=disp.cur_pos;
        
        if disp.mapping
            mapping_Callback(hObject, eventdata, handles);
            disp.mapping=0;
        end
        if disp.residual
            disp.residual=0;
        end
        set(handles.find,'string','')
        set(handles.diff,'string','')
    end
    set(handles.axes2,'userdata',disp);
end


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
disp=get(handles.axes2,'userdata');
% set(handles.axes2,'xlim',disp.axes_xlim,'ylim',disp.axes_ylim)  %坐标轴置位
if disp.mapping
    mapping_Callback(hObject, eventdata, handles)
    disp.mapping=0;
end
if disp.residual
    disp.residual=0;
end
%%%%%%%%%%%%%%%%%%删除所有内容%%%%%%%%%%%%%%%%%%
delete(findobj(handles.axes2,'type','line'))
delete(findobj(handles.axes2,'type','hggroup'))
delete(findobj(gcf,'tag','legend'))
%%%%%%%%%%%%%%%%%%清空查询模块内容%%%%%%%%%%%%%%%%%%
set(handles.find,'string','')
set(handles.diff,'string','')
%%%%%%%%%%%%%%%%%%回复单选框默认值%%%%%%%%%%%%%%%%%%
set(handles.lock,'value',1)


RM_handles = getappdata(0,'RollMeter');
disp=get(RM_handles.axes1,'userdata');
set(handles.axes2,'userdata',disp)
disp_init(hObject, eventdata, handles)

disp=get(handles.axes2,'userdata');
Nline=size(disp.line,2);%曲线条数
filename=cell(1,Nline);
hline=zeros(1,Nline);  %临时存放曲线句柄
hold on
for i=1:Nline
    x=get(disp.line(i).handle,'xdata');
    y=get(disp.line(i).handle,'ydata');
    disp.line(i).xdata=x;
    disp.line(i).ydata=y;
    color=get(disp.line(i).handle,'color');
    lineStyle=get(disp.line(i).handle,'LineStyle');
    linewidth=get(disp.line(i).handle,'linewidth');
    disp.line(i).handle=plot(handles.axes2,x,y,'color',color,'linewidth',linewidth,'LineStyle',lineStyle);
    hline(i)=disp.line(i).handle;
    filename{i}= strrep(disp.line(i).filename,'_','\_'); %替换成反义字符
    set(disp.curv(i),'string','显示','foregroundcolor',color,'backgroundcolor',[0.9 0.9 0.9])
end
disp.leg.filenames=legend(hline,filename,2);
copyobj(disp.leg.filenames,gcf);
disp.leg.point=legend(hline,filename,1);
set(disp.leg.point,'visible','off')  %复制leg并隐藏

%disp.line_bk=disp.line;  %备份曲线句柄
disp.axes_xlim=get(handles.axes2,'xlim');
disp.axes_ylim=get(handles.axes2,'ylim');
set(handles.axes2,'userdata',disp)

%
% RM_handles = getappdata(0,'RollMeter');
% sys.line=findobj(RM_handles.axes1,'type','line');
% Nline=size(sys.line,1);
% set(handles.axes2,'userdata',Nline)
% disp_stat=disp_info.disp_stat;
% % axes(handles.axes2);
% for i=1:disp_info.nums
%     userdata.stat='Disp';
%     x=get(sys.line(i),'xdata');
%     y=get(sys.line(i),'ydata');
%     color=get(sys.line(i),'color');
%     disp_info.curve(i)=plot(handles.axes2,x,y,'color',color);
%
%         if strcmp(disp.language,'Chinese')
%             set(disp_stat(i),'backgroundcolor',[0.9 0.9 0.9],'userdata',userdata,'string','隐藏');
%         else
%             set(disp_stat(i),'backgroundcolor',[0.9 0.9 0.9],'userdata',userdata,'string','Hide');
%         end
%
% %     disp_info.h_pt(2*i-1:2*i)=plot(x(disp_info.max_idx(i)),y(disp_info.max_idx(i)),'o',x(disp_info.min_idx(i)),y(disp_info.min_idx(i)),'*','linewidth',2);
%     disp_info.h_pt(2*i-1)=scatter(x(disp_info.max_idx(i)),y(disp_info.max_idx(i)),...
%        100,1000,'filled');
%     disp_info.h_pt(2*i)=scatter(x(disp_info.min_idx(i)),y(disp_info.min_idx(i)),...
%        100,-1000,'filled');
% end
% userdata=get(handles.reset,'userdata');
% xlim(userdata.max_min_x);
% ylim(userdata.max_min_y);
% disp_info.disp_stat=disp_stat;
% handles.disp_info=disp_info;
% guidata(hObject, handles);

% --- Executes on button press in curv1.
function curv1_Callback(hObject, eventdata, handles)
% hObject    handle to curv1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,1)

% --- Executes on button press in curv2.
function curv2_Callback(hObject, eventdata, handles)
% hObject    handle to curv2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,2)


% --- Executes on button press in curv3.
function curv3_Callback(hObject, eventdata, handles)
% hObject    handle to curv3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,3)

% --- Executes on button press in curv4.
function curv4_Callback(hObject, eventdata, handles)
% hObject    handle to curv4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,4)

% --- Executes on button press in curv5.
function curv5_Callback(hObject, eventdata, handles)
% hObject    handle to curv5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,5)

% --- Executes on button press in curv6.
function curv6_Callback(hObject, eventdata, handles)
% hObject    handle to curv6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp_hide_Callback(hObject, eventdata, handles,6)



%%%%%%%%%%%SaveAs_Callback%%%%%%%%%%%
function SaveAs_Callback(hObject,eventdata)

%
%
filemenufcn(gcf,'FileSaveAs')





function disp_hide_Callback(hObject, eventdata, handles,num)
% hObject    handle to curv1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
N=size(disp.line,2);
i=num;
if i<=N
    if  strcmp(disp.disp_stat{i},'disp_stat')
        disp.disp_stat{i}='hide_stat';
        if strcmp(get(disp.leg.point,'visible'),'on')
            set(disp.leg.point,'visible','off');
        end
        
        for j=1:size(disp.pt,2)
            %       if point(i)
            if ishandle(disp.pt(j).handle)
                delete(disp.pt(j).handle);
            end
            %       end
        end
        
        %             leg=handles.disp_info.leg;
        %             point=disp_info.point;
        %
        %             for j=1:size(point,2)
        %                 if point(j)
        %                     if ishandle(point(j))
        %                         delete(point(j));
        %                     end
        %                 end
        %             end
        %             for j=1:size(leg,2)
        %                 if leg(j)
        %                     if ishandle(leg(j))
        %                         delete(leg(j));
        %                     end
        %                 end
        %             end
        %
        %                 if leg
        %                     del_leg=find0(ishandle(leg),1)
        %                     if ishandle(leg)
        %
        %                         delete(leg(del_leg));
        %                     end
        %                 end
        
        %             if sum(ishandle(handles.disp_info.leg))~=0
        %                 if ~strcmp(get(handles.disp_info.leg,'type'),'root')
        %                     delete(disp_info.leg);
        %                     delete(disp_info.point);
        %                 end
        %             end
        
        
        if strcmp(disp.language,'Chinese')
            set(disp.curv(i),'string','显示');
        else
            set(disp.curv(i),'string','Disp');
        end
        
        set(disp.curv(i),'backgroundcolor',[0.5 0.5 0.5]);
        if strcmp(get(disp.line(i).handle,'visible'),'on')
            %             disp.line(i).xdata=get(disp.line(i).handle,'xdata');
            %             disp.line(i).ydata=get(disp.line(i).handle,'ydata');
            set(disp.line(i).handle,'visible','off')
        end
        %     %     hide_curve=findobj(handles.axes2,'color',get(disp_info.disp_stat(i),'foregroundcolor'),'type','line');
        %         userdata.x=get(disp_info.curve(i),'xdata');
        %         userdata.y=get(disp_info.curve(i),'ydata');
        %         delete(disp_info.curve(i));
        %         delete(disp_info.h_pt(2*i-1));
        %         delete(disp_info.h_pt(2*i));
        %         Nline=get(handles.axes2,'userdata')-1;
        
    else
        disp.disp_stat{i}='disp_stat';
        
        if strcmp(disp.language,'Chinese')
            set(disp.curv(i),'string','隐藏');
        else
            set(disp.curv(i),'string','Hide');
        end
        
        set(disp.curv(i),'backgroundcolor',[0.9 0.9 0.9]);
        set(disp.line(i).handle,'visible','on')
        %         x=disp.line(i).xdata;
        %         y=disp.line(i).ydata;
        %         disp.line(i).handle=plot(x,y,'color',disp.color(i));
        %         disp.line(i)=%disp.line_bk(i);
        %         disp.line(i).handle=line_plot(%disp.line_bk(i).handle);
        %         disp.line(i).handle=
        %         x=userdata.x;
        %         y=userdata.y;
        % %         axes(handles.axes2);
        %         disp_info.curve(i)=plot(x,y,'color',get(disp_info.disp_stat(i),'foregroundcolor'));
        %         Nline=get(handles.axes2,'userdata')+1;
        %         disp_info.h_pt(2*i-1)=scatter(x(disp_info.max_idx(i)),y(disp_info.max_idx(i)),...
        %            100,1000,'filled');
        %         disp_info.h_pt(2*i)=scatter(x(disp_info.min_idx(i)),y(disp_info.min_idx(i)),...
        %            100,-1000,'filled');
        
        
    end
    %获得显示曲线下标
    Nline=0;     %限制在坐标轴中的曲线数目
    disp.cur_line_idx=0;%显示下标清零
    for i=1:N
        if strcmp(get(disp.line(i).handle,'visible'),'on')
            Nline=Nline+1;
            disp.cur_line_idx(Nline)=i;
        end
    end
    set(handles.axes2,'UserData',disp);
end



function current_input_Callback(hObject, eventdata, handles)
% hObject    handle to find0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of find0 as text
%        str2double(get(hObject,'String')) returns contents of find0 as a double


% --- Executes during object creation, after setting all properties.
function find0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to find0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in find0.
function find0_Callback(hObject, eventdata, handles)
% hObject    handle to find0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value=get(handles.find,'string');
value=str2double(value);
disp=get(handles.axes2,'userdata');
N=size(disp.line,2); %总曲线数

Nline=0;     %限制在坐标轴中的曲线数目
for i=1:N
    if strcmp(get(disp.line(i).handle,'visible'),'on')
        Nline=Nline+1;
        disp.cur_line_idx(Nline)=i;
    end
end
idx=disp.cur_line_idx;
%%%%%%%%%%%%%%%%%%%删除历史坐标%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(disp.pt,2)
    %                 if point(i)
    if ishandle(disp.pt(i).handle)
        delete(disp.pt(i).handle);
    end
    %                 end
end

%%%%%%%%%%%%%%%%%%%句柄转换%%%%%%%%%%%%%%%%%%%%%%%%%%
hline=zeros(1,Nline);
for i=1:Nline
    hline(i)=disp.line(idx(i)).handle;
end

[fit_y,leg_str,h_pt]=find_fit_data(hline,value,1);
%%%%%%%%%%%%%%%%%%%句柄转换%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:Nline
    disp.pt(i).handle=h_pt(:,1);
end

if Nline==2;
    set(handles.diff,'string',fit_y(1,1)-fit_y(2,1))
end
disp.leg.point=legend(h_pt(:,1),leg_str(:,1)); %value_line_nums 有效曲线编号

set(handles.axes2,'userdata',disp)


function diff_Callback(hObject, eventdata, handles)
% hObject    handle to diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diff as text
%        str2double(get(hObject,'String')) returns contents of diff as a double


% --- Executes during object creation, after setting all properties.
function diff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function test_current_value_Callback(hObject, eventdata, handles)
% hObject    handle to test_current_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of test_current_value as text
%        str2double(get(hObject,'String')) returns contents of test_current_value as a double


% --- Executes during object creation, after setting all properties.
function test_current_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test_current_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%显示界面变量初始化%%%%%%%%%%%%%%%%%%%%%%%%%
function disp_init(hObject, eventdata, handles)
sys=get(handles.axes2,'userdata');

disp.language=sys.language;
empty_line_idx=get_value_handle_idx(sys.line);
disp.line=sys.line(empty_line_idx);

if ishandle(sys.theo_line.handle)
    if size(disp.line,2)
        disp.line(end+1)=sys.theo_line; 
        if ishandle(sys.theo_line_err_up.handle)
            disp.line(end+1)=sys.theo_line_err_up; 
            disp.line(end+1)=sys.theo_line_err_low; 
        end
    else
        disp.line=sys.theo_line;
    end
end
disp.h_xline='';%横纵坐标线
disp.h_yline='';
disp.curv(1)=handles.curv1;   %移动曲线显示
disp.curv(2)=handles.curv2;
disp.curv(3)=handles.curv3;
disp.curv(4)=handles.curv4;
disp.curv(5)=handles.curv5;
disp.curv(6)=handles.curv6;

for i=1:6
    disp.disp_stat{i}='disp_stat';   %移动曲线显示
end
disp.color=sys.color;
% disp.leg.filenames='';
% disp.leg.filenames='';  %
% disp.leg.filenames_str='';
disp.pt.handle='';
disp.last_pos=[0 0];
disp.cur_pos=[0 0];
disp.ButtonDown=0;
disp.mapping=0;
disp.residual=0;
disp.move_stat='lock';
disp.cur_line_idx=1:size(disp.line,2);%初始化下标，所有曲线都为其下标值
set(handles.axes2,'userdata',disp)


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp=get(handles.axes2,'userdata');
N=size(disp.line,2); %总曲线数
Nline=0;
for i=1:N
    if strcmp(get(disp.line(i).handle,'visible'),'on')
        Nline=Nline+1;
        disp.cur_line_idx(Nline)=i;
    end
end

if Nline
    wpt=get(handles.axes2,'currentpoint');
    seach_pt_x=round(wpt(1,1));
    seach_pt_y=round(wpt(1,2));
    
    
    ready_move_curve=disp.move_stat;
    if strcmp(ready_move_curve,'lock')
        if strcmp(get(gcf,'selectiontype'),'normal')  %鼠标是否单击
            set(gcf,'pointer','cross');
            %             point=disp.
            for i=1:size(disp.pt,2)
                %                 if point(i)
                if ishandle(disp.pt(i).handle)
                    delete(disp.pt(i).handle);
                end
                %                 end
            end
            hline=zeros(1,Nline);
            %%%%%%%%%%%%%%%%%%%句柄转换%%%%%%%%%%%%%%%%%%%%%%%%%%
            for i=1:Nline
                hline(i)=disp.line(disp.cur_line_idx(i)).handle;
            end
            [fit_y,leg_str,h_pt]=find_fit_data(hline,seach_pt_x,1);
            disp.pt(i).handle=h_pt(:,1);
            if Nline==2;
                set(handles.diff,'string',fit_y(1)-fit_y(2))
            end
            ylim=get(handles.axes2,'ylim');
            xlim=get(handles.axes2,'xlim');
            disp.h_yline=line([seach_pt_x,seach_pt_x],ylim);
            disp.h_xline=line(xlim,[seach_pt_y seach_pt_y]);
            disp.leg.point=legend(h_pt(:,1),leg_str(:,1)); %value_line_nums 有效曲线编号
            set(handles.find,'string',num2str(seach_pt_x))%获取鼠标点并显示在查询框中
        end
        
    else
        if strcmp(get(gcf,'selectiontype'),'normal')  %鼠标是否单击
            disp.ButtonDown=1;
            disp.cur_pos=[seach_pt_x seach_pt_y];
        end
    end
    set(handles.axes2,'userdata',disp)
    guidata(hObject, handles);
    
end
