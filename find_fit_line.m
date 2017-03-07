function [fit_x,fit_y]=find_fit_line(hline,xlim,st) 

fit_x=xlim(1):st:xlim(2);
% y=get(hline,'ydata');
N=size(fit_x,2);
fit_y=zeros(1,N);
for i=1:N
    fit_y(i)=find_fit_data(hline,fit_x(i),0);
end