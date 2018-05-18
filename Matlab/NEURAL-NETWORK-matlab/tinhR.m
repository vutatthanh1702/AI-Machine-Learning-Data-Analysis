load stock_price_table
OD=stock_price_table(2:end,:);
OR = diff(OD)./OD(1:end-1,:);
time=10;
kabunum=664;
R1=zeros(kabunum,1);
true_NAR=zeros(407-1,kabunum);
pre_NAR=zeros(407-1,kabunum);
x_i=375
while 1
    x_i
    try
        tim=OR(:,x_i);

        x = num2cell(tim,4001)';
        t=x;
        targetSeries = x(1:1200);
        test=x(1201:end);
        load(sprintf('nets%02d',x_i));
        [xs,xis,ais,ts] = preparets(nets,{},{},test);
        ys = nets(xs,xis,ais);
        %plotresponse(ts(end-10:end),ys(end-10:end));
        true_NAR(:,x_i)=cell2mat(ts(1:end-1))';
        pre_NAR(:,x_i)=cell2mat(ys(1:end-1))';
        R1(x_i)=soukan(cell2mat(ts(1:240-1)),cell2mat(ys(1:240-1)));
    catch
    end
x_i=x_i+1;
if x_i==kabunum
    break;
end
end
%[zcx,Sort_NAR] = sort( R1, 'descend' );