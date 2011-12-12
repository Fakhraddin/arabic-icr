function  TestinMouse()   
% OBSULETE
%The return values of the funtion
global points;
global imGW;

%inner variable used only in this function
global prvt;

f = figure();

set(0,'CurrentFigure',f);
axis([0 1 0 1]);

set(f,'Pointer','crosshair','doublebuffer','on');
set(f,'WindowButtonDownFcn',@startDragFcn);

SZ = get(0,'ScreenSize');
width=SZ(1,3)/2;
high=SZ(1,4)/2;

function startDragFcn(varargin)

    global Min;
    global Max;
    
    set(f,'WindowButtonDownFcn',@startSecondDragFcn); %enables to write a letter that contains more than 1 part
    
    axis([0 1 0 1]);
    prvt = get(f,'CurrentPoint');
    
    Min = prvt;
    Max =Min;
 
    prvt(1)= prvt(1)/width; 
    prvt(2)= prvt(2)/high;
    
    points= prvt;
    
    set(f,'WindowButtonMotionFcn',@draggingFcn);
end

function startSecondDragFcn(varargin)

    global Min;
    global Max;

  axis([0 1 0 1]);
  pt = get(f,'CurrentPoint');
  
  if (pt(1) < Min(1)) 
      Min(1) = pt(1);
  end
  if (pt(2) < Min(2)) 
      Min(2) = pt(2);
  end
  if (pt(1) > Max(1)) 
      Max(1) = pt(1);
  end
  if (pt(2) > Max(2)) 
      Max(2) = pt(2);
  end

  pt(1)= pt(1)/width; 
  pt(2)= pt(2)/high;
  
  points=[points;pt];
  
  x = [prvt(1) pt(1)];
  y = [prvt(2) pt(2)];
  %line(x,y,'marker','.','LineWidth',3);
  prvt = pt;

  set(f,'WindowButtonMotionFcn',@draggingFcn);
end

function draggingFcn(varargin)
  global Min;
  global Max;

  axis([0 1 0 1]);
  pt = get(f,'CurrentPoint');
  
  if (pt(1) < Min(1)) 
      Min(1) = pt(1);
  end
  if (pt(2) < Min(2)) 
      Min(2) = pt(2);
  end
  if (pt(1) > Max(1)) 
      Max(1) = pt(1);
  end
  if (pt(2) > Max(2)) 
      Max(2) = pt(2);
  end

  pt(1)= pt(1)/width; 
  pt(2)= pt(2)/high;
  
  points=[points;pt];
  
  x = [prvt(1) pt(1)];
  y = [prvt(2) pt(2)];
  line(x,y,'marker','.','LineWidth',3);
  prvt = pt;
  set(f,'WindowButtonUpFcn',@stopDragFcn);
end

function stopDragFcn(varargin)
  global Min;
  global Max;  
  
  set(f,'WindowButtonMotionFcn','');
  [imGW,map] = frame2im(getframe(f,[Min(1)-20 Min(2)-20 (Max(1)-Min(1)+40) (Max(2)- Min(2)+40)])); 
  if ~isempty(map)            %Truecolor system
     imGW = ind2rgb(imGW,map);   %Convert image data
  end
  %close(f);
end

end
