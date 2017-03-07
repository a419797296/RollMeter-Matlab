clear
clc
st=20
x2=1:st:800*pi;
x1=x2(25:end-20);
num1=size(x1,2)
num2=size(x2,2)
y1=sin(x1/400-1)             %+0.2*rands(1,num1)
y2=sin(x2/400-1)+2             %+0.2*rands(1,num2)
hold on
plot(x1,y1,'r',x2,y2,'r')
grid

num1=size(y1,2)
num2=size(y2,2)
max=0;
max_x=1;
if num1>num2
    for i=1:num1-num2
        cor=corrcoef(y2,y1(i:num2+i-1))
        if cor(2)>max
            max=cor(2)
            max_x=i
        end
    end
    shift_y=(mean(y2)-mean(y1(max_x:max_x+num2-1)))
    new_x=x2+max_x*st+x1(1)-x2(1)
    new_y=y2-shift_y;
else
    for i=1:num2-num1
        cor=corrcoef(y1,y2(i:num1+i-1))
        if cor(2)>max
            max=cor(2)
            max_x=i
        end
    end 
    shift_y=(mean(y1)-mean(y2(max_x:max_x+num1-1)))
    new_x=x1+max_x*st+x2(1)-x1(1)
    new_y=y1-shift_y;
end
plot(new_x,new_y,'g')
