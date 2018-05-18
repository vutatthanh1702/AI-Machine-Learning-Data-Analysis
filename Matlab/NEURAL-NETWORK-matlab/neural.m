x = num2cell(tim,4001)';
t=x;
net = narxnet(1:4,1:4,10);
[Xs,Xi,Ai,Ts] = preparets(net,x,{},t);
[net,tr] = train(net,Xs,Ts,Xi,Ai);
Y = net(Xs,Xi,Ai);
perf = mse(net,Ts,Y)
net3 = removedelay(net);
[Xs,Xi,Ai,Ts] = preparets(net3,x,{},t);
Y = net3(Xs,Xi,Ai);
plotresponse(Ts(end-10:end),Y(end-10:end))