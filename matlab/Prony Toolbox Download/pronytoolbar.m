
function pronytoolbar(varargin)

% Concept is taken from cftool , Curve fitting tool, MATLAB
% We want a subset of the usual toolbar, there is a handlegraphics bug
% that turned the toolbar off when the buttons were created, so
% we have to toggle it back on.

if (nargin>0 & ishandle(varargin{1}) & ...
               isequal(get(varargin{1},'Type'),'figure'))
   hObject = varargin{1};
else
   hObject = gcbf;
end

tbstate = get(hObject,'toolbar');
h = findall(hObject,'Type','uitoolbar');
if isequal(tbstate,'none') | isempty(h)
   % Create toolbar for the first time
   set(hObject,'toolbar','figure');
   h0 = findall(hObject,'Type','uitoolbar');
    h1 = findall(h0,'Parent',h0);
    for j=length(h1):-1:1
        mlabel = get(h1(j),xlate('TooltipString'));
        if ~isempty(findstr(mlabel,'Zoom'))
        elseif ~isempty(findstr(mlabel,'Line'))
        elseif ~isempty(findstr(mlabel,'Text'))
        elseif isempty(findstr(mlabel,'Print'))
                delete(h1(j));
                h1(j) = [];
        else
                c1 = h1(j);
        end
    end
   
elseif nargin>1 & isequal(varargin{2},'on')
   % Hide toolbar
   set(h,'Visible','on');
else
   % Show toolbar
   set(h,'Visible','off');
end


