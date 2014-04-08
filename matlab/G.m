function g = G(v_table,coord,V)
% function g = G(v_table,coord,V)
% Returns the g value for the V reading for the coord x,y,or z
% v_table [3x3]: with all the V readings for -1g, 0g, and 1g
% coord: 1,2,3 for x,y,z
% V: Voltage value to interpolate in readings
    g = interp1(v_table(:,coord),(-1:1),V,'linear','extrap');
end