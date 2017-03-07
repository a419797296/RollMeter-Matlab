function new_line=reflash(h_line,mode,language)
if ishandle(h_line)
    if strcmp(mode,'semidiameter')
        Nline=size(h_line,1);
        new_line=zeros(1,Nline);
        for i=1:Nline
            x=get(h_line(i),'xdata');
            y=get(h_line(i),'ydata')/2;
            color=get(h_line(i),'color');
            width=get(h_line(i),'linewidth');
            delete(h_line(i));
            new_line(i)=plot(x,y,'color',color,'linewidth',width);
        end
    end
else
    
     if strcmp(language,'English')
         h=errordlg('the input parameter is not a handle','Error');  
     end
     if  strcmp(language,'Chinese')
         h=errordlg('输入参数不是一个曲线句柄','错误');  
     end
         chgicon(h,'rollmeter.png')  %h更改GUI图标  
end