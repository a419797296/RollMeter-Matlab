
function [move_curve,cor_max,shift_xy]= mapping(hline1,hline2,max_err,cor_dist)%max_err:最大允许误差，cor_dist：比较点密度
x1=get(hline1,'xdata');
% y1=get(hline1,'ydata');
x2=get(hline2,'xdata');
% y2=get(hline2,'ydata');
% [fit_x,fit_y]=find_fit_line(hline1,[1500 2000],10)
% plot(fit_x,fit_y,'*')
% 
% 
% plot(fit_x2,fit_y2,'k')
st=cor_dist;
mv_st=max_err;
% map_perecent=0.6;%匹配60%
% num1=size(x1,2);
% num2=size(x2,2);
max_cor=0;  %最大相似度
max_idx=1;  %拟合度最高的下标
%%%%%%%%%%%%%%%%%%%%%提示匹配进度%%%%%%%%%%%%%%%%%%%%%%%%

if x1(end)-x1(1)>=x2(end)-x2(1)   %line2短
    start_map_idx=round(x2(1)+(x2(end)-x2(1))*0.1);
   
%     end_map_idx=round(x2(end)-(x2(end)-x2(1))*0.1);
    end_map_idx=round(x2(end)); 
    map_length=end_map_idx-start_map_idx;
    match_data_lim=[start_map_idx end_map_idx];

    [fit_x2,fit_y2]=find_fit_line(hline2,match_data_lim,st);

    for i=1:mv_st:x1(end)-map_length
        y1_lim=[i i+map_length];
        [fit_x1,fit_y1]=find_fit_line(hline1,y1_lim,st);
        cor=corrcoef(fit_y2,fit_y1);
        if cor(2)>max_cor
            max_cor=cor(2);
            max_idx=i;
        end
    end
    y1_lim=[max_idx max_idx+map_length];
    
%     
%         for i=1:mv_st:x1(end)-map_length+1
%         y1_lim=[i i+map_length-1];
%         [fit_x1,fit_y1]=find_fit_line(hline1,y1_lim,st);
%         cor=corrcoef(fit_y2,fit_y1);
%         if cor(2)>max_cor
%             max_cor=cor(2);
%             max_idx=i;
%         end
%     end
%     y1_lim=[max_idx max_idx+map_length-1];
    
    
    
    [fit_x1,fit_y1]=find_fit_line(hline1,y1_lim,st);
    shift_y=round((mean(fit_y1)-mean(fit_y2)));
    shift_x=max_idx-start_map_idx;
    move_curve=2;
else     %line1短
    start_map_idx=round(x1(1)+(x1(end)-x1(1))*0.1);
%     end_map_idx=round(x1(end)-(x1(end)-x1(1))*0.1);
    end_map_idx=round(x1(end));
    map_length=end_map_idx-start_map_idx;
    match_data_lim=[start_map_idx end_map_idx];

    [fit_x1,fit_y1]=find_fit_line(hline1,match_data_lim,st);
%     plot(fit_x1,fit_y1,'*')
    for i=1:mv_st:x2(end)-map_length+1
        y2_lim=[i i+map_length];
        [fit_x2,fit_y2]=find_fit_line(hline2,y2_lim,st);
        cor=corrcoef(fit_y1,fit_y2);
        if cor(2)>max_cor
            max_cor=cor(2);
            max_idx=i;
        end
    end
    y2_lim=[max_idx max_idx+map_length-1];
    [fit_x2,fit_y2]=find_fit_line(hline2,y2_lim,st);
    shift_y=round((mean(fit_y2)-mean(fit_y1)));
    shift_x=max_idx-start_map_idx;
    move_curve=1;
end
cor_max=max_cor;
shift_xy=[shift_x shift_y];


