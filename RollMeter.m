function varargout = RollMeter(varargin)
% ROLLMETER MATLAB code for RollMeter.fig
%      ROLLMETER, by itself, creates a new ROLLMETER or raises the existing
%      singleton*.
%
%      H = ROLLMETER returns the handle to a new ROLLMETER or the handle to
%      the existing singleton*.
%
%      ROLLMETER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROLLMETER.M with the given input arguments.
%
%      ROLLMETER('Property','Value',...) creates a new ROLLMETER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RollMeter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RollMeter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RollMeter

% Last Modified by GUIDE v2.5 26-Sep-2016 10:01:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RollMeter_OpeningFcn, ...
    'gui_OutputFcn',  @RollMeter_OutputFcn, ...
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


% --- Executes just before RollMeter is made visible.
function RollMeter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
% varargin   command line arguments to RollMeter (see VARARGIN)

% Choose default command line output for RollMeter
% set(gcf,'position',get(0,'ScreenSize'))
chgicon(gcf,'rollmeter.png')

%%%%%%%%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%%%%
% mainHandle=start_fig; % ��һ��GUI������Ϊgui2
% pause(2); % ��ʾ3��
% close(mainHandle); %��ʾ3��󣬹ر�

if ~exist('C:\Windows\System32\atiroll.dll','file')
    myDialog('mess','Can not Find the Registration Information!')
    error('can not find the atiroll.dll!')
end
sys=sys_init(hObject, eventdata, handles);
path='c:\Measure\';
%
% test_data=1;   %wheather the test_data existed
i=1;
while path(1)~='m'
    if isdir(path)
        system_path{i}=path;
        i=i+1;
    end
    path(1)=path(1)+1;
end

if isempty(system_path)
    if strcmp(sys.language,'English')
        message='Can not find the path';
    else
        strcmp(sys.language,'Chinese')
        message='�޷��ҵ�·����';
    end
    myDialog('erro',message);
else
    db_gui=cell(1,1);
    set(gcf,'userdata',db_gui);
    axes(handles.axes1);
    grid on
    sys.system_paths=system_path';
    sys.working_path=sys.system_paths{1};
    set(handles.system_paths,'string',system_path')
    set(handles.axes1,'userdata',sys);
    open_working_path(hObject, eventdata, handles, system_path{1}) ;  
end



% warning('off','MATLAB:HndleGraphics:obsoletedProperty:JaveFrame');
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('rollmeter.png'));


% Update handles structure


chinese_Callback(hObject, eventdata, handles);
sys=get(handles.axes1,'userdata');
set(handles.axes1,'userdata',sys);
handles.output = hObject;
guidata(hObject, handles);
% set(gcf,'position',get(0,'ScreenSize'))
% set(hObject,'name','�����и߷���ϵͳ')

% UIWAIT makes RollMeter wait for user response (see UIRESUME)
% uiwait(handles.main_interface);


% --- Outputs from this function are returned to the command line.
function varargout = RollMeter_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function print_result_Callback(hObject, eventdata, handles)
% hObject    handle to print_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
%---------------------------------------------use matlab print
% RM_handles=guihandles(gcf);
% setappdata(0,'RollMeter',RM_handles);
% Report;
%---------------------------------------------use c# to print
print_path='./Printed data';
if ~exist(print_path,'dir')
    mkdir(print_path)
end
DIRS=dir(print_path);
 
n=length(DIRS);
for i=1:n
 if ( ~strcmp(DIRS(i).name,'.') && ~strcmp(DIRS(i).name,'..') )
  delete(fullfile(print_path,DIRS(i).name))
 end
end
 
sys=get(handles.axes1,'userdata');

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
        if get(handles.disp_limit_err,'value')
            disp.line(end+1)=sys.theo_line_err_up; 
            disp.line(end+1)=sys.theo_line_err_low; 
        end

    else
        disp.line=sys.theo_line;
    end
end
Nline=size(disp.line,2);%��������

        %---------------------------------------------save the parameter

        filepath='./Printed data/para.txt';
        fp = fopen(filepath,'wt');
        if fp==-1
            return
        else
%             fprintf(fp, '�ļ�·��\t%s\n',disp.line(1).filepath);
            fprintf(fp, '��Ӧ��\t%s\n',get(handles.suppliers,'string'));
            fprintf(fp, '���Ա\t%s\n',get(handles.inspector,'string'));
            fprintf(fp, '������\t%s\n',get(handles.resp,'string'));
            fprintf(fp, '����\t%s\n',get(handles.rollcenter,'string'));
            fprintf(fp, '��������\t%s\n',get(handles.rolltype,'string'));
            fprintf(fp, '���ӳ���\t%s\n',get(handles.rolllength,'string'));
            fprintf(fp, '��������\t%s\n',get(handles.measlength,'string'));
            fprintf(fp, '��������\t%s\n',get(handles.measstep,'string'));
            fprintf(fp, '����\t%s\n',get(handles.rollnum,'string'));
            fprintf(fp, '�������\t%s\n',get(handles.limit_err,'string'));
            fprintf(fp, '����\t%s\n',sys.language);
            data=get(handles.date,'string');
            time=get(handles.time,'string');
            meas_time=[data ' ' time];
            fprintf(fp, '����\t%s\n',meas_time);
            fclose(fp);
        end
        %---------------------------------------------save the parameter   
            error_range=get(handles.limit_err,'string');
            error_range=str2double(error_range);
if Nline==1
    filename=disp.line(1).filename;
    if isempty(strfind(filename, 'theory'))&&isempty(strfind(filename, 'fit'))%ԭʼ����
        

        calib_mode=get(handles.calibr_mode,'value');
        sys.theo_line.filename=[sys.cur_dir_name,'_theory_file_creat'];%Ŀ���ļ���
        sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);

        orig_filename=[sys.cur_dir_name,'_theory_file.txt'];%Դ�ļ���
        orig_filepath=fullfile(sys.cur_dir_path,orig_filename);
        
       
        %%%%%%%%%%%%%%%%%%��ȡ��������%%%%%%%%%%%%%%%%
        fid = fopen(orig_filepath);
        C_data = textscan(fid, '%d %d', 'CollectOutput', 1);
        %                         set(handles.measstep,'string','NULL');
        %write the theory file name and change the disp color

        %%%%%%%%%%%%%%%%%%�������������ļ����Ƿ�Ϊ��%%%%%%%%%%%%%%%%
        if isempty(C_data{1})

            if strcmp(sys.language,'English')
                message=['There is no data in this file. please open the file on the path of ',sys.theo_line.filepath,' then wirte the crown data.'];
            end
            if  strcmp(sys.language,'Chinese')
                message=['�ļ��в�����������������,���',sys.theo_line.filepath,'��¼��ù��������и�����'];
            end
            myDialog('erro',message)
            filename=disp.line(1).filename;
            save_print_data(filename,disp.line(1).xdata,disp.line(1).ydata);       %save the up limit err
        else
            copyfile(orig_filepath,fullfile(print_path,orig_filename));          %if the theoy file exist, then copy the file to the printed data dir
            theo_x=double(C_data{1}(:,1));
            theo_y=double(C_data{1}(:,2));
            if calib_mode
                theo_y=theo_y*2;
            end
            %--------------------------------------------�ж��Ƿ���ʾ�����������
            if get(handles.disp_limit_err,'value')
                save_print_data('line_err_up.txt',theo_x,theo_y+error_range);       %save the up limit err
                save_print_data('line_err_low.txt',theo_x,theo_y-error_range);       %save the low limit err
            end
            %--------------------------------------------�ж��Ƿ���ʾ�����������
            
            hline(1)=plot_handle(disp.line(1).handle);
            hline(2)=plot(theo_x,theo_y,'--','color','k','linewidth',2);%��������
            set(hline(1),'visible','off');
            set(hline(2),'visible','off');
            [move_curve,cor_max,shift_xy]=mapping(hline(1),hline(2),20,80);
            
            if move_curve==2
                shift_xy=-shift_xy;
            end
            [new_x,new_y]=curve_shift(hline(1),shift_xy); %ʼ���ƶ���������
            delete(hline)
            

            save_print_data(disp.line(1).filename,new_x,new_y);       %save the test data after mapping

            hline(1)=plot(new_x,new_y);
            set(hline(1),'visible','off');
            N=size(theo_x,1);
            fit_y=zeros(1,N);
            for i=1:N
                fit_y(i)=find_fit_data(hline(1),theo_x(i),0);
            end
            delete(hline(1))
            save_print_data('actual_data.txt',theo_x,fit_y);       %save the fit data
            
            
            
            error=theo_y'-fit_y;
            err_idx=find(abs(error)>error_range);
            if ~isempty(err_idx)                    % if the err_idx is not empty, then save the issue data
                save_print_data('issue_data.txt',theo_x(err_idx),fit_y(err_idx));       %save the issue data
            end
           
        end
    else  %  ������߻�����������
        filename=disp.line(1).filename;
        filepath=fullfile(print_path,filename); 
        fp = fopen(filepath,'wt');        
        x=get(disp.line(1).handle,'xdata');
        y=get(disp.line(1).handle,'ydata');
        L=size(x,2);
        for j =1:L
            fprintf(fp, '%d\t%d\n', x(j),y(j));
        end
        fclose(fp);
    end
else
    for i=1:Nline
        filename=disp.line(i).filename;
        filepath=fullfile(print_path,filename); 
        fp = fopen(filepath,'wt');        
        x=get(disp.line(i).handle,'xdata');
        y=get(disp.line(i).handle,'ydata');
        L=size(x,2);
        for j =1:L
            fprintf(fp, '%d\t%d\n', x(j),y(j));
        end
        fclose(fp);
    end
end
open('./Debug/BarCode.exe')
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to rollnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rollnum as text
%        str2double(get(hObject,'String')) returns contents of rollnum as a double


% --- Executes during object creation, after setting all properties.
function rollnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rollnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function customer_Callback(hObject, eventdata, handles)
% hObject    handle to customer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of customer as text
%        str2double(get(hObject,'String')) returns contents of customer as a double


% --- Executes during object creation, after setting all properties.
function customer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to customer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ordernum_Callback(hObject, eventdata, handles)
% hObject    handle to ordernum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ordernum as text
%        str2double(get(hObject,'String')) returns contents of ordernum as a double


% --- Executes during object creation, after setting all properties.
function ordernum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ordernum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cover_Callback(hObject, eventdata, handles)
% hObject    handle to cover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cover as text
%        str2double(get(hObject,'String')) returns contents of cover as a double


% --- Executes during object creation, after setting all properties.
function cover_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cover (see GCBO)
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
% handles    structure with handles and user date (see GUIDATA)

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



function resp_Callback(hObject, eventdata, handles)
% hObject    handle to resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resp as text
%        str2double(get(hObject,'String')) returns contents of resp as a double


% --- Executes during object creation, after setting all properties.
function resp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function remark_Callback(hObject, eventdata, handles)
% hObject    handle to remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remark as text
%        str2double(get(hObject,'String')) returns contents of remark as a double


% --- Executes during object creation, after setting all properties.
function remark_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rough_Callback(hObject, eventdata, handles)
% hObject    handle to rough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rough as text
%        str2double(get(hObject,'String')) returns contents of rough as a double


% --- Executes during object creation, after setting all properties.
function rough_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rough (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hard_Callback(hObject, eventdata, handles)
% hObject    handle to hard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hard as text
%        str2double(get(hObject,'String')) returns contents of hard as a double


% --- Executes during object creation, after setting all properties.
function hard_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function color_Callback(hObject, eventdata, handles)
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)



% --------------------------------------------------------------------
function colour_Callback(hObject, eventdata, handles)
% hObject    handle to colour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
% c=uisetcolor(curve,'choose the color');
c=uisetcolor(handles.curve,'choose the color');
% --------------------------------------------------------------------
function print_Callback(hObject, eventdata, handles)
% hObject    handle to print (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
printdlg(handles.curve);%��Windows��ӡ�Ի���


% --------------------------------------------------------------------
function red_Callback(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
set(handles.curve,'color','r')


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in curve_files.
function curve_files_Callback(hObject, eventdata, handles)
% hObject    handle to curve_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns curve_files contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curve_files



% --- Executes during object creation, after setting all properties.
function curve_files_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curve_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in theoprof.
function theoprof_Callback(hObject, eventdata, handles)
% hObject    handle to theoprof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns theoprof contents as cell array
%        contents{get(hObject,'Value')} returns selected item from theoprof
prof=get(handles.theoprof,'Value');

set(handles.axes1);
x=0:0.01:2*pi;
switch prof
    case 1
        
    case 2
        y=cos(x);
        plot(x,y)
    case 3
        y=sin(x)+cos(x);
        plot(x,y)
end


% --- Executes during object creation, after setting all properties.
function theoprof_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theoprof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% % % %
% % % % % --- If Enable == 'on', executes on mouse press in 5 pixel border.
% % % % % --- Otherwise, executes on mouse press in 5 pixel border or over curve_files.
% % % % function curve_files_ButtonDownFcn(hObject, eventdata, handles)
% % % % % hObject    handle to curve_files (see GCBO)
% % % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % % handles    structure with handles and user date (see GUIDATA)
% % % % global ButtonDown;
% % % % xxx=get(handles.curve_files,'SelectionType')
% % % % if strcmp(get(handles.curve_files,'SelectionType'),'normal');
% % % %     ButtonDown=1
% % % %     a=55
% % % % end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
sys=get(handles.axes1,'userdata');
fulpath=sys.cur_dir_path;
list_filenames=sys.list_filenames;
% fulpath=get(handles.curve_files,'userdata');
% filenames=get(handles.curve_files,'string');    %get all the files from the list



select_idx=get(handles.curve_files,'value');
list_str=get(handles.curve_files,'string');
if isempty(list_filenames)
    h_info=load('languages.mat');
    info=h_info.info;
    if strcmp(sys.language,'English')
        message=info(3).chooseFileFirst;
    else
        strcmp(sys.language,'Chinese')
        message=info(2).chooseFileFirst;
    end
    myDialog('warn',message);
else
    hdisp=sys.hdisp;
    hdel=sys.hdel;
    
    filename=list_str{select_idx};
    
    %     %����������Ѿ����ع�����ֱ������ָ���ʾ
    %     exist_line_num=max(size(sys.line));
    %     for i=1:exist_line_num
    %         if strcmp(sys.line(i).filename,filename)
    %             set(sys.line(i).handle,'visible','on')
    %             if ishandle(sys.line(i).leg)
    %                 set(sys.line(i).leg,'visible','on')
    %             end
    %             return
    %         end
    %     end
    
    %����������ǵ�һ�μ���
    for i=1:6
        if isempty(get(hdisp(i),'string'))
            curve_nums=i;
            sys.line(curve_nums).filename=filename;
            
            set(hdisp(curve_nums),'string',sys.line(curve_nums).filename,'ForegroundColor',sys.color(curve_nums,:)); %���ļ���д���Ӧ���ı�����
            if i>3            %if the disp curves are more than 3, than, show the hide control
                set(hdisp(curve_nums),'string',sys.line(curve_nums).filename,'ForegroundColor',sys.color(curve_nums,:),'visible','on');
                set(hdel(curve_nums),'visible','on');
            end
            
            %%%%%%%%%%%%%%%%%%��ȡ�ļ�����%%%%%%%%%%%%%%%%
            sys.line(curve_nums).filepath=fullfile(fulpath, sys.line(curve_nums).filename);
            [x,y]=load_test_file(hObject, eventdata, handles, sys.line(curve_nums).filepath);
            sys.line(curve_nums).length=str2double(get(handles.rolllength,'string'));
            sys.line(curve_nums).xlim=[x(1) x(end)];
            sys.line(curve_nums).xdata=x;
            sys.line(curve_nums).ydata=y;
            sys.line(curve_nums).ylim=[min(y) max(y)];
            sys.line(curve_nums).nums=max(size(x));
            sys.line(curve_nums).handle=plot(x,y,'color',sys.color(curve_nums,:),'linewidth',1.5);
            [sys.line(curve_nums).max_pt,sys.line(curve_nums).min_pt]=line_max_min(sys.line(curve_nums).handle);
            %%%%%%%%%%%%%%%%%%������ȡ����%%%%%%%%%%%%%%%%
            if ~exist('db_gui.mat','file')    %����������ļ����򴴽�
                db_gui{1}='Start';
                save('db_gui.mat','db_gui')
            end
            db_gui=load('db_gui.mat');
            db_gui=db_gui.db_gui;
            N=size(db_gui,2);  %Ԫ������
            for j=2:N
                if strcmp(db_gui{j}(1),sys.line(curve_nums).filename)
                    cell2strings(handles,db_gui{j});
                    break
                end
            end
            %%%%%%%%%%%%������������ߣ�����ʾlegend%%%%%%%%%%%
            if strcmp(sys.line(curve_nums).filename,sys.latest_line.filename)
                set(sys.line(curve_nums).handle,'linewidth',2)
                set(hdisp(i),'fontweight','bold')
                if strcmp(sys.language,'English')
                    sys.line(curve_nums).leg=legend(sys.line(curve_nums).handle,'Latest measure curve',2);          %�����߱�ǩ�浽disp�ṹ����
                else
                    sys.line(curve_nums).leg=legend(sys.line(curve_nums).handle,'��������',2);          %�����߱�ǩ�浽disp�ṹ����
                end
                sys.latest_line=sys.line(curve_nums);
            else
                set(hdisp(i),'fontweight','normal')
            end
            
            %%%%%%%%%%%%%%%%%%�������������ļ����Ƿ�Ϊ��%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%change the list disp context%%%%%%%%%
            set(handles.curve_files,'value',1);
            list_filenames(select_idx)=[];
            set(handles.curve_files,'string','');
            set(handles.curve_files,'string',list_filenames);
            sys.list_filenames=list_filenames;
            break
        end
        %%%%%%%%%%%%��ʾ���߳���6���򱨴�%%%%%%%%%%%
        if i==6
            %ERROR;
            h_info=load('languages.mat');
            info=h_info.info;
            if strcmp(sys.language,'English')
                message=info(3).over6;
            else
                strcmp(sys.language,'Chinese')
                message=info(2).over6;
            end
            myDialog('erro',message);
            return
        end
    end
    %%%%%%%%%%%%��ʾ���������Ϣ%%%%%%%%%%%
    if strcmp(sys.language,'English')
        title('RollMeter Test Curve')
        xlabel('Crown Length/mm')
        ylabel('Crown height/um')
    end
    if strcmp(sys.language,'Chinese')
        title('�����и߲�������')
        xlabel('���ӳ���/mm')
        ylabel('����и�/um')
    end
    if get(handles.open_auto_mapping,'value')
        struct_lines=sys.line;
        if ishandle(sys.theo_line.handle)
            struct_lines(end+1)=sys.theo_line;
        end
        valued_idx=get_value_handle_idx(struct_lines);
        
       
%         if strcmp(sys.language,'Chinese')
%             choice = MyQuestdlg('��ѡ���Զ�ƥ��ģʽ', ...
%              '�Զ�ƥ��', ...
%              '�Զ�','��x��','��y��','�Զ�');
%         else
%             choice = MyQuestdlg('Please choose the mapping model', ...
%              'Auto Mapping', ...
%              'Auto','Just x','Just y','Auto');       
%         end
%         shift_xy_mode=ones(1,2)
%         if strcmp(choice,'��x��')||strcmp(choice,'Just x')
%             shift_xy_mode(2)=0;
%         end
%         if strcmp(choice,'��y��')||strcmp(choice,'Just y')
%             shift_xy_mode(1)=0;
%         end
        
        
        
        struct_lines(valued_idx)=mapping_all(struct_lines(valued_idx),[1 1]);
        if ishandle(sys.theo_line.handle)
            sys.line=struct_lines(1:end-1);
        else
            sys.line=struct_lines;
        end
    end
    sys.active_line=sys.line(curve_nums);
    set(handles.axes1,'userdata',sys)
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function del_CreateFcn(hObject, eventdata, handles)
% hObject    handle to del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function disp1_Callback(hObject, eventdata, handles)
% hObject    handle to disp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp1 as text
%        str2double(get(hObject,'String')) returns contents of disp1 as a double


% --- Executes during object creation, after setting all properties.
function disp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp2_Callback(hObject, eventdata, handles)
% hObject    handle to disp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp2 as text
%        str2double(get(hObject,'String')) returns contents of disp2 as a double


% --- Executes during object creation, after setting all properties.
function disp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp3_Callback(hObject, eventdata, handles)
% hObject    handle to disp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp3 as text
%        str2double(get(hObject,'String')) returns contents of disp3 as a double


% --- Executes during object creation, after setting all properties.
function disp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in Delete.
% function Delete_Callback(hObject, eventdata, handles)
% % hObject    handle to Delete (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user date (see GUIDATA)
% h_line=findobj(handles.axes1,'type','line');
% curve_nums=size(h_line1);
% curve=handles.curve;
% delete(curve(curve_nums))


% --- Executes on button press in del1.
function del1_Callback(hObject, eventdata, handles)
% hObject    handle to del1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
del_Callback(hObject, eventdata, handles,1)


% --- Executes on button press in del2.
function del2_Callback(hObject, eventdata, handles)
% hObject    handle to del2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
del_Callback(hObject, eventdata, handles,2)


% --- Executes on button press in del3.
function del3_Callback(hObject, eventdata, handles)
% hObject    handle to del3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
del_Callback(hObject, eventdata, handles,3)



function rollcenter_Callback(hObject, eventdata, handles)
% hObject    handle to rollcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

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
% handles    structure with handles and user date (see GUIDATA)

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
% handles    structure with handles and user date (see GUIDATA)

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
% handles    structure with handles and user date (see GUIDATA)

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


% --- Executes on selection change in meastype.
function meastype_Callback(hObject, eventdata, handles)
% hObject    handle to meastype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns meastype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from meastype

value=get(handles.meastype,'value');
string=get(handles.meastype,'string');
if strcmp(string(value),'�и߹�')||strcmp(string(value),'Crowned')
    set(handles.meastype,'userdata','Crowned')
    set(handles.readprof,'backgroundcolor',[0.941 0.941 0.941])
else
    set(handles.meastype,'userdata','Cylindnic')
    set(handles.readprof,'backgroundcolor',[0.95 0.95 0.95])
end

% --- Executes during object creation, after setting all properties.
function meastype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meastype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)


% --- Executes on button press in readprof.
function readprof_Callback(hObject, eventdata, handles)
% hObject    handle to readprof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
i=0;
if strcmp(get(handles.readprof,'userdata'),'nodisplayed')%��־�Ѿ���ʾ����������
    stat=get(handles.meastype,'userdata');
    if strcmp(stat,'Crowned')
        %**********************dimeter or semidiameter mode************************%
        if strcmp(sys.language,'Chinese')
            choice = MyQuestdlg('��ѡ���������߱궨ģʽ', ...
                'Dessert Menu', ...
                'ֱ��','�뾶','ֱ��');
            % Handle response
        end
        if strcmp(choice,'�뾶')||strcmp(choice,'semidiameter')
            hline=findobj(handles.axes1,'type','line')
            new_line=reflash(hline,'semidiameter')
        end
        
        disp=get(handles.axes1,'userdata');
        theory_path=get(handles.curve_files,'userdata');
        theory_filename=[get(handles.rollnum,'string'),'_theory.txt'];
        theory_fullpath=fullfile(theory_path,theory_filename);
        %%%%%%%%%%%%%%%%%%��ȡ��������%%%%%%%%%%%%%%%%
        fid = fopen(theory_fullpath);
        C_data = textscan(fid, '%d %d', 'CollectOutput', 1);
        %                         set(handles.measstep,'string','NULL');
        %write the theory file name and change the disp color
        
        %%%%%%%%%%%%%%%%%%�������������ļ����Ƿ�Ϊ��%%%%%%%%%%%%%%%%
        if isempty(C_data{1})
            if strcmp(sys.language,'English')
                h=errordlg(['There is no data in this file. please open the file on the path of ',theory_fullpath,' then wirte the crown data.'],'Error');
            end
            if  strcmp(sys.language,'Chinese')
                h=errordlg(['�ļ��в�����������������,���',theory_fullpath,'��¼��ù��������и�����'],'����');
            end
            chgicon(h,'rollmeter.png')  %h����GUIͼ��
        else
            x=double(C_data{1}(:,1));
            y=double(C_data{1}(:,2));
            y=y-y(1);
            hdisp=handles.hdisp;
            Del(4)=handles.del4;
            Del(5)=handles.del5;
            Del(6)=handles.del6;
            for i=1:6
                if isempty(get(hdisp(i),'string'))
                    curve_nums=i;
                    if i>3            %if the disp curves are more than 3, than, show the hide control
                        Del(4)=handles.del4;
                        Del(5)=handles.del5;
                        Del(6)=handles.del6;
                        set(hdisp(curve_nums),'string',theory_filename,'ForegroundColor',disp.color(curve_nums),'visible','on');
                        set(Del(curve_nums),'visible','on');
                    end
                    disp.curve(curve_nums)=plot(x,y,'--','color',disp.color(curve_nums),'linewidth',2);
                    set(hdisp(curve_nums),'string',theory_filename,'ForegroundColor',disp.color(curve_nums));
                    set(handles.readprof,'userdata','displayed')%��־�Ѿ���ʾ����������
                    break
                end
            end
            
        end
        set(handles.axes1,'userdata',disp);
        guidata(hObject, handles);
    end
else
    if strcmp(sys.language,'English')
        message='The theoretical curve have displayed in the axes!';
    else
        strcmp(sys.language,'Chinese')
        message='����������������������ʾ��';
    end
    myDialog('mess',message);
end
%%%%%%%%%%%%��ʾ���߳���6���򱨴�%%%%%%%%%%%
if i==6
    %ERROR;
    h_info=load('languages.mat');
    info=h_info.info;
    if strcmp(sys.language,'English')
        message=info(3).over6;
    else
        strcmp(sys.language,'Chinese')
        message=info(2).over6;
    end
    myDialog('erro',message);
end



%%%%%%%%%%%%�Ƚ������ļ����¾�%%%%%%%%%%%
function [biger]=compare2file(file1,file2)
biger=1;
if ~isempty(strfind(file1,'theory_file'))  %����
    biger=0;
    return
end
if ~isempty(strfind(file2,'theory_file'))
    biger=1;
    return
end
if ~isempty(strfind(file1,'theory'))||~isempty(strfind(file1,'fit'))%����
    biger=0;
    return
end
if ~isempty(strfind(file2,'theory'))||~isempty(strfind(file2,'fit'))
    biger=1;
    return
end
compare=file1(end-16:end-4)<file2(end-16:end-4);%��������
for i=1:13
    if compare(i)==1
        biger=0;
        break
    end
end


% --- Executes on selection change in filenums.
function filenums_Callback(hObject, eventdata, handles)
% hObject    handle to filenums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filenums contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filenums
%
% openedfiles=handles.filenames;
% % openedfiles=get(handles.curve_files,'string');
% value=get(handles.filenums,'value');
% % if value~=1
% %     value=1;
% nums=size(openedfiles,1);
% for i=1:nums-1
%     for j=i+1:nums
%         if compare2file(openedfiles{i},openedfiles{j})
%               tmpfile=openedfiles{i};
%               openedfiles{i}=openedfiles{j};
%               openedfiles{j}=tmpfile;
%         end
%     end
% end
% set(handles.curve_files,'string','');
% set(handles.curve_files,'value',1);
% set(handles.curve_files,'string',openedfiles(1:value)');
% set(handles.filenums,'userdata',openedfiles(1));



% --- Executes during object creation, after setting all properties.
function filenums_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dir.
function dir_Callback(hObject, eventdata, handles)
% hObject    handle to dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dir contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dir
%��ջ滭���ߺ��ı���
sys=get(handles.axes1,'userdata');
% sys=sys_init(hObject, eventdata, handles);
hdisp=sys.hdisp;
delete(findobj(handles.axes1,'type','line'))
delete(findobj(gcf,'tag','legend'))
if ishandle(sys.theo_line_err_up_text_handle)
        delete(sys.theo_line_err_up_text_handle);
        delete(sys.theo_line_err_low_text_handle);
end
sys.line=init_struct_line();
sys.theo_line=init_struct_line();
sys.active_line=init_struct_line();
sys.theo_line_err_up=init_struct_line();
sys.theo_line_err_low=init_struct_line();
set(handles.none,'value',1)
for i=1:6
    if ~isempty(get(hdisp(i),'string'))
        %         disp=get(handles.axes1,'userdata');
        % %         if ishandle(disp.curve(i))
        % %             if disp.curve(i)
        %                 delete(disp.curve(i));  %ɾ������\
        %             end
        %         end
        %         delete(disp.curve(1));
        set(hdisp(i),'string','');   %�ı����ÿ�
    end
end
%�����ز���
db_rollname=cell(1,20);
cell2strings(handles,db_rollname);

% path=get(handles.dir,'userdata');  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
working_path=sys.working_path;

dir_idx=get(handles.dir,'value');
dir_list=get(handles.dir,'string');
sys.cur_dir_name=dir_list{dir_idx};
sys.cur_dir_path=fullfile(working_path,sys.cur_dir_name);
% fulpath=fullfile(path,dir_list{dir_idx});    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_info=dir(sys.cur_dir_path);   % ������Ҫ��Ŀ¼�Լ��ļ���չ���滻����ȡĳ��Ŀ¼��ָ�������ļ��б����ؽṹ���顣
% dirs=dir(fulpath);   % ������Ҫ��Ŀ¼�Լ��ļ���չ���滻����ȡĳ��Ŀ¼��ָ�������ļ��б����ؽṹ���顣

dircell=struct2cell(dir_info)' ;    % �ṹ��(struct)ת����Ԫ������(cell)��ת��һ�������ļ����������С�
% dircell=struct2cell(dirs)' ;    % �ṹ��(struct)ת����Ԫ������(cell)��ת��һ�������ļ����������С�
sys.filenames=dircell(3:end,1) ;  % ��һ�����ļ���

% theory_name=[dir_list{dir_idx},'_theory.txt'];
sys.theo_line.filename=[dir_list{dir_idx},'_theory_file.txt'];
% theory_fulpath=[fulpath,'\',theory_name]
% theory_fulpath=fullfile(fulpath,theory_name);
sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);

if ~exist(sys.theo_line.filepath,'file')    %����������ļ����򴴽�
    file_id=fopen(sys.theo_line.filepath,'a+')
    fclose(file_id)
    sys.filenames{end+1}=sys.theo_line.filename;
end

nums=size(sys.filenames,1);     %�ù��Ų�����ʷ��¼����
% sortnums=cell(nums,1);      %����ı��
% for i=1:nums
%     sortnums{i}=num2str(i);
% end
set(handles.curve_files,'value',1);%Ĭ��ѡ�й����ļ��еĵ�һ��
set(handles.curve_files,'string',sys.filenames);%����������д���Ӧ����listbox�У������ù��ŵ�·���浽listbox�ġ�userdata��������

for i=1:nums
    for j=i+1:nums
        if ~compare2file(sys.filenames{i},sys.filenames{j})
            tmpfile=sys.filenames{i};
            sys.filenames{i}=sys.filenames{j};
            sys.filenames{j}=tmpfile;
        end
    end
end
sys.latest_line.filename=sys.filenames(1);

set(handles.curve_files,'string','');
set(handles.curve_files,'value',1);
sys.list_filenames=sys.filenames(1:nums-1);
set(handles.curve_files,'string',sys.list_filenames);   %-1��ʾ���һ���������ļ�

% set(handles.disp1,'userdata',sys.filenames(1));%�����������

set(handles.axes1,'userdata',sys)
add_Callback(hObject, eventdata, handles);   %Ĭ�ϻ�����������
sys=get(handles.axes1,'userdata');
set(handles.axes1,'userdata',sys);     %��disp�ṹ��浽axes1��userdata������
% hline=findobj(handles.axes1,'type','line');
% set(hline,'linewidth',2)
% set(hdisp(1),'fontweight','bold')
% disp=get(handles.axes1,'userdata');
% if strcmp(sys.language,'English')
%     disp.leg=legend('Latest measure curve',2);          %�����߱�ǩ�浽disp�ṹ����
% else
%     disp.leg=legend('��������',2);          %�����߱�ǩ�浽disp�ṹ����
% end
%
%
% set(handles.axes1,'userdata',disp);     %��disp�ṹ��浽axes1��userdata������
% guidata(hObject, handles);
% legend boxoff

% set(handles.filenums,'string',sortnums(1:end-1));%�����д�����������ؼ���,-1��Ϊ���������Ѿ���ʾ���Ѿ����ڹ��ŵ�listbox��
% set(handles.filenums,'value',nums);%Ĭ�Ͻ��������в�����¼���µ�������

% --- Executes during object creation, after setting all properties.
function dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in para1.
function para1_Callback(hObject, eventdata, handles)
% hObject    handle to para1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
i=0;
if strcmp(get(handles.para1,'userdata'),'nodisplayed')%��־�Ѿ���ʾ����������
    stat=get(handles.meastype,'userdata');
    if strcmp(stat,'Crowned')
        langu=sys.language;
        if strcmp(langu,'English')
            prompt={'Stress Size(F):',...
                'Center Distance:',...
                'Crown Diameter��',...
                'Crown Thickness',...
                'Crown Elastic Modulus',...
                'Correction Factor'};
            name='Please enter the parameters of the crown theory model';
        end
        if strcmp(langu,'Chinese')
            
            prompt={'��������ѹ����С(KN/m):',...
                '���泤(mm):',...
                '�����⾶(mm):',...
                '�����ھ�(mm)��',...
                '���ǵ���ģ��(KN/m^2):',...
                '��������������и���ʼ�ܵľ���(cm)'};
            
            name='��������������иߵ�ģ�Ͳ��� ';
        end
        h_new_curve=findobj(findobj(handles.axes1,'type','line'),'color',get(handles.disp1,'foregroundcolor'));
        x=get(h_new_curve,'xdata');
        numlines=1;
        defaultanswer={'300',num2str(max(x)),'1500','1360','200000000','54'};
        options.Resize='on';
        options.WindowStyle='normal';
        options.Interpreter='tex';
        answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
        if ~isempty(answer)
            crown_type=25; %sin(25)����Ϊ�и���ʼ��,180-crown_type��Ϊ�и��յ�
            L=str2double(answer{1}); %��ѹ��KN/m
            % F=1000:20:4000
            F=str2double(answer{2});  %���泤mm
            ODs=str2double(answer{3}); %�����⾶mm
            IDs=str2double(answer{4}); %�����ھ�mm
            E=str2double(answer{5}); %���ǵ���ģ��  KN/m
            H=str2double(answer{6});   %��������������и���ʼ�ܵľ���cm
            % C=0.531*L*power(F,4).*(1+4.8*(H./F)+2*power(ODs./F,2))/(E*(power(ODs,4)-power(IDs,4)))
            C=1000000*0.531*L*power(F,4)*(1+4.8*(H/F)+2*power(ODs/F,2))/(E*(power(ODs,4)-power(IDs,4)));%*1000=m���um
            C=C/(1-sin(pi*crown_type/180));
            T=2*F/(180-2*crown_type)*180;  %�����ź�����
            % x=T*crown_type/360:20:T*(180-crown_type)/360;
            st=get(handles.measstep,'string');
            x=0:str2double(st):F;
            y=C*sin(2*pi/T*(x+T*crown_type/360))-C*sin(2*pi*crown_type/360);
            
            hdisp=handles.hdisp;
            disp=get(handles.axes1,'userdata');
            filename=[get(handles.rollnum,'string'),'_theory_crown'];
            Del(4)=handles.del4;
            Del(5)=handles.del5;
            Del(6)=handles.del6;
            for i=1:6
                if isempty(get(hdisp(i),'string'))
                    curve_nums=i;
                    if i>3            %if the disp curves are more than 3, than, show the hide control
                        
                        set(hdisp(curve_nums),'string',filename,'ForegroundColor',disp.color(curve_nums),'visible','on');
                        set(Del(curve_nums),'visible','on');
                    end
                    disp.curve(curve_nums)=plot(x,y,'--','color',disp.color(curve_nums),'linewidth',1.5);
                    set(hdisp(curve_nums),'string',filename,'ForegroundColor',disp.color(curve_nums),'fontweight','bold');
                    set(handles.para1,'userdata','displayed')%��־�Ѿ���ʾ����������
                    break
                end
            end
            handles.hdisp=hdisp;
            set(handles.axes1,'userdata',disp);
            guidata(hObject, handles);
        end
    else
        if strcmp(get(handles.disp1,'string'),'')
        else
            disp=get(handles.axes1,'userdata');
            h_new_curve=findobj(findobj(handles.axes1,'type','line'),'color',get(handles.disp1,'foregroundcolor'));
            x=get(h_new_curve,'xdata');
            y=get(h_new_curve,'ydata');
            %         answer=MyInputdlg(prompt,name,numlines,{num2str(max(x))});
            y=mean(y)*ones(1,size(x,2));
            Del(4)=handles.del4;
            Del(5)=handles.del5;
            Del(6)=handles.del6;
            filename=[get(handles.rollnum,'string'),'_theory_crown'];
            hdisp=handles.hdisp;
            for i=1:6
                if isempty(get(hdisp(i),'string'))
                    curve_nums=i;
                    if i>3            %if the disp curves are more than 3, than, show the hide control
                        
                        set(hdisp(curve_nums),'string',filename,'ForegroundColor',disp.color(curve_nums),'visible','on');
                        set(Del(curve_nums),'visible','on');
                    end
                    disp.curve(curve_nums)=plot(x,y,'--','color',disp.color(curve_nums),'linewidth',2);
                    set(hdisp(curve_nums),'string',filename,'ForegroundColor',disp.color(curve_nums));
                    set(handles.para1,'userdata','displayed')%��־�Ѿ���ʾ����������
                    break
                end
            end
            handles.hdisp=hdisp;
            set(handles.axes1,'userdata',disp);
            guidata(hObject, handles);
        end
    end
    
else
    if strcmp(sys.language,'English')
        message='The theoretical curve have displayed in the axes!';
    else
        strcmp(sys.language,'Chinese')
        message='����������������������ʾ��';
    end
    myDialog('mess',message);
end
%%%%%%%%%%%%��ʾ���߳���6���򱨴�%%%%%%%%%%%
if i==6
    %ERROR;
    h_info=load('languages.mat');
    info=h_info.info;
    if strcmp(sys.language,'English')
        message=info(3).over6;
    else
        strcmp(sys.language,'Chinese')
        message=info(2).over6;
    end
    myDialog('erro',message);
end


% --- Executes on button press in fullscreen.
function fullscreen_Callback(hObject, eventdata, handles)
% hObject    handle to fullscreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% sys=get(handles.axes1,'userdata');
% N=size(sys.line,2);
% Nline=0;     %�о��������
% sys.line_disp_idx=0;  %û��ɾ�����������±�
% if isfield(sys,'line_disp')
%     sys=rmfield(sys,'line_disp');%�����ʾ���߾�������¼��������ʾ�����߾��
% end
% for i=1:N
%     if ishandle(sys.line(i).handle)
%         Nline=Nline+1;
%         sys.line_disp_idx(Nline)=i;
%         sys.line_disp(Nline)=sys.line(i);
%     end
% end
% set(handles.axes1,'userdata',sys)
sys=get(handles.axes1,'userdata');
h_line=findobj(handles.axes1,'type','line');
curve_nums=size(h_line,1);
h_info=load('languages.mat');
info=h_info.info;


if curve_nums>=1&&curve_nums<=6
    RM_handles=guihandles(gcf);
    setappdata(0,'RollMeter',RM_handles)
    FullDisp2;
else
    if curve_nums==0
        
        if strcmp(sys.language,'English')
            message=info(3).noLine;
        else
            strcmp(sys.language,'Chinese')
            message=info(2).noLine;
        end
        myDialog('warn',message);
    end
    
    if curve_nums>6
        if strcmp(sys.language,'English')
            message=info(3).over6;
        else
            strcmp(sys.language,'Chinese')
            message=info(2).over6;
        end
        myDialog('erro',message);
    end
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


% --- Executes on button press in del4.
function del4_Callback(hObject, eventdata, handles)
% hObject    handle to del4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_Callback(hObject, eventdata, handles,4)

function disp5_Callback(hObject, eventdata, handles)
% hObject    handle to disp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp5 as text
%        str2double(get(hObject,'String')) returns contents of disp5 as a double


% --- Executes during object creation, after setting all properties.
function disp5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in del5.
function del5_Callback(hObject, eventdata, handles)
% hObject    handle to del5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_Callback(hObject, eventdata, handles,5)


function disp6_Callback(hObject, eventdata, handles)
% hObject    handle to disp6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp6 as text
%        str2double(get(hObject,'String')) returns contents of disp6 as a double


% --- Executes during object creation, after setting all properties.
function disp6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in del6.
function del6_Callback(hObject, eventdata, handles)
% hObject    handle to del6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_Callback(hObject, eventdata, handles,6)


function disp4_Callback(hObject, eventdata, handles)
% hObject    handle to disp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp4 as text
%        str2double(get(hObject,'String')) returns contents of disp4 as a double


% --- Executes during object creation, after setting all properties.
function disp4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kdmeas_Callback(hObject, eventdata, handles)
% hObject    handle to kdmeas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kdmeas as text
%        str2double(get(hObject,'String')) returns contents of kdmeas as a double


% --------------------------------------------------------------------
function chinese_Callback(hObject, eventdata, handles)
% hObject    handle to chinese (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% fid = fopen('languages.txt');
% C_head= textscan(fid, '%s %s %s ','CollectOutput', 1, 'delimiter', '	')
% fclose(fid);
% heading=C_head{1}(:,1)';
% %                 rowHeadings={'name','rolltype','long','dist','suppliers','shift'};
% info = cell2struct(C_head{1}, heading, 1);
sys=get(handles.axes1,'userdata');
sys.language='Chinese';
set(get(handles.axes1,'title'),'string','�����и߲�������')
set(get(handles.axes1,'ylabel'),'string','����и�/um')
set(get(handles.axes1,'xlabel'),'string','���ӳ���/mm')
if ishandle(sys.latest_line.handle)
    sys.latest_line.leg=legend(sys.latest_line.handle,'��������',2);          %���µ����ı�ǩ
end
language_Callback(hObject, eventdata, handles,sys.language);
set(handles.axes1,'userdata',sys)


% --------------------------------------------------------------------
function english_Callback(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
sys.language='English';

if ishandle(sys.latest_line.handle)
    sys.leg=legend(sys.latest_line.handle,'Latest measure curve',2);          %�����߱�ǩ�浽disp�ṹ����
end
set(get(handles.axes1,'title'),'string','RollMeter Test Curve')
set(get(handles.axes1,'xlabel'),'string','Crown Length/mm')
set(get(handles.axes1,'ylabel'),'string','Crown Height/um')
set(handles.axes1,'userdata',sys)
language_Callback(hObject, eventdata, handles,sys.language);


% --------------------------------------------------------------------
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and userrollmeter=database('rollmeter','root','willtech','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/rollmeter'); %����rollmeter���ݿ�
set(handles.remark,'string',date);  %��������
sys=get(handles.axes1,'userdata');
%             rollmeter=database('rollmeter','root','willtech','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/rollmeter'); %����rollmeter���ݿ�
%             ping(rollmeter)
%             %�����ݿ��в����뵱ǰ����һ���ļ�¼
%             curs=exec(rollmeter,['SELECT FileName FROM RollNums WHERE FileName=''',disp.active_file,'''']);
%             curs=fetch(curs);
%             db_rollnames=curs.data;
%             %���û�ҵ�������������ݿ�����Ӹù���
%             if strcmp(db_rollnames{1},'No Data')
%                 %д���ݵ����ݿ���
%                 [list,expdata]=strings2cell(handles,disp.active_file);%��ȡ�ֶκ�gui string����
%                 fastinsert(rollmeter,'RollNums',list,expdata);
%             end
%             close(rollmeter);
if ~exist('db_gui.mat','file')    %����������ļ����򴴽�
    db_gui{1}='Start'
    save('db_gui.mat','db_gui')
end
db_gui=load('db_gui.mat');
db_gui=db_gui.db_gui;
N=size(db_gui,2);  %Ԫ������
j=1;
for k=1:N
    if ~strcmp(db_gui{k}(1),sys.active_line.filename)
        j=j+1;
        if j==N+1
            [list,db_gui{end+1}]=strings2cell(handles,sys.active_line.filename);
            save('db_gui.mat','db_gui');
        end
    else
        [list,db_gui{k}]=strings2cell(handles,sys.active_line.filename);
        save('db_gui.mat','db_gui');
        break
    end
end
if strcmp(sys.language,'English')
    h = waitbar(0,'Please wait...');
end
if strcmp(sys.language,'Chinese')
    h=waitbar(0,'���������У����Ժ�...');
end
chgicon(h,'rollmeter.png');
steps = 1000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h)

%��gui���ݴ浽���ݿ���
function [list,expdata]=strings2cell(handles,filename)
expdata=cell(1,19);
expdata{1}=filename;
expdata{2}=get(handles.rollnum,'string');
expdata{3}=get(handles.customer,'string');
expdata{4}=get(handles.ordernum,'string');
expdata{5}=get(handles.cover,'string');
expdata{6}=get(handles.rough,'string');
expdata{7}=get(handles.hard,'string');
expdata{8}=get(handles.rolltype,'string');
expdata{9}=get(handles.suppliers,'string');
expdata{10}=get(handles.inspector,'string');
expdata{11}=get(handles.resp,'string');
expdata{12}=get(handles.kdmeas,'string');
expdata{13}=get(handles.date,'string');
expdata{14}=get(handles.time,'string');
expdata{15}=get(handles.rollcenter,'string');
expdata{16}=get(handles.rolllength,'string');
expdata{17}=get(handles.measlength,'string');
expdata{18}=get(handles.measstep,'string');
expdata{19}=get(handles.remark,'string');
list={
    'FileName','RollNum','Customer','OrderNum','Cover','Roughness','Hardness','RollType','Supplier','Inspector',...
    'Responsible','KOMeas','Data','Time','CrownDia','CrownLength','MeasLength','MeasStep','RdTime'
    };
%�������е��������¸�ֵ��Gui������
function cell2strings(handles,db_rollname)
i=1;%i=0,ʹ�����ݿⷽ����i=1��ʹ��mat����
% set(handles.rollnum,'string',db_rollname{3-i});
set(handles.customer,'string',db_rollname{4-i});
set(handles.ordernum,'string',db_rollname{5-i});
% set(handles.cover,'string',db_rollname{6-i});
set(handles.rough,'string',db_rollname{7-i});
set(handles.hard,'string',db_rollname{8-i});
set(handles.rolltype,'string',db_rollname{9-i});
set(handles.suppliers,'string',db_rollname{10-i});
set(handles.inspector,'string',db_rollname{11-i});
set(handles.resp,'string',db_rollname{12-i});
% set(handles.kdmeas,'string',db_rollname{13-i});
% set(handles.date,'string',db_rollname{14-i});
% set(handles.time,'string',db_rollname{15-i});
set(handles.rollcenter,'string',db_rollname{16-i});
% set(handles.rolllength,'string',db_rollname{17-i});
% set(handles.measlength,'string',db_rollname{18-i});
% set(handles.measstep,'string',db_rollname{19-i});
set(handles.remark,'string',db_rollname{20-i});


% --------------------------------------------------------------------
function work_path_Callback(hObject, eventdata, handles)
% hObject    handle to work_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sys=get(handles.axes1,'userdata')
path = uigetdir('c:\Measure','��ѡ���ļ���Ϊ��Measure���Ĳ��������ļ���');
sys.working_path=path;
if path
    if strfind(path,'Measure')
        dirs=dir(path);   % ������Ҫ��Ŀ¼�Լ��ļ���չ���滻����ȡĳ��Ŀ¼��ָ�������ļ��б����ؽṹ���顣
        dircell=struct2cell(dirs)' ;    % �ṹ��(struct)ת����Ԫ������(cell)��ת��һ�������ļ����������С�
        dirnames=dircell(3:end,1) ;  % ��һ�����ļ���
        sys.dirnames=dirnames;
        db_gui=cell(1,1);
        set(handles.dir,'string',dirnames)%���ļ����б�����ʾ
        set(handles.axes1,'userdata',sys)
        set(handles.dir,'value',1)
        dir_Callback(hObject, eventdata, handles)
    else
        h_info=load('languages.mat');
        info=h_info.info;
        if strcmp(sys.language,'English')
            message=info(3).wrongPath;
        else
            strcmp(sys.language,'Chinese')
            message=info(2).wrongPath;
        end
        myDialog('warn',message);
        %         if strcmp(sys.language,'English')
        %             h=warndlg('The working path is wrong,pleasure choose a  ''Measure''folder as working path. ','Warning!')
        %         end
        %         if strcmp(sys.language,'Chinese')
        %             h=warndlg('����·������������ѡ��Measure�ļ�����Ϊ����Ŀ¼','���棡')
        %         end
        %         chgicon(h,'rollmeter.png')  %h����GUIͼ��;
    end
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function diameter_Callback(hObject, eventdata, handles)
% hObject    handle to diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.calibration_mode ,'user','diameter')

% --------------------------------------------------------------------
function semidiameter_Callback(hObject, eventdata, handles)
% hObject    handle to semidiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.calibration_mode ,'user','semidiameter')

function del_Callback(hObject, eventdata, handles,line_num)
% hObject    handle to del1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user date (see GUIDATA)
sys=get(handles.axes1,'userdata');
% N=size(sys.line,2); %��������
% Nline=0;     %�������������е�������Ŀ
% sys.cur_line_idx=0
% for i=1:N
%     if ishandle(sys.line(i).handle)
%         Nline=Nline+1;
%         sys.cur_line_idx(Nline)=i;
%     end
% end

hdisp=sys.hdisp;
del_for_sure=1;
if isempty(get(hdisp(line_num),'string'))
    if strcmp(sys.language,'English')
        message='Invalid or deleted object.'
    end
    if strcmp(sys.language,'Chinese')
        message='����Ϊ�գ��޷�ɾ��.'
    end
    myDialog('erro',message);
else
    if strcmp(get(hdisp(line_num),'string'),sys.latest_line.filename)  %�ж��Ƿ�Ϊ��������
        if strcmp(sys.language,'English')
            choice = MyQuestdlg('This curve is the latest tested curve, please be sure you really want to delete it��', ...
                'Dessert Menu', ...
                'Yes','No','No');
        end
        if strcmp(sys.language,'Chinese')
            choice = MyQuestdlg('�����������²�����¼��ȷ��Ҫɾ����', ...
                'Dessert Menu', ...
                'ȷ��','ȡ��','ȡ��');
            % Handle response
        end
        if strcmp(choice,'ȡ��')||strcmp(choice,'No')
            del_for_sure=0;
        end
    else
        
    end
    if del_for_sure
        filename=sys.line(line_num).filename;
        sys.list_filenames(end+1)={filename};
        set(handles.curve_files,'string',sys.list_filenames);
        if strcmp(get(hdisp(line_num),'string'),sys.latest_line.filename)
            delete(sys.latest_line.leg);%ɾ���������ߵ�legend
        end
        delete(sys.line(line_num).handle);
        
        %             sys.line(line_num)=[];
        %         set(sys.line(line_num).leg,'visible','off')
        %         set(sys.line(line_num).handle,'visible','off')
        
        %         while(line_num<=5&&~isempty(get(hdisp(line_num+1),'string')))%�������һ�Ϊ�գ��ļ�����ʾ��ǰ��
        %                 set(hdisp(line_num),'string',get(hdisp(line_num+1),'string'),'Foregroundcolor',sys.color(line_num+1,:));  %�����ı���ʾλ�ü���ɫ
        % %                 set(sys.line(line_num).handle,'color',sys.color(line_num,:))%����������ɫ
        %                 line_num=line_num+1;
        %         end
        set(hdisp(line_num),'string','')
        
        if strcmp(sys.active_line.filename,filename)
            valued_idx=get_value_handle_idx(sys.line)
            if size(valued_idx,2)>=1                       %ɾ��������ͨ����
                sys.active_line=sys.line(valued_idx(end));
            else
                if ishandle(sys.theo_line.handle)             %ɾ����û����ͨ���ߵ�����������
                    sys.active_line=sys.theo_line;
                else
                    sys.active_line=init_struct_line();         %ɾ����û����ͨ����Ҳû����������
                end
            end
            
        end
        %         sys.line(line_num)='';%�����Ӧ�ṹline�����г�Ա %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end
set(handles.axes1,'userdata',sys)
guidata(hObject, handles);


% --- Executes when selected object is changed in theo_profile.
function theo_profile_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in theo_profile
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

choosed_profile=get(eventdata.NewValue,'Tag');
sys=get(handles.axes1,'userdata');
if  ishandle(sys.theo_line.handle)
    delete(sys.theo_line.handle);
    if ishandle(sys.theo_line_err_up.handle)
        delete(sys.theo_line_err_up.handle);
        delete(sys.theo_line_err_low.handle);
        delete(sys.theo_line_err_up_text_handle);
        delete(sys.theo_line_err_low_text_handle);
    end
end
pause(0.1)
switch choosed_profile
    case 'none'
        sys.theo_line.filename='';%����Ϊ��˵��û����ʾ��������
        set(handles.axes1,'userdata',sys);
    case 'cylindic'
        line_fit(hObject, eventdata, handles)
    case 'cos'
        cos_70(hObject, eventdata, handles)
    case 'formula'
        add_from_formula(hObject, eventdata, handles)
    case 'file'
        read_from_file(hObject, eventdata, handles)
    case 'trapezium'
        trapezium(hObject, eventdata, handles)
    case 'arc'
        arc(hObject, eventdata, handles)
end

%************************read from file**************************%
function read_from_file(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
%**********************dimeter or semidiameter mode************************%
% if strcmp(sys.language,'Chinese')
%     choice = MyQuestdlg('��ѡ���������߱궨ģʽ', ...
%         'Dessert Menu', ...
%         'ֱ��','�뾶','ֱ��');
% else
%     choice = MyQuestdlg('Please choose the calibration model of the theoritical profile', ...
%         'Dessert Menu', ...
%         'Diameter','Semidiameter','Diameter');
% end
sys.theo_line.filename=[sys.cur_dir_name,'_theory_file_creat.txt'];%Ŀ���ļ���
sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);

orig_file_path=[sys.cur_dir_name,'_theory_file.txt'];%Դ�ļ���
orig_file_path=fullfile(sys.cur_dir_path,orig_file_path);
%%%%%%%%%%%%%%%%%%��ȡ��������%%%%%%%%%%%%%%%%
fid = fopen(orig_file_path);
C_data = textscan(fid, '%d %d', 'CollectOutput', 1);

%%%%%%%%%%%%%%%%%%�������������ļ����Ƿ�Ϊ��%%%%%%%%%%%%%%%%
if isempty(C_data{1})
    
    if strcmp(sys.language,'English')
        message=['There is no data in this file. please open the file on the path of ',sys.theo_line.filepath,' then wirte the crown data.'];
    end
    if  strcmp(sys.language,'Chinese')
        message=['�ļ��в�����������������,���',sys.theo_line.filepath,'��¼��ù��������и�����'];
    end
    myDialog('erro',message)
else
    x=double(C_data{1}(:,1));
    y=double(C_data{1}(:,2));
    L=str2double(get(handles.rolllength,'string'))
    filename='theory_file_creat.txt';
    creat_theo_line(handles,sys,L,x,y,filename);
end

%************************add from formula**************************%
function add_from_formula(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
if strcmp(sys.language,'English')
    prompt={'Stress Size(F):',...
        'Center Distance:',...
        'Crown Diameter��',...
        'Crown Thickness',...
        'Crown Elastic Modulus',...
        'Correction Factor'};
    name='Please enter the parameters of the crown theory model';
end
if strcmp(sys.language,'Chinese')
    
    prompt={'��������ѹ����С(KN/m):',...
        '���泤(mm):',...
        '�����⾶(mm):',...
        '�����ھ�(mm)��',...
        '���ǵ���ģ��(KN/m^2):',...
        '��������������и���ʼ�ܵľ���(cm)'};
    
    name='��������������иߵ�ģ�Ͳ��� ';
end

length=sys.active_line.xlim(2);
numlines=1;
defaultanswer={'300',num2str(length),'1500','1360','200000000','54'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
if ~isempty(answer)
    crown_type=25; %sin(25)����Ϊ�и���ʼ��,180-crown_type��Ϊ�и��յ�
    L=str2double(answer{1}); %��ѹ��KN/m
    % F=1000:20:4000
    F=str2double(answer{2});  %���泤mm
    ODs=str2double(answer{3}); %�����⾶mm
    IDs=str2double(answer{4}); %�����ھ�mm
    E=str2double(answer{5}); %���ǵ���ģ��  KN/m
    H=str2double(answer{6});   %��������������и���ʼ�ܵľ���cm
    % C=0.531*L*power(F,4).*(1+4.8*(H./F)+2*power(ODs./F,2))/(E*(power(ODs,4)-power(IDs,4)))
    C=1000000*0.531*L*power(F,4)*(1+4.8*(H/F)+2*power(ODs/F,2))/(E*(power(ODs,4)-power(IDs,4)));%*1000=m���um
    C=C/(1-sin(pi*crown_type/180));
    T=2*F/(180-2*crown_type)*180;  %�����ź�����
    % x=T*crown_type/360:20:T*(180-crown_type)/360;
    st=get(handles.measstep,'string');
    x=0:str2double(st):F;
    y=C*sin(2*pi/T*(x+T*crown_type/360))-C*sin(2*pi*crown_type/360);
    y=round(y);
    filename='theory_formula.txt';
    creat_theo_line(handles,sys,F,x,y,filename);
end

%************************line_fit**************************%
function line_fit(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');

active_hline=sys.active_line.handle;
L=get(handles.rolllength,'string');
%         x=get(active_hline,'xdata');
%         y=get(active_hline,'ydata');

if strcmp(sys.language,'Chinese')
    choice = MyQuestdlg('��ѡ��������Ϸ�ʽ', ...
        'Dessert Menu', ...
        '����ʽ','cos�Ƕ�','����ʽ');
else
    choice = MyQuestdlg('Please choose the fit measured method', ...
        'Dessert Menu', ...
        'polyfit','cosfit','polyfit');
end
if isempty(choice)
    return
end
if strcmp(choice,'����ʽ')||strcmp(choice,'polyfit')
    if strcmp(sys.language,'English')
        prompt={'fit length(mm):'};
        name='Please enter the fitness parameters';
    end
    if strcmp(sys.language,'Chinese')
        
        prompt={'��ϳ���(mm):'};
        
        name='��������ϲ��� ';
    end
    numlines=1;
    
    defaultanswer={L};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
    if ~isempty(answer)
        L=str2double(answer{1});
        left=mod(L,20);
        x= linspace(left/2,L-left/2,21);
    else
        return
        
    end
    
    y=poly_fit(active_hline,x);
    %     set(fit_hline,'visible','on')
    filename=[sys.active_line.filename(end-14:end-4),'_poly_fit.txt'];
end

if strcmp(choice,'cos�Ƕ�')||strcmp(choice,'cosfit')
    if strcmp(sys.language,'English')
        prompt={'cos angle:'...
            'fit length(mm):'};
        name='Please enter the cos angle';
    end
    if strcmp(sys.language,'Chinese')
        
        prompt={'���ҽǶ�:'...
            '��ϳ���(mm):'};
        
        name='���������ģ�Ͳ��� ';
    end
    numlines=1;
    defaultanswer={'70',L};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
    if ~isempty(answer)
        cosAngle=str2double(answer{1});  %���ҽǶ�
        L=str2double(answer{2});
        left=mod(L,20);
        x= linspace(left/2,L-left/2,21);
        cosAngle=90-cosAngle;
        y=cosfit(active_hline,cosAngle,x);
        filename=[sys.active_line.filename(end-14:end-4),'_cos_fit.txt'];
    else
        return
    end
end

%
%         if strcmp(sys.language,'English')
%             message=['The crown value calculated based on the curve is ' ,num2str(max(y)),'um'];
%         end
%         if strcmp(sys.language,'Chinese')
%             message=['��ϳ������и�ֵΪ ',num2str(max(y)),'um'];
%         end
%         h=myDialog('mess',message);
%         pause(2)
%         if ishandle(h)
%             close(h)
%         end
pause(0.1)        %����ʱ���öԻ�����ʧ
creat_theo_line(handles,sys,L,x,y,filename)
%
% sys.theo_line.xlim=[x(1) x(end)];
% sys.theo_line.ylim=[fit_line.min_pt(2),fit_line.max_pt(2)];
% sys.theo_line.xdata=fit_line.fit_x;
% sys.theo_line.ydata=fit_line.fit_y;
% sys.theo_line.nums=max(size(fit_line.fit_x));
% sys.theo_line.length=L;
%
% sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);
% sys.theo_line.handle=plot(handles.axes1,fit_line.fit_x,fit_line.fit_y,'--','color','k','linewidth',2.5);
% [sys.theo_line.max_pt,sys.theo_line.min_pt]=line_max_min(sys.theo_line.handle);
% set(handles.axes1,'userdata',sys)

%************************cos 70**************************%
function cos_70(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
langu=sys.language;
if strcmp(langu,'English')
    prompt={'Crown Length:',...
        'Max of Crown Hight:',...
        'Cos Angle:'};
    name='Please enter the parameters of the crown theory model';
end
if strcmp(langu,'Chinese')
    
    prompt={'���泤(mm):',...
        '��������и�(mm):',...
        '���ҽǶ�(mm):'};
    name='��������������иߵ�ģ�Ͳ��� ';
end
x=str2double(get(handles.rolllength,'string'));
y=sys.line(1).ylim(2)/1000;%��λ��umת��mm
numlines=1;
defaultanswer={num2str(x),num2str(y),'70','0'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
if ~isempty(answer)
    
    L=str2double(answer{1});
    h=str2double(answer{2});
    theta=str2double(answer{3});
    
    if theta==90
        if strcmp(sys.language,'English')
            message='the cos angle can not be 90 degree!';
        else
            strcmp(sys.language,'Chinese')
            message='���ҽǲ���Ϊ90�ȣ�';
        end
        myDialog('mess',message);
        return
    end
    
    %     theta=90-theta;
    T=L*180/theta;
    Amp=h/(1-cos(theta*pi/180))*1000;
    left=mod(L,20);
    x=linspace(left/2,L-left/2,21);
    
    y=Amp*cos(2*pi/T*(x-theta/360*T))-Amp*cos(theta/180*pi);
    y=round(y);
    filename=['theory_cos_',answer{3},'_',answer{1},'.txt'];
    pause(0.1)        %����ʱ���öԻ�����ʧ
    creat_theo_line(handles,sys,L,x,y,filename)
end

%************************trapezium**************************%
function trapezium(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
langu=sys.language;
if strcmp(langu,'English')
    prompt={'Crown Length:',...
        'Middle Length:'...
        'Max of Crown Hight:'};
    name='Please enter the parameters of the crown theory model';
end
if strcmp(langu,'Chinese')
    
    prompt={'���泤(mm):',...
        '�м䳤��(mm):'...
        '�и߶�(mm):'};
    name='��������������иߵ�ģ�Ͳ��� ';
end
x=str2double(get(handles.rolllength,'string'));

numlines=1;
defaultanswer={num2str(x),num2str(x/2),'1'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
if ~isempty(answer)
    
    L=str2double(answer{1});
    ML=str2double(answer{2});
    h=str2double(answer{3})*1000;
    if ML<0
        if strcmp(sys.language,'English')
            message='middle length must be biger then 0!';
        else
            strcmp(sys.language,'Chinese')
            message='�м䳤�Ȳ���С��0';
        end
        myDialog('mess',message);
        return
    end
    
    left=mod(L,20);
    x=linspace(left/2,L-left/2,21);
    N=size(x,2);
    bk(1)=(L-ML)/2;
    bk(2)=(L+ML)/2;
    idx=find(x>bk(1)&x<bk(2));
    y(1:idx(1)-1)=x(1:idx(1)-1)*h/bk(1)*2;
    y(idx(1):idx(end))=2*h;
    y(idx(end)+1:N)=(L-x(idx(end)+1:end)) *h / bk(1)*2;
    y=round(y);
    filename=['theory_trapezium_',answer{1},'_',answer{2},'_',answer{3},'.txt'];
    pause(0.1)        %����ʱ���öԻ�����ʧ
    creat_theo_line(handles,sys,L,x,y,filename)
end

%************************arc**************************%
function arc(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
langu=sys.language;
if strcmp(langu,'English')
    prompt={'Crown Length:',...
        'Max of Crown Hight:'};
    name='Please enter the parameters of the crown theory model';
end
if strcmp(langu,'Chinese')
    
    prompt={'���泤(mm):',...
        '�и߶�(mm):'};
    name='��������������иߵ�ģ�Ͳ��� ';
end
x=str2double(get(handles.rolllength,'string'));

numlines=1;
defaultanswer={num2str(x),'1'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=MyInputdlg(prompt,name,numlines,defaultanswer,options);
if ~isempty(answer)
    
    L=str2double(answer{1});
    h=str2double(answer{2});
    
    left=mod(L,20);
    x=linspace(left/2,L-left/2,21);
    
    dist=abs(L/2-x);
    R=(L*L/4+h*h)/h/2;
    height=sqrt(R*R-dist.*dist);
    y=h-(R-height);
    y=round(1000*y);
    filename=['theory_arc_',answer{1},'_',answer{2},'.txt'];
    pause(0.1)        %����ʱ���öԻ�����ʧ
    creat_theo_line(handles,sys,L,x,y,filename);
end



% --- Executes on selection change in system_paths.
function system_paths_Callback(hObject, eventdata, handles)
% hObject    handle to system_paths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns system_paths contents as cell array
%        contents{get(hObject,'Value')} returns selected item from system_paths
sys=get(handles.axes1,'userdata');
value=get(handles.system_paths,'value');
string=get(handles.system_paths,'string');
if ~strcmp(sys.working_path,string{value})
    sys.working_path=string{value};
    set(handles.dir,'value',1)
end
set(handles.axes1,'userdata',sys);
open_working_path(hObject, eventdata, handles, sys.working_path);
sys=get(handles.axes1,'userdata');
set(handles.axes1,'userdata',sys);




% --- Executes during object creation, after setting all properties.
function system_paths_CreateFcn(hObject, eventdata, handles)
% hObject    handle to system_paths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%ϵͳ������ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=sys_init(hObject, eventdata, handles)


sys.line=init_struct_line();
sys.line.meas_direction='right';

sys.theo_line=sys.line;
sys.active_line=sys.line;
sys.latest_line=sys.line;

sys.system_paths='';
% sys.working_path='c:\Measure\';
sys.dirnames='';
sys.filenames='';
sys.list_filenames='';
sys.cur_dir_name='';
sys.cur_dir_path='';
sys.color=linspecer(6);
sys.language='Chinese';
sys.theo_line_err_up_text_handle=[];
sys.theo_line_err_low_text_handle=[];

% ���ת��=0;
hdisp(1)=handles.disp1;
hdisp(2)=handles.disp2;
hdisp(3)=handles.disp3;
hdisp(4)=handles.disp4;
hdisp(5)=handles.disp5;
hdisp(6)=handles.disp6;

hdel(1)=handles.del1;
hdel(2)=handles.del2;
hdel(3)=handles.del3;
hdel(4)=handles.del4;
hdel(5)=handles.del5;
hdel(6)=handles.del6;

sys.hdisp=hdisp;
sys.hdel=hdel;
%     handles.sys=sys;
%%%%%%%%%%%%%%%%%%%%%%%%%%%ˢ��ϵͳ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function open_working_path(hObject, eventdata, handles, working_path)
sys=get(handles.axes1,'userdata');
dirnames=dir(working_path);   % ������Ҫ��Ŀ¼�Լ��ļ���չ���滻����ȡĳ��Ŀ¼��ָ�������ļ��б����ؽṹ���顣
dircell=struct2cell(dirnames)' ;    % �ṹ��(struct)ת����Ԫ������(cell)��ת��һ�������ļ����������С�
dirnames=dircell(3:end,1) ;  % ��һ�����ļ���
set(handles.dir,'string',dirnames)%���ļ����б�����ʾ
sys.dirnames=dirnames;
sys.working_path=working_path;
set(handles.axes1,'userdata',sys);
dir_Callback(hObject, eventdata, handles)
sys=get(handles.axes1,'userdata');
set(handles.axes1,'userdata',sys);

%%%%%%%%%%%%%%%%%%%%%%%%%%%��������ļ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,y]=load_test_file(hObject, eventdata, handles, filepath)
sys=get(handles.axes1,'userdata');
fid = fopen(filepath);

C_head= textscan(fid, '%s %s ',6,'CollectOutput', 1);
C_data = textscan(fid, '%d %d', 'CollectOutput', 1);
rowHeadings={'name','rolltype','long','dist','suppliers','shift'};
info = cell2struct(C_head{1}, rowHeadings, 1);
set(handles.rollnum,'string',info(2,1).name);
set(handles.rolllength,'string',info(2,1).long);
set(handles.measstep,'string',info(2,1).dist);
set(handles.rolltype,'string',info(2,1).rolltype);
%                         set(handles.suppliers,'string',info(2,1).suppliers);
%                         filename=info(2,1).name;
if isempty(strfind(filepath,'theory'))&&isempty(strfind(filepath,'fit'))
    data=[filepath(end-14:end-13),'/',filepath(end-12:end-11),'/',filepath(end-10:end-9)];   %%%%%%%%%%%%%%%%%%%%%%%%%��Ҫ�޸�
    set(handles.date,'string',data);
    set(handles.time,'string',[filepath(end-7:end-6),':',filepath(end-5:end-4)]);
else
    set(handles.date,'string','');
    set(handles.time,'string','');
end


x=double(C_data{1}(:,1));
% x=x*173/172;
% x=round(x);
set(handles.measlength,'string',num2str(abs(x(end)-x(1))));
%                         x=x+str2double(info(2,1).shift);
y=double(C_data{1}(:,2));
%                         y=y-str2double(info(2,1).shift);
y=y-y(1);
if x(1)<100%�����Ҳ���
    sys.meas_direction='right';
else
    sys.meas_direction='left';
    x=x(end:-1:1);
    y=y(end:-1:1);
end
%%%%%%%%%%%%%%%remove the same data%%%%%%%%%%%%%
[x,idx]=unique(x);
y=y(idx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fclose(fid);
set(handles.axes1,'userdata',sys)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%ѡ������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function language_Callback(hObject, eventdata, handles,english_chanese)
h_info=load('languages.mat');
info=h_info.info;
if strcmp(english_chanese,'English')
    langu=3;
else
    langu=2;
end
set(handles.del6,'string',info(langu).del6)
set(handles.del5,'string',info(langu).del5)
set(handles.del4,'string',info(langu).del4)
set(handles.del6,'string',info(langu).del6)
set(handles.del5,'string',info(langu).del5)
set(handles.del4,'string',info(langu).del4)
set(handles.del3,'string',info(langu).del3)
set(handles.del2,'string',info(langu).del2)
set(handles.del1,'string',info(langu).del1)
set(handles.fullscreen,'string',info(langu).fullscreen)
set(handles.title,'string',info(langu).title)
set(handles.generaldata,'title',info(langu).generaldata)
set(handles.add,'string',info(langu).add)
set(handles.print_result,'Label',info(langu).print_result)
set(handles.measstep0,'string',info(langu).measstep0)
set(handles.measlength0,'string',info(langu).measlength0)
set(handles.rolllength0,'string',info(langu).rolllength0)
set(handles.rollcenter0,'string',info(langu).rollcenter0)
set(handles.rolltype0,'string',info(langu).rolltype0)
set(handles.suppliers0,'string',info(langu).suppliers0)
set(handles.datameas,'string',info(langu).datameas)
set(handles.kdmeas0,'string',info(langu).kdmeas0)
set(handles.rough0,'string',info(langu).rough0)
set(handles.hard0,'string',info(langu).hard0)
set(handles.remark0,'string',info(langu).remark0)
set(handles.resp0,'string',info(langu).resp0)
set(handles.inspector0,'string',info(langu).inspector0)
set(handles.rollnum0,'string',info(langu).rollnum0)
set(handles.cover0,'string',info(langu).cover0)
set(handles.datameas,'string',info(langu).datameas)
set(handles.ordernum0,'string',info(langu).ordernum0)
set(handles.rolldata,'title',info(langu).rolldata)
set(handles.customer0,'string',info(langu).customer0)
set(handles.language,'label',info(langu).language)
set(handles.chinese,'label',info(langu).chinese)
set(handles.english,'label',info(langu).english)
set(handles.rollname,'string',info(langu).rollname)
set(handles.historycurve,'string',info(langu).historycurve)
set(handles.save_data,'label',info(langu).save_data)
set(handles.work_path,'label',info(langu).work_path)
set(handles.theo_profile,'title',info(langu).theo_profile)
set(handles.none,'string',info(langu).none)
set(handles.cylindic,'string',info(langu).cylindic)
set(handles.cos,'string',info(langu).cos)
set(handles.formula,'string',info(langu).formula)
set(handles.file,'string',info(langu).file)
set(handles.sys_path,'string',info(langu).sys_path)
set(gcf,'name',info(langu).gcf)
set(handles.work_path,'label',info(langu).work_path)
set(handles.deleteFile,'string',info(langu).deleteFile)
set(handles.saveTheoyCurve,'string',info(langu).saveTheoyCurve)
set(handles.limit_err0,'string',info(langu).limit_err0)
set(handles.disp_limit_err,'string',info(langu).disp_limit_err)
set(handles.open_auto_mapping,'string',info(langu).open_auto_mapping)
set(handles.calibr_mode,'string',info(langu).calibr_mode)
set(handles.trapezium,'string',info(langu).trapezium)
set(handles.arc,'string',info(langu).arc)
% --- Executes on button press in deleteFile.
function deleteFile_Callback(hObject, eventdata, handles)
% hObject    handle to deleteFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sys=get(handles.axes1,'userdata');
fulpath=sys.cur_dir_path;
select_idx=get(handles.curve_files,'value');
list_str=get(handles.curve_files,'string');
filepath=fullfile(fulpath,list_str{select_idx});
delete(filepath);
set(handles.curve_files,'value',1);
set(handles.curve_files,'string','');
list_str(select_idx)=[];
set(handles.curve_files,'string',list_str);
sys.list_filenames=list_str;
set(handles.axes1,'userdata',sys)
guidata(hObject, handles);

% --- Executes on button press in saveTheoyCurve.
function saveTheoyCurve_Callback(hObject, eventdata, handles)
% hObject    handle to saveTheoyCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sys=get(handles.axes1,'userdata');
x=sys.theo_line.xdata;
y=sys.theo_line.ydata;
length=max(size(x));
filepath=[sys.theo_line.filepath,'.txt'];
fp = fopen(filepath,'wt');
if fp==-1
    if strcmp(sys.language,'English')
        message='can not find the path!';
    else
        strcmp(sys.language,'Chinese')
        message='�޷��ҵ�·����';
    end
    myDialog('warn',message);
    return
else
    fprintf(fp, '����\t%s\n',sys.cur_dir_name);
    filename=sys.theo_line.filename;
    stNum=strfind(filename,'theory');
    fprintf(fp, '��������\t%s\n',filename(stNum:end));
    fprintf(fp, '����\t%s\n',num2str(x(end)));
    fprintf(fp, '���\t%s\n',num2str((x(2)-x(1))));
    fprintf(fp, '��Ӧ��\t%s\n','');
    fprintf(fp, 'ƫ��ֵ\t%s\n','0');
    for i =1 : length
        fprintf(fp, '%d\t%d\n', x(i),y(i));
    end
    fclose(fp);
    set(handles.axes1,'userdata',sys)
    guidata(hObject, handles);
    
    
    if strcmp(sys.language,'Chinese')
    choice = MyQuestdlg('�����Ѿ�����ɹ�, �Ƿ񽫴���������ΪĬ���������ߣ�ע��ѡ���ǡ�����Ḳ���������������ļ���', ...
        'Dessert Menu', ...
        '��','��','��');
    else
        choice = MyQuestdlg('data have been saved!, whether set to the default theory curve (if you choose ''yes'', it will cover the theoy file)', ...
            'Dessert Menu', ...
            'Yes','No','No');
    end
    if isempty(choice)
        return
    end
    
    if strcmp(choice,'��')||strcmp(choice,'yes')
        orig_filename=[sys.cur_dir_name,'_theory_file.txt'];%Դ�ļ���
        filepath=fullfile(sys.cur_dir_path,orig_filename);
        N=max(size(x));
        fp = fopen(filepath,'wt');
        if fp==-1
            return
        else
            for i=1:N
                fprintf(fp, '%d\t%d\n',x(i),y(i));
            end
            fclose(fp);
        end
    end
end







function limit_err_Callback(hObject, eventdata, handles)
% hObject    handle to limit_err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limit_err as text
%        str2double(get(hObject,'String')) returns contents of limit_err as a double


% --- Executes during object creation, after setting all properties.
function limit_err_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limit_err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in disp_limit_err.
function disp_limit_err_Callback(hObject, eventdata, handles)
% hObject    handle to disp_limit_err (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of disp_limit_err


% --- Executes on button press in open_auto_mapping.
function open_auto_mapping_Callback(hObject, eventdata, handles)
% hObject    handle to open_auto_mapping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of open_auto_mapping


% --- Executes on button press in calibr_mode.
function calibr_mode_Callback(hObject, eventdata, handles)
% hObject    handle to calibr_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of calibr_mode

%************************add from formula**************************%
function creat_theo_line(handles,sys,L,x,y,filename)
calib_mode=get(handles.calibr_mode,'value');
if calib_mode
    y=y*2;
end
totalLength=str2double(get(handles.rolllength,'string'));
x=x+(totalLength-L)/2;
sys.theo_line.xlim=[x(1) x(end)];
sys.theo_line.ylim=[min(y) max(y)];
sys.theo_line.xdata=x;
sys.theo_line.ydata=y;
sys.theo_line.length=L;
sys.theo_line.nums=max(size(x));
sys.theo_line.filename=[sys.cur_dir_name,'_',filename];
sys.theo_line.filepath=fullfile(sys.cur_dir_path,sys.theo_line.filename);
axes(handles.axes1)
sys.theo_line.handle=plot(x,y,'--','color','k','linewidth',2);
[sys.theo_line.max_pt,sys.theo_line.min_pt]=line_max_min(sys.theo_line.handle);

% sys.active_line=sys.theo_line;
%��ȡ�������
error_range=get(handles.limit_err,'string');
error_range=str2double(error_range);

sys.theo_line_err_up.filename=[sys.cur_dir_name,'_theo_line_err_up'];
sys.theo_line_err_low.filename=[sys.cur_dir_name,'_theo_line_err_low'];

if get(handles.disp_limit_err,'value')  %r���������������ޣ�����ʾ����
    sys.theo_line_err_up.handle=plot(x,y+error_range,'--','color','r','linewidth',2);
    sys.theo_line_err_low.handle=plot(x,y-error_range,'--','color','b','linewidth',2);
%     x_lim=get(gca,'xlim');
    y_lim=get(gca,'ylim');
%     left_pos=x_lim(1)-(x_lim(2)-x_lim(1))/25;
    dist_pos=(y_lim(2)-y_lim(1))/20;
    sys.theo_line_err_up_text_handle=text(0,dist_pos,num2str(error_range),'HorizontalAlignment','right','FontSize',10);
    sys.theo_line_err_low_text_handle=text(0,-dist_pos,num2str(-error_range),'HorizontalAlignment','right','FontSize',10);
end

if get(handles.open_auto_mapping,'value')%��������Զ�ƥ�书�ܣ����Զ�ƥ��
    struct_lines=[sys.line sys.theo_line];
    valued_idx=get_value_handle_idx([sys.line sys.theo_line]);
    struct_lines(valued_idx)=mapping_all(struct_lines(valued_idx),[1 1]);
    sys.line=struct_lines(1:end-1);
    
    for i=1:size(valued_idx,2)-1 %����active_line�����ͬ�ڸ���ӵ����ߣ�mapping�����߱�ɾ����active_line���ͬ����ɾ�����������¸�ֵactive_line���
        if strcmp(sys.line(valued_idx(i)).filename,sys.active_line.filename)
            sys.active_line=sys.line(valued_idx(i));
            break
        end
    end
end
set(handles.axes1,'userdata',sys)

function save_print_data(filename,x,y)
N=max(size(x));
filepath=fullfile('./Printed data',filename);
fp = fopen(filepath,'wt');
if fp==-1
    return
else
    for i=1:N
        fprintf(fp, '%d\t%d\n',x(i),y(i));
    end
    fclose(fp);
end

% left=mod(3110,20)
% linspace(left/2,3110-left/2,21)
