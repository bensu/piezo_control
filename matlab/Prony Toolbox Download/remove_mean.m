  function [dp_x,dp_y]= remove_mean(bdp_x,bdp_y,para_type)
% dp refers to Data preprocessed
% bdp refers to before data preprocess
% bdp_x refers to before data preprocessed x value
% bdp_y refers to before data preprocessed y value
% para_type refers to the type of parameter, para_type can be v or i
% Find and report the zero bdp_x point, use this to find pre and post event records

zero_bdp_x_index=find(bdp_x==0);
if (isempty(zero_bdp_x_index)==0)
    dp_x=bdp_x(zero_bdp_x_index:end);
    pre_event_bdp_y=bdp_y(1:zero_bdp_x_index);
    post_event_bdp_y=bdp_y(zero_bdp_x_index:end);
    % Compute offsets in v and i data, we'll assume that these should be removed
    pre_event_mean=mean(pre_event_bdp_y);
    pre_event_std=std(pre_event_bdp_y);  % Always worth looking at deviation as well

    % Remove the mean of measurements, include the scaling as described in the Reactor Manual Diagnostics
    
    if(strncmp(para_type,'v_',2)==1)
        dp_y=242000*(post_event_bdp_y-pre_event_mean);
        %disp(sprintf('Raw voltage before event has mean of %f and deviation of %f',pre_event_mean, pre_event_std))
    elseif(strncmp(para_type,'i_',2)==1)
        dp_y=710*(post_event_bdp_y-pre_event_mean);
        %disp(sprintf('Raw current before event has mean of %f and deviation of %f',pre_event_mean, pre_event_std))
    elseif(strncmp(para_type,'c_',2)==1)
        dp_c_mean=3000*pre_event_mean;
        dp_y=post_event_bdp_y;
    else
        dp_y=post_event_bdp_y;
        %disp('No mulitplication done');
    end  
else
    dp_x=bdp_x;
    dp_y=bdp_y;
end