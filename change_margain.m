function [xlim,ylim]=change_margain(axes,percent)
xlim=get(axes,'xlim');
ylim=get(axes,'ylim');
percent=percent-1;

board_x=(xlim(2)-xlim(1))*percent;
xlim(1)=xlim(1)-board_x;
xlim(2)=xlim(2)+board_x;
board_y=(ylim(2)-ylim(1))*percent;
ylim(1)=ylim(1)-board_y;
ylim(2)=ylim(2)+board_y;
set(axes,'xlim',xlim,'ylim',ylim)