function [new_x,new_y]= curve_shift(h,shift_xy)
x=get(h,'Xdata');
y=get(h,'Ydata');
new_x=x+shift_xy(1);
new_y=y+shift_xy(2);

