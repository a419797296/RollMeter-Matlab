function new_h_line=line_plot(h_line)
x=get(h_line,'Xdata');
y=get(h_line,'Ydata');
color=get(h_line,'color');
linewidth=get(h_line,'linewidth');
new_h_line=plot(x,y,'color',color,'linewidth',linewidth)