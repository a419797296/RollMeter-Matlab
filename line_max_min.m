function [max_pt,min_pt]=line_max_min(hline)
x=get(hline,'xdata');
y=get(hline,'ydata');
[max_y,max_idx]=max(y);
[min_y,min_idx]=min(y);
max_pt=[x((max_idx)),max_y];
min_pt=[x((min_idx)),min_y];