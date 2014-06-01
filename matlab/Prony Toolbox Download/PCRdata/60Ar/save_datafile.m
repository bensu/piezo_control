var=load('i1000.dat');
t_60Ar1000=var(:,1);
i_60Ar1000=var(:,2);
save('60Ar_i1000', 't_60Ar1000', 'i_60Ar1000')
load 60Ar_i1000
load i1000.dat
isequal(i1000(:,2),i_60Ar1000)
