function [new_hline]=plot_handle(hline)
line_nums=max(size(hline));
new_hline=zeros(1,line_nums);
for i=1:line_nums
    if ~ishandle(hline(i))
        error('invaled handle')
    end
    x=get(hline(i),'xdata');
    y=get(hline(i),'ydata');
    color=get(hline(i),'color');
    lineStyle=get(hline(i),'LineStyle');
    linewidth=get(hline(i),'linewidth'); 
    new_hline(i)=plot(x,y,'color',color,'linestyle',lineStyle,'linewidth',linewidth);
end