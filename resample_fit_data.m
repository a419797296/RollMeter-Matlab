function [fit_x,fit_y]=resample_fit_data(x,y,st)  %hline为有效句柄,可以为一行多列

fit_x=x(1):st:x(end);
% y=get(hline,'ydata');
N=size(fit_x,2);
fit_y=zeros(1,N);

for i=1:N
    dif=abs(x-fit_x(i));
    [sorted_x,index]=sort(dif);
    p=polyfit(x(index(1:3)),y(index(1:3)),2);%去最接近的四个值进行拟合
    fit_y(i)=round(polyval(p,fit_x(i)));%拟合并取整
end






