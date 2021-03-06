% Solve an Autoregression Time-Series Problem with a NAR Neural Network
% Script generated by NTSTOOL
% Created Wed Nov 26 16:05:48 JST 2014
%
% This script assumes this variable is defined:
%
%   simplenarTargets - feedback time series.
%setdemorandstream(491218381);
%{
OD=pairs_table(2:end,:);
OR = diff(OD)./OD(1:end-1,:);
tim=OR(end-1609+1:end)';
%}

load stock_price_table
OD=stock_price_table(2:end,:);
OR = diff(OD)./OD(1:end-1,:);
time=10;
%RR=zeros(200,1);
x_i=631;
while 1
tim=OR(:,x_i);
R1=zeros(time,1);
R0=zeros(time,1);
R=zeros(time,1);
savedState=cell(time,1);
%nets=cell(time,1);
for i=1:time
    tic
stream = RandStream.getGlobalStream;
savedState{i} = stream.State;


x = num2cell(tim,4001)';
t=x;
targetSeries = x(1:1200);
test=x(1201:end);
% Create a Nonlinear Autoregressive Network
feedbackDelays = 1:3;
hiddenLayerSize = 10;
net = narnet(feedbackDelays,hiddenLayerSize);

% Choose Feedback Pre/Post-Processing Functions
% Settings for feedback input are automatically applied to feedback output
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};

% Prepare the Data for Training and Simulation
% The function PREPARETS prepares timeseries data for a particular network,
% shifting time by the minimum amount to fill input states and layer states.
% Using PREPARETS allows you to keep your original time series data unchanged, while
% easily customizing it for networks with differing numbers of delays, with
% open loop or closed loop feedback modes.
[inputs,inputStates,layerStates,targets] = preparets(net,{},{},targetSeries);

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'divideblock';  % Divide data randomly
net.divideMode = 'time';  % Divide up every value
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;

% Choose a Training Function
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainbr';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'msereg';  % Mean squared error
net.trainParam.showWindow = false;
% Choose Plot Functions
% For a list of all plot functions type: help nnplot
%net.plotFcns = {'plotperform','plottrainstate','plotresponse', ...
%  'ploterrcorr', 'plotinerrcorr'};


% Train the Network
[net,tr] = train(net,inputs,targets,inputStates,layerStates,'useParallel','yes','useGPU','only','showResources','yes');

% Test the Network
outputs = net(inputs,inputStates,layerStates);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% Recalculate Training, Validation and Test Performance
trainTargets = gmultiply(targets,tr.trainMask);
valTargets = gmultiply(targets,tr.valMask);
testTargets = gmultiply(targets,tr.testMask);
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)
[r0,m0,b0] = regression(cell2mat(testTargets),cell2mat(outputs));
%[r,m,b] = regression(cell2mat(valTargets),cell2mat(outputs));
R0(i)=r0;
%R(i)=r;
% View the Network
%view(net);

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotresponse(targets,outputs)
%figure, ploterrcorr(errors)
%figure, plotinerrcorr(inputs,errors)

% Closed Loop Network
% Use this network to do multi-step prediction.
% The function CLOSELOOP replaces the feedback input with a direct
% connection from the outout layer.
%{
netc = closeloop(net);
[xc,xic,aic,tc] = preparets(netc,{},{},targetSeries);
yc = netc(xc,xic,aic);
perfc = perform(net,tc,yc)
%}
% Early Prediction Network
% For some applications it helps to get the prediction a timestep early.
% The original network returns predicted y(t+1) at the same time it is given y(t+1).
% For some applications such as decision making, it would help to have predicted
% y(t+1) once y(t) is available, but before the actual y(t+1) occurs.
% The network can be made to return its output a timestep early by removing one delay
% so that its minimal tap delay is now 0 instead of 1.  The new network returns the
% same outputs as the original network, but outputs are shifted left one timestep.
nets = removedelay(net);

[xs,xis,ais,ts] = preparets(nets,{},{},test);
ys = nets(xs,xis,ais);
%plotresponse(ts(end-10:end),ys(end-10:end));
R1(i)=soukan(cell2mat(ts(1:240-1)),cell2mat(ys(1:240-1)));

save (sprintf('nets_%02d',i), 'nets') ;
%delete(sprintf('nets_%02d',i-1));

toc
end

[zcx,Sort_NAR] = sort( R1, 'descend' );
%load(sprintf('nets_%02d',Sort_NAR(1)));
%s=what('Work');
%s.path;
for i=1:time-1
    delete(sprintf('nets_%02d.mat',Sort_NAR(1+i)));
end
%stream.State=savedState{Sort_NAR(1)};
movefile(sprintf('nets_%02d.mat',Sort_NAR(1)),sprintf('nets%02d.mat',x_i));
RR(x_i)=zcx(1);
zcx=[];
Sort_NAR=[];
x_i=x_i+1;
end
