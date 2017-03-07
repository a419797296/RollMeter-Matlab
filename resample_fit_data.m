function [fit_x,fit_y]=resample_fit_data(x,y,st)  %hlineΪ��Ч���,����Ϊһ�ж���

fit_x=x(1):st:x(end);
% y=get(hline,'ydata');
N=size(fit_x,2);
fit_y=zeros(1,N);

for i=1:N
    dif=abs(x-fit_x(i));
    [sorted_x,index]=sort(dif);
    p=polyfit(x(index(1:3)),y(index(1:3)),2);%ȥ��ӽ����ĸ�ֵ�������
    fit_y(i)=round(polyval(p,fit_x(i)));%��ϲ�ȡ��
end






