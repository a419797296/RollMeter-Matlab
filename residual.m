function [x,dif_y]=residual(hline1,hline2,st)
x1=get(hline1,'xdata');
% y1=get(hline1,'ydata');
% p1=polyfit(x1,y1,4);

x2=get(hline2,'xdata');
% y2=get(hline2,'ydata');
% p2=polyfit(x2,y2,4);
N_low=max(min(x1),min(x2));
N_up=min(max(x1),max(x2));
x=N_low:st:N_up;
nums=size(x,2);
% dif_y=polyval(p1,x)-polyval(p2,x);
fit_y1=zeros(1,nums);
fit_y2=zeros(1,nums);
for i=1:nums
    fit_y1(i)=find_fit_data(hline1,x(i),0);
    fit_y2(i)=find_fit_data(hline2,x(i),0);
end
dif_y=fit_y1-fit_y2;    

