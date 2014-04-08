%a = arduino('/dev/ttyS101');

N = 40;
clear acc
clear t
t = zeros(N,1);
acc = zeros(N,3);
tic
elapsed_time = toc;
i = 1;
while (elapsed_time < 1)
    elapsed_time = toc;
	t(i) = elapsed_time;
    acc(i,1) = a.analogRead(0);
    acc(i,2) = a.analogRead(1);
    acc(i,3) = a.analogRead(2);
    i = i + 1;
end

run static_data
V = interp1([0 1023],[0 3.3],mean(acc));
g = zeros(size(V));
for coord = 1:3
    g(coord) = G(v_table,coord,V(coord));
end

norm(g)
g

