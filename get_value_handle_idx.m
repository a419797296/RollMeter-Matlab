function valued_idx=get_value_handle_idx(struct_lines)
line_nums=max(size(struct_lines));
valued_idx=[];
for i=1:line_nums
   if ishandle(struct_lines(i).handle)
       valued_idx(end+1)=i;
   end
end