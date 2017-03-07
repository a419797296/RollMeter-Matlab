L=300 %线压力KN/m
% F=1000:20:4000
F=7000  %辊面长mm
ODs=1500 %辊壳外径mm
IDs=1360 %辊壳内劲mm
E=0.2e9 %辊壳弹性模量  KN/m
H=54   %辊子轴承中心至中高起始总的距离cm
% C=0.531*L*power(F,4).*(1+4.8*(H./F)+2*power(ODs./F,2))/(E*(power(ODs,4)-power(IDs,4)))
C=0.531*L*power(F,4)*(1+4.8*(H/F)+2*power(ODs/F,2))/(E*(power(ODs,4)-power(IDs,4)))
% plot(F,C)

T=2*F/130*180  %正弦信号周期
% x=T*25/360:20:T*155/360;
x=0:20:2000;
y=C*sin(2*pi/T*(x+T*25/360))-C*sin(2*pi*25/360);
plot(x,y)

clc
clear

figure
h=0.195;
L=4750;
theta=20;


T=L*180/theta;
data=load('data.mat');
data=data.data;
Amp=h/(1-cos(theta*pi/180));
x=-T/4:95:T/4;
xx=-theta/360*T:95:theta/360*T;
y=Amp*cos(2*pi/T*x)-Amp*cos(theta/180*pi);
yy=Amp*cos(2*pi/T*xx)-Amp*cos(theta/180*pi);
plot(x,y,'-*','color','b','linewidth',1)
hold on
plot(xx,yy,'-*','color','r','linewidth',2)

plot(xx,data,'-*','color',[0 0 0],'linewidth',3)

error=yy-data;
max(abs(error))
max(error)
plot(xx,error','-<','color',[0.5 0 0],'linewidth',1)
grid

%  p=fittype('a*cos(2*pi*x/9/L)-a*cos(pi/9)','independent','x','coefficients',{'a','L'}) 
  p=fittype('a*cos(x)','independent','x','coefficients',{'a'}) 
 x=xx';
 y=data';
 f=fit(x,y,p) 
 figure
 plot(f,x,y);  

 
 
xdata =xx;
ydata =data; 
a0 = [3,0.0001,3];   % 初始化参数
[ a, resnorm ] = lsqcurvefit( @subfun, a0, xdata, ydata )
plot(xdata,ydata)
y = subfun(a,xdata);
hold on
plot(xdata,y,'r')