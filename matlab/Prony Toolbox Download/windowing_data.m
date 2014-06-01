function [window_x,window_y]=windowing_data(x,y)
% Function to check how to get data points for windowing
% Collect 2 points on the graph from user

[xi,yi] = ginput(2);
lower_limit=max(find((x < xi(1))));
upper_limit=min(find((x > xi(2))));
% swap the lower limit with upper limit if user selects in
% opposite way
if(lower_limit > upper_limit)
    temp=lower_limit;
    lower_limit=upper_limit;
    upper_limit=temp;
end
% Data after windowing
window_x=x(lower_limit:upper_limit);
window_y=y(lower_limit:upper_limit);


     