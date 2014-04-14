%% OBJECTIVE
% Find the real g-scale the accelerometer is reading
% The datasheet specifies a -1.5g to 1.5g scale (optionally +-6)
% but the values are not consistent with such scale
% a way of specifying the scale is to find its max and min values.

%% INPUT

run static_data

% v_static_reads
% holds all the readings for the positions
% T ; B ; H+ - H- ; V+ ; V-
% which are measuring gravity.

% expected_g
% the expected gravity values for each of the
% v_static reads. Columns are coupled between both matrixes
          
%% PROCESS

% Find the functions Gx(V),Gy(V),Gz(V)by finding Vn,Vp,Vp in 
% (Vn,-1), (V0,0), (Vp,+1) for each axis

v_table = zeros(3);
for coord = 1:3
    for val = -1:1
        for i = 1:size(v_static_reads,1)
            if (expected_g(i,coord) == val)
                % Takes only one of the values from v_static_reads
                v_table(val+2,coord) = v_static_reads(i,coord);
            end
        end
    end
end

%% PLOT

% plot((-1:1),v_table)

% Gx(V) and Gy(V) are the same function
% Gz(V) looks parallel but decreased by:
               
b_z = mean(v_table(:,1:2),2) - v_table(:,3);

% Confirm by adding the difference and checking the plots.
% aux = zeros(3);
% aux(:,3) = b_z;
% plot((-1:1),v_table + aux);

% we don't care about b_z. But we do want G(coord,V)
% GG = @(coord,V) interp1(v_table(:,coord),(-1:1),V,'linear','extrap'); 

% val = [0 3.3];
% for coord = 1:3
%     for j = 1:2
%         G_extremes(j,coord) = G(coord,val(j));
%     end
% end
% G_extremes


%% CHECK
% 
% figure
% hold on
% V = 0:0.5:3.3';
% y = zeros(size(V,2),3);
% for i = 1:3
%     y(:,i) = G(v_table,i,V);
% end
% hold off
% 
% plot(V,y(:,3)-y(:,2))



