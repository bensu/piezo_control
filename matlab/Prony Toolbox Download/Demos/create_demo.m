close all;
clear all;
t=0:0.0005:0.1;
f1=4*exp(-100*t).*sin(2*pi*t*400);
f2=2*exp(-20*t).*sin(2*pi*t*200);
f3=1*exp(-50*t).*sin(2*pi*t*100);
% figure,plot(t,y);
% n1 = sin(2*pi*150*t);
% n2= 6*sin(2*pi*300*t);
% y1 = f1+f2+f3+n1+n2; 
% figure,plot(t,y1);
n=2*randn(1,201);
y2=f1+f2+f3+n;
plot(t,y2);


