function  fit_y=cosfit(hline,theta,fit_x)
% %根据y轴比例换算
% x=get(hline,'xdata');
% y=get(hline,'ydata');
% st_pt=1;
% T=L*180/theta;
% real_start_ang=deg2rad(90-theta);
% real_start_y=sin(real_start_ang)
% fit_x=x(st_pt:end-st_pt+1);
% real_pt_angle=deg2rad(90-theta*(1-2*fit_x(1)/L))
% p=polyfit(x(st_pt:end-st_pt+1),y(st_pt:end-st_pt+1),5);
% poly_fit_y=polyval(p,fit_x);%拟合并取整
% Amp=(max(y)-poly_fit_y(1))/(1-sin(real_pt_angle));
% real_start_ang=deg2rad(90-theta);
% h=Amp*(1-sin(real_start_ang))
% 
% fit_x=0:L;
% fit_ang_range=fit_x/T*2*pi+real_start_ang;
% fit_y=(sin(fit_ang_range)-real_start_y)*Amp;
% hlineCosFit=plot(fit_x,fit_y,'g');

%根据x轴角度差
x=get(hline,'xdata');
y=get(hline,'ydata');
st_pt=1;
L=max(fit_x);
real_pt_angle=deg2rad(90-theta*(1-2*fit_x(1)/L));
T=L*180/theta;
real_start_ang=deg2rad(90-theta);
real_start_y=sin(real_start_ang);
real_ang_range=x(st_pt:end-st_pt+1)/T*2*pi+real_start_ang;
xx=sin(real_ang_range)-real_start_y;
dif_ang_y=sin(real_pt_angle)-sin(real_start_ang);

p=polyfit(x(st_pt:end-st_pt+1),y(st_pt:end-st_pt+1),5);
poly_fit_y=polyval(p,fit_x);%拟合并取整

shift_poly_fit_y=y-poly_fit_y(1); %利用原始你和曲线进行cos拟合，如果把poly_fit_y改成y，则采用测量数据进行拟合
Amp=shift_poly_fit_y*pinv(xx)/(1-dif_ang_y*sum(pinv(xx)));
% Amp=y(st_pt:end-st_pt)*pinv(xx);
h=Amp*(1-sin(real_start_ang));

fit_ang_range=fit_x/T*2*pi+real_start_ang;
fit_y=(sin(fit_ang_range)-real_start_y)*Amp;
fit_y=round(fit_y);

% [max_y,idx]=max(fit_y);
% max_pt=[fit_x(idx),max_y];
% [min_y,idx]=min(fit_y);
% min_pt=[fit_x(idx),min_y];
% 
% fit_line.max_pt=max_pt;
% fit_line.min_pt=min_pt;
% fit_line.fit_x=fit_x;
% fit_line.fit_y=fit_y;
% 
% fit_hline=plot(fit_x,fit_y);
% set(fit_hline,'visible','off')