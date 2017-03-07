function h=tabgui

% TABGUI  Tabbed GUI dialog example

% Note: All dimensions in this code are estimates.  Change them to change the appearance of the GUI.
%
% Using the syntax tabDims=tabdlg('tabdims', strings, font) as described in the help for TABDLG
% will help in selecting appropriate values for the tab and uicontrol dimensions

strings={'Input data','Solutions'}; % Tab labels
tabdims={[140 140],20}; % Tab dimensions (pixels)
cb=@changetabs; % Callback function executed when changing tabs
dimensions=[300,300]; % GUI size (pixels)
offsets=[10 10 10 10]; % Offset of the tab windows from the sides of the figure window (pixels)
starting=1; % Starting on page 1, "Input data"

% Calling TABDLG to set up the GUI
% It will still be invisible after this call
[h, pos]=tabdlg('create',strings, tabdims, cb, dimensions, offsets, starting);

% Setting default UICONTROL values for the GUI
set(h,'defaultuicontrolunits','pixels', 'defaultuicontrolstyle','text');

% Enter coefficients here
cw=uicontrol('style','edit','position',[100 100 100 20],'visible','on','tag','cw');

% Label for coefficients edit box
l1=uicontrol('position',[125 150 75 20],'string','Coefficients','visible','on','tag','l1');

% Root display box -- on page 2, so invisible while page 1 is active
rd=uicontrol('position',[75 50 150 150],'visible','off','tag','rd');

% Label for root display box -- invisible while page 1 is active
l2=uicontrol('position',[125 250 75 20],'string','Roots','visible','off','tag','l2');

% Creating handles structure for easy use in the callback later
handles.cw=cw; handles.rd=rd; handles.l1=l1; handles.l2=l2;
set(h,'userdata',handles);

% Making the GUI visible and giving it a name
set(h,'visible','on','name','TABDLG Example');

function changetabs(flag, newname, newnum, oldname, oldnum, figh)
    
if isequal(newnum,2) & isequal(oldnum,1)
    % Switching from tab 1, Input data, to tab 2, Solutions

    % Getting handles of uicontrols
    handles=get(gcbf,'userdata');
    
    % Getting coefficients from CW
    coeffs=str2num(get(handles.cw,'string'));
    % Finding roots
    R=roots(coeffs);
    
    % Turning uicontrols on page 1 invisible
    set([handles.cw;handles.l1],'visible','off');
    % Turning uicontrols on page 2 visible
    set([handles.rd;handles.l2],'visible','on');
    
    % Displaying the roots in the root display box
    set(handles.rd,'string',num2str(R));
else
    % Switching from tab 2, Solutions to tab 1, Input data
    
    % Getting handles of uicontrols
    handles=get(gcbf,'userdata');
    
    % Turning uicontrols on page 1 visible
    set([handles.cw;handles.l1],'visible','on');
    % Turning uicontrols on page 2 invisible
    set([handles.rd;handles.l2],'visible','off');
end
