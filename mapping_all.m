function [struct_lines cor_max]=mapping_all(struct_lines,shift_xy_mode)
line_nums=max(size(struct_lines));
locked_line=1;
max_length=0;
if ~isempty(strfind(struct_lines(end).filename, 'theory')) %最后一条曲线是即将拟合的曲线
    locked_line=line_nums;
else
    for i=1:line_nums
        line_name = struct_lines(i).filename;
        if ~isempty(strfind(line_name, 'theo_line_err'))||~isempty(strfind(line_name, 'theo_line_err'))
            continue
        end
       
       if ~isempty(strfind(line_name, 'theory'))
            locked_line=i;
            break
       else
           if (struct_lines(i).xlim(2)-struct_lines(i).xlim(1)) > max_length
               max_length=struct_lines(i).xlim(2)-struct_lines(i).xlim(1);
               locked_line=i;
           end
       end
    end       
end


for i=1:line_nums
    if i~=locked_line
        if ~isempty(strfind(struct_lines(i).filename, 'theo_line_err'))||~isempty(strfind(struct_lines(i).filename, 'theo_line_err'))
            continue
        end
        [move_curve,cor_max,shift_xy]=mapping(struct_lines(locked_line).handle,struct_lines(i).handle,20,80);
        if move_curve==1
            shift_xy=-shift_xy;
        end
        if shift_xy_mode(1)==0
            shift_xy(1)=0;
        end
        if shift_xy_mode(2)==0
            shift_xy(2)=0;
        end
        [new_x,new_y]=curve_shift(struct_lines(i).handle,shift_xy); %始终移动测量曲线
        color=get(struct_lines(i).handle,'color');
        lineStyle=get(struct_lines(i).handle,'LineStyle');
        linewidth=get(struct_lines(i).handle,'linewidth');
        delete(struct_lines(i).handle)%删除测量曲线
        struct_lines(i).handle=plot(new_x,new_y,'color',color,'linestyle',lineStyle,'linewidth',linewidth);
        struct_lines(i).xdata=new_x;
        struct_lines(i).ydata=new_y;
        struct_lines(i).xlim=[new_y(1) new_y(end)];
        struct_lines(i).ylim=[min(new_y) max(new_y)];
        [struct_lines(i).max_pt,struct_lines(i).min_pt]=line_max_min(struct_lines(i).handle);
    end
end
if line_nums~=2
   cor_max=''; 
end