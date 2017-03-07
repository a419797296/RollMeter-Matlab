function test_mouse_track()
% I = imread('1.bmp');
% imshow(I); hold on
figure;hold on
 axis([-10,10,0,5]);
set(gcf,'Unit','normalized')
qg=uicontrol('Style','pushbutton','Tag','move','Unit','normalized','Position',[0.5 0.5 0.05 0.05],...
    'callback',@ButtonDownFcn)
% set(gcf,'WindowButtonDownFcn',@ButtonDownFcn);
set(gcf,'WindowButtonUpFcn',@ButtonUpFcn);
% handles.qg=qg;
% % Update handles structure
% guidata(hObject, handles);

% set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);

function ButtonDownFcn(src,event)
obj=findobj(gcf,'style','pushbutton')
pt = get(obj,'position');    %获取当前点坐标
x = pt(1,1);
y = pt(1,2);
set(gcf,'WindowButtonMotionFcn',@ButtonMotionFcn); %设置鼠标移动响应
% fprintf('x=%f,y=%f\n',x,y);
% plot(x,y,'*');

function ButtonMotionFcn(src,event)
obj=findobj(gcf,'style','pushbutton')
pt1 = get(gcf,'CurrentPoint')
pt = get(obj,'position');    %获取当前点坐标
pt(1) = pt1(1,1)-pt(3)/2;
% pt(2) = pt1(1,2)-pt(4)/2;

 set(obj,'position',pt);    %获取当前点坐标
% fprintf('x=%f,y=%f\n',x,y);

function ButtonUpFcn(src,event)
set(gcf, 'WindowButtonMotionFcn', '');    %取消鼠标移动响应

pt = get(gca,'currentpoint');    %获取当前点坐标
line([pt(1,1) pt(1,1)],[0 10])

