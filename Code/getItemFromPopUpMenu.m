function Item = getItemFromPopUpMenu( hObject )
%UNTITLED Given a popup menu handle, the function returns the currently
%selected item

%   Detailed explanation goes here

allList = cellstr(get(hObject,'String'));
valueIndex = {get(hObject,'Value')};
Item = allList(valueIndex{1});

end

