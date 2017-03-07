function h=myDialog(type,message)
switch type
    case 'erro'
        h=errordlg(message,'Warning£¡');
    case 'warn'
        h=warndlg(message,'Warning£¡');
    case 'mess'
        h=msgbox(message);
end
chgicon(h,'rollmeter.png')  %h¸ü¸ÄGUIÍ¼±ê;