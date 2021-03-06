function Sequence = ManualSegmentation2
%MANUALSEGMENTATION2 
% Pen-Like data processing template
% pen.m is a GUI ready to use
%       the GUI calls a function called "process_data"

global in_writing;
global himage;

global inner_Seq dcm1;

ClearAll();

in_writing = 0;

% create the new figure
himage = figure;

set(himage,'numbertitle','off');               % treu el numero de figura
set(himage,'name','Pen - Testing Mouse');    				   % Name
set(himage,'MenuBar','none');                  % remove the menu icon
set(himage,'doublebuffer','on');               % two buffers graphics
set(himage,'tag','PEN');                       % identify the figure
set(himage,'Color',[0.95 0.95 0.95]);
set(himage,'Pointer','crosshair');

% create the axis
h_axes = axes('position', [0 0 1 1]);
set(h_axes,'Tag','AXES');
box(h_axes,'on');
%grid(h_axes,'on');
axis(h_axes,[0 1 0 1]);
%axis(h_axes,'off');
hold(h_axes,'on');


line([0 1],[0.4 0.4],'Color','black','LineWidth',2);
line([0 1],[0.6 0.6],'Color','black','LineWidth',2);
line([0 1],[0.8 0.8],'Color','black','LineWidth',2);


% ######  MENU  ######################################
h_opt = uimenu('Label','&Options');
uimenu(h_opt,'Label','Clear','Callback',@ClearAll);
uimenu(h_opt,'Label','Exit','Callback','closereq;','separator','on');


% create the text
% h_text = uicontrol('Style','edit','Units','normalized','Position',[0 0.9 1 0.10],'FontSize',8,'HorizontalAlignment','left','Enable','inactive','Tag','TEXT');

set(himage,'WindowButtonDownFcn',@movement_down);
set(himage,'WindowButtonUpFcn',@movement_up);
set(himage,'WindowButtonMotionFcn',@movement);
uiwait;
Sequence = dcm1;

% #########################################################################

% #########################################################################
function ClearAll(hco,eventStruct)

global x_pen y_pen dcm1;

% erase previous drawing
delete(findobj('Tag','SHAPE'));
delete(findobj('Tag','BOX'));

% delete previous data
x_pen = [];
y_pen = [];
dcm1 = [];

% #########################################################################

% #########################################################################
function movement_down(hco,eventStruct)

global in_writing x_pen y_pen;

% toggle
in_writing = 1;

% restore point
h_axes = findobj('Tag','AXES');
p = get(h_axes,'CurrentPoint');
x = p(1,1);
y = p(1,2);

% cumulative data
x_pen = [x_pen x];
y_pen = [y_pen y];

% draw
plot(h_axes,x,y,'b.','Tag','SHAPE','LineWidth',3);
% #########################################################################


% #########################################################################
function movement_down2(hco,eventStruct)

global in_writing x_pen y_pen dcm1;
h_axes = findobj('Tag','AXES');
p = get(h_axes,'CurrentPoint');
x = p(1,1);
y = p(1,2);
dcm = datacursormode;
Point= dcm.figure.CurrentPoint;
dcm1 = [dcm1;Point];
%set(himage,'WindowButtonDownFcn',@movement_down2);
% #########################################################################

% #########################################################################
function movement_up(hco,eventStruct)
global in_writing x_pen y_pen himage

% toggle
in_writing = 0;

h_axes = findobj('Tag','AXES');

% analysis of what has been pressed
% delete box above
delete(findobj('Tag','BOX'));

% marcar un requadre
x_i = min(x_pen);
x_f = max(x_pen);
x_d = max([1 (x_f - x_i)]);
y_i = min(y_pen);
y_f = max(y_pen);
y_d = max([1 (y_f - y_i)]);
plot(h_axes,[x_i x_f x_f x_i x_i],[y_i y_i y_f y_f y_i],'K:','MarkerSize',22,'Tag','BOX');
process_data(x_pen,y_pen);
set(himage,'WindowButtonDownFcn',@movement_down2);
% #########################################################################

% #########################################################################
function movement(hco,eventStruct)

global in_writing x_pen y_pen

if in_writing
    % button pressing
    
    h_axes = findobj('Tag','AXES');
    
    p = get(h_axes,'CurrentPoint');
    x = p(1,1);
    y = p(1,2);
    
    
    if ((y < 0) || (y > 1) || (x < 0) || (x > 1))
        % do nothing
        return;
    end
    
    if ((x ~= x_pen(end)) || (y ~= y_pen(end)))
        % next point
        x_pen = [x_pen x];
        y_pen = [y_pen y];
        
        plot(h_axes,[x_pen(end-1) x],[y_pen(end-1) y],'b.-','Tag','SHAPE','LineWidth',3);
    end  
end
    
    %     if ((x < 0.1) && (y < 0.1))
    %         % execute when passing on the red region
    %         if (~isempty(x_pen))
    %
    %             % processar la paraula
    %             process_data(x_pen,y_pen);
    %
    %             % borrar dibuix
    %             delete(findobj('Tag','SHAPE'));
    %             delete(findobj('Tag','BOX'));
    %
    %             % borrar dades
    %             x_pen = [];
    %             y_pen = [];
    %         end
    %     end
    
% #########################################################################

% #########################################################################
function process_data(x_pen,y_pen)

% your code for word recognition / draw processing starts here
% x_pen, y_pen are the current point locations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global folder;
global kNN;
global inner_Seq;

Sequence(:,1) = x_pen;
Sequence(:,2) = y_pen;

inner_Seq = Sequence;

% #########################################################################

