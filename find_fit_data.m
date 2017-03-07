function [fit_y,leg_str,h_pt]=find_fit_data(hline,x_data,plot_sig)  %hlineΪ��Ч���,����Ϊһ�ж���
N=max(size(hline));
M=max(size(x_data));
fit_y=zeros(N,M);
h_pt=zeros(N,M);
leg_str=cell(N,M);
for j=1:M
    for i=1:N
        x_data_pt=round(x_data(j));
        x=get(hline(i),'xdata');
        y=get(hline(i),'ydata');
        if x_data_pt<x(1)
            x_data_pt=x(1);
        end
        if x_data_pt>x(end);
            x_data_pt=x(end);
        end

        [true,idx]=find(x_data_pt==x); %���Һ������Ƿ���ڸõ�
        if ~isempty(true)   %������ڣ���ֱ��������ֵ
            fit_y(i,j)=y(idx);
        else    %��������ڣ��������������ֵ
            dif=abs(x-x_data_pt);        
            [sorted_x,index]=sort(dif);
            p=polyfit(x(index(1:2)),y(index(1:2)),1);%ȥ��ӽ���2��ֵ�������
            fit_y(i,j)=round(polyval(p,x_data_pt));%��ϲ�ȡ��        
        end



        leg_str{i,j}=['x=',num2str(x_data_pt),', ','y=',num2str(fit_y(i))];

        if plot_sig
            h_pt(i,j)=plot(x_data_pt,fit_y(i,j),'ko','color',get(hline(i),'color'),'linewidth',2);
        end
    end
end





