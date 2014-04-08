function out = stretch(max_y,min_y,max_x,min_x,val)
    % function out = stretch(max_y,min_y,max_x,min_x,val)
    % Generates a function y = m*x + b that maps
    % (max_x,max_y) and (min_x,min_y) and then evaluates it
    % at val.
    out = interp([min_x max_x],[min_y max_y],val);
%     out = (max_y - min_y)*(val - min_x)/(max_x - min_x) + min_y;
end