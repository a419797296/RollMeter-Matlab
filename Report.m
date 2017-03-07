function varargout = Report(varargin)
% RESULT MATLAB code for result.fig
%      RESULT, by itself, creates a new RESULT or raises the existing
%      singleton*.
%
%      H = RESULT returns the handle to a new RESULT or the handle to
%      the existing singleton*.
%
%      RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULT.M with the given input arguments.
%
%      RESULT('Property','Value',...) creates a new RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Report_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Report_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help result

% Last Modified by GUIDE v2.5 26-Feb-2016 19:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Report_OpeningFcn, ...
                   'gui_OutputFcn',  @Report_OutputFcn, ...
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


% --- Executes just before result is made visible.
function Report_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to result (see VARARGIN)

% Choose default command line output for result
% warning('off','MATLAB:HndleGraphics:obsoletedProperty:JaveFrame');
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('rollmeter.png'));
chgicon(gcf,'rollmeter.png')
RM_handles =getappdata(0,'RollMeter');
sys=get(RM_handles.axes1,'userdata');
if strcmp(sys.language,'Chinese')
    set(hObject,'name','辊子中高检测报告')
    set(handles.title,'string','辊子中高检测报告')
    set(handles.print_result,'label','打印')
    set(gcf,'name','打印报表')
    set(handles.conclude,'string','结论：')
    langu=2;

else
    set(hObject,'name','Report')
    set(handles.title,'string','Crown Profile Measurement Report')
    set(handles.print_result,'label','Print')
    set(gcf,'name','Report')
    set(handles.conclude,'string','Result: ')
    langu=3;
end

    h_info=load('languages.mat');
    info=h_info.info;  
    set(handles.generaldata,'title',info(langu).generaldata)
    set(handles.measlength0,'string',info(langu).measlength0)
    set(handles.rollcenter0,'string',info(langu).rollcenter0)
    set(handles.datameas,'string',info(langu).datameas)
    set(handles.inspector0,'string',info(langu).inspector0)
    set(handles.rollnum0,'string',info(langu).rollnum0)
    set(handles.resp0,'string',info(langu).resp0)
    set(handles.datameas,'string',info(langu).datameas)
    set(handles.rolltype0,'string',info(langu).rolltype0)
    set(handles.rolldata,'title',info(langu).rolldata)
    set(handles.suppliers0,'string',info(langu).suppliers0)
    set(handles.measstep0,'string',info(langu).measstep0)
    set(handles.rolllength0,'string',info(langu).rolllength0)

set(handles.rolltype,'string',get(RM_handles.rolltype,'string'))
set(handles.rollnum,'string',get(RM_handles.rollnum,'string'))
set(handles.suppliers,'string',get(RM_handles.suppliers,'string'))
set(handles.inspector,'string',get(RM_handles.inspector,'string'))
set(handles.resp,'string',get(RM_handles.resp,'string'))
set(handles.rollcenter,'string',get(RM_handles.rollcenter,'string'))
set(handles.rolllength,'string',get(RM_handles.rolllength,'string'))
set(handles.measlength,'string',get(RM_handles.measlength,'string'))
set(handles.measstep,'string',get(RM_handles.measstep,'string'))
set(handles.date,'string',get(RM_handles.date,'string'))
set(handles.time,'string',get(RM_handles.time,'string'))
set(handles.printtime,'string',date)
disp=sys;

empty_line_idx=[];
for i=1:size(disp.line,2)
    if ~ishandle(disp.line(i).handle)
       empty_line_idx(end+1)=i;
    end
end
disp.line(empty_line_idx)=[];

if ishandle(sys.theo_line.handle)
    if size(disp.line,2)
        disp.line(end+1)=sys.theo_line;
        if get(RM_handles.disp_limit_err,'value')
            disp.line(end+1)=sys.theo_line_err_up; 
            disp.line(end+1)=sys.theo_line_err_low; 
        end

    else
        disp.line=sys.theo_line;
    end
end
Nline=size(disp.line,2);%曲线条数
axes(handles.result)
hold on
%     set(gca,'Fontsize',12)
grid on
error_range=get(RM_handles.limit_err,'string');
error_range=str2double(error_range);
if Nline==1
    filename=disp.line(1).filename;
    if isempty(strfind(filename, 'theory'))&&isempty(strfind(filename, 'fit'))%原始曲线
        hline(1)=plot_handle(disp.line(1).handle);
        L=str2double(get(RM_handles.rolllength,'string')); 

        calib_mode=get(RM_handles.calibr_mode,'value');
        xlim([0 L])
        st=1; 
        
        sys.theo_line.filename=[sys.cur_dir_name,'_theory_file_creat'];%目标文件名
        sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);

        orig_file_path=[sys.cur_dir_name,'_theory_file.txt'];%源文件名
        orig_file_path=fullfile(sys.cur_dir_path,orig_file_path);
        %%%%%%%%%%%%%%%%%%读取理论曲线%%%%%%%%%%%%%%%%
        fid = fopen(orig_file_path);
        C_data = textscan(fid, '%d %d', 'CollectOutput', 1);
        %                         set(handles.measstep,'string','NULL');
        %write the theory file name and change the disp color

        %%%%%%%%%%%%%%%%%%理论曲线数据文件中是否为空%%%%%%%%%%%%%%%%
        if isempty(C_data{1})

            if strcmp(sys.language,'English')
                message=['There is no data in this file. please open the file on the path of ',sys.theo_line.filepath,' then wirte the crown data.'];
            end
            if  strcmp(sys.language,'Chinese')
                message=['文件中不存在理论曲线数据,请打开',sys.theo_line.filepath,'并录入该辊子理论中高数据'];
            end
            myDialog('erro',message)
        else
            theo_x=double(C_data{1}(:,1));
            theo_y=double(C_data{1}(:,2));
            if calib_mode
                theo_y=theo_y*2;
            end
%             sys.theo_line.xlim=[theo_x(1) theo_x(end)];
%             sys.theo_line.ylim=[min(theo_y) max(theo_y)];
%             sys.theo_line.xdata=theo_x;
%             sys.theo_line.ydata=theo_y;
%             sys.theo_line.length=theo_x(end);
%             sys.theo_line.filename=[sys.cur_dir_name,'_theory_file_creat'];
            hline(2)=plot(theo_x,theo_y,'--','color','k','linewidth',2);%理论曲线
            [move_curve,cor_max,shift_xy]=mapping(hline(1),hline(2),20,80);
            if move_curve==2
                shift_xy=-shift_xy;
            end
            [new_x,new_y]=curve_shift(hline(1),shift_xy); %始终移动测量曲线
            color=get(hline(1),'color');
            lineStyle=get(hline(1),'LineStyle');
            linewidth=get(hline(1),'linewidth');
            delete(hline(1))%删除测量曲线
            hline(1)=plot(new_x,new_y,'color',color,'linestyle',lineStyle,'linewidth',linewidth);
            N=max(size(theo_x));
            fit_y=zeros(1,N);
            for i=1:N
                fit_y(i)=find_fit_data(hline(1),theo_x(i),0);
            end
            error=theo_y'-fit_y;
            err_idx=find(abs(error)>error_range);
            if ~isempty(err_idx)
%                 find_fit_data(hline(1),theo_x(err_idx),1);
                 plot(theo_x(err_idx),find_fit_data(hline(1),theo_x(err_idx),0),'k*','linewidth',2)
            end
            if get(RM_handles.disp_limit_err,'value')
                plot(theo_x,theo_y+error_range,'r--','linewidth',2);
%                 x_lim=get(gca,'xlim');
                y_lim=get(gca,'ylim');
%                 left_pos=x_lim(1)-(x_lim(2)-x_lim(1))/25;
                dist_pos=(y_lim(2)-y_lim(1))/20;
                h=text(0,dist_pos,num2str(error_range),'HorizontalAlignment','right','FontSize',10);
                plot(theo_x,theo_y-error_range,'b--','linewidth',2);
                h=text(0,-dist_pos,num2str(-error_range),'HorizontalAlignment','right','FontSize',10);
            end
           
        end
    else  %  拟合曲线或者理论曲线
        max_pt=disp.line(1).max_pt;
        plot_handle(disp.line(1).handle);
    end
%     plot(max_pt(1),max_pt(2),'o','linewidth',3)
%     
%     if strcmp(sys.language,'Chinese')
%         conclusion=['该辊子最大中高位于',num2str(max_pt(1)),' mm左右，其值为',num2str(max_pt(2)),' um。'];
%     else
%         conclusion=['The MAX roll crown is located at ', num2str(max_pt(1)),' mm, the value is ',num2str(max_pt(2)),' um.'];
%     end
% 
%     set(handles.conclusion,'string',conclusion)
else
    for i=1:Nline
        theo_x=get(disp.line(i).handle,'xdata');
        theo_y=get(disp.line(i).handle,'ydata');
        color=get(disp.line(i).handle,'color');
        lineStyle=get(disp.line(i).handle,'LineStyle');
        linewidth=get(disp.line(i).handle,'linewidth');
        disp.line(i).handle=plot(theo_x,theo_y,'color',color,'linewidth',linewidth,'LineStyle',lineStyle);
        if ~isempty(strfind(disp.line(i).filename,'theo_line_err_up'))
%             x_lim=get(gca,'xlim');
            y_lim=get(gca,'ylim');
%             left_pos=x_lim(1)-(x_lim(2)-x_lim(1))/25;
            dist_pos=(y_lim(2)-y_lim(1))/20;
            h=text(0,dist_pos,num2str(error_range),'HorizontalAlignment','right','FontSize',10);
        end
        if ~isempty(strfind(disp.line(i).filename,'theo_line_err_low'))
%             x_lim=get(gca,'xlim');
            y_lim=get(gca,'ylim');
%             left_pos=x_lim(1)-(x_lim(2)-x_lim(1))/25;
            dist_pos=(y_lim(2)-y_lim(1))/20;
            h=text(0,-dist_pos,num2str(-error_range),'HorizontalAlignment','right','FontSize',10);
        end
    end
    if get(RM_handles.open_auto_mapping,'value')
        mapping_all(disp.line,[1 1]);
    end
    
%     if ishandle(sys.theo_line_err_up_text_handle)
%         h=text(0,theo_y(1)+error_range,num2str(error_range),'HorizontalAlignment','right','FontSize',10)
%         h=text(0,theo_y(1)-error_range,num2str(-error_range),'HorizontalAlignment','right','FontSize',10)
%     end
    set(handles.conclude,'visible','off')
end

% ----------------------------------------------------------------------

% -------------------------------------------------------------------------

    title(get(get(RM_handles.axes1,'title'),'string'),'Fontsize',12)
    xlabel(get(get(RM_handles.axes1,'xlabel'),'string'),'Fontsize',12)
    ylabel(get(get(RM_handles.axes1,'ylabel'),'string'),'Fontsize',12)

    

handles.RM_handles=RM_handles;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes result wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Report_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rollcenter_Callback(hObject, eventdata, handles)
% hObject    handle to rollcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rollcenter as text
%        str2double(get(hObject,'String')) returns contents of rollcenter as a double


% --- Executes during object creation, after setting all properties.
function rollcenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rollcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rolllength_Callback(hObject, eventdata, handles)
% hObject    handle to rolllength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rolllength as text
%        str2double(get(hObject,'String')) returns contents of rolllength as a double


% --- Executes during object creation, after setting all properties.
function rolllength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rolllength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measlength_Callback(hObject, eventdata, handles)
% hObject    handle to measlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measlength as text
%        str2double(get(hObject,'String')) returns contents of measlength as a double


% --- Executes during object creation, after setting all properties.
function measlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measstep_Callback(hObject, eventdata, handles)
% hObject    handle to measstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measstep as text
%        str2double(get(hObject,'String')) returns contents of measstep as a double


% --- Executes during object creation, after setting all properties.
function measstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppliers_Callback(hObject, eventdata, handles)
% hObject    handle to suppliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suppliers as text
%        str2double(get(hObject,'String')) returns contents of suppliers as a double


% --- Executes during object creation, after setting all properties.
function suppliers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rolltype_Callback(hObject, eventdata, handles)
% hObject    handle to rolltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rolltype as text
%        str2double(get(hObject,'String')) returns contents of rolltype as a double


% --- Executes during object creation, after setting all properties.
function rolltype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rolltype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inspector_Callback(hObject, eventdata, handles)
% hObject    handle to inspector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inspector as text
%        str2double(get(hObject,'String')) returns contents of inspector as a double


% --- Executes during object creation, after setting all properties.
function inspector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inspector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function print_result_Callback(hObject, eventdata, handles)
% hObject    handle to print_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% filemenufcn(gcf, 'FilePrintSetup');
printpreview(gcf);
