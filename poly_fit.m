function fit_y=poly_fit(hline,fit_x)
x=get(hline,'xdata');
y=get(hline,'ydata');
p=polyfit(x,y,5);%ȥ��ӽ���2��ֵ�������

fit_y = round(polyval(p,fit_x));%��ϲ�ȡ��
% shift_y = min(fit_y);
fit_y=fit_y-min(fit_y);   %����ƫ��
% [max_y,idx]=max(fit_y);
% max_pt=[fit_x(idx),max_y];
% [min_y,idx]=min(fit_y);
% min_pt=[fit_x(idx),min_y];
% 
% fit_line.max_pt=max_pt;
% fit_line.min_pt=min_pt;
% fit_line.fit_x=fit_x;
% fit_line.fit_y=fit_y;

% fit_hline=plot(fit_x,fit_y);
% set(fit_hline,'visible','off')