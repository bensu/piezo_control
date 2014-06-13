function first_noise = find_noise(cut_off,max_count,g)
index = find(abs(g) < cut_off);
d_index = diff(index);
count = 0;
for i = 1:length(d_index)
    if d_index(i) == 1
        count = count + 1;
    else
        count = 0;
    end
    if count > max_count
        break
    end
end

first_noise = index(i);
end