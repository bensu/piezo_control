function out = stretch(max_y,min_y,max_x,min_x,val)
    out = (max_y - min_y)*(val - min_x)/(max_x - min_x) + min_x;
end