function vtp = local(y,k,Step)
%%%% 非線形予測法(ローレンツ類推法)のプログラム. 教科書 式(5.5.3)

% y は埋め込み後の多次元ベクトル (例) y=embed(x,3,1)など．
% k は近傍数．k=埋め込み次元dim+1 などが定番．
% Step は予測ステップ数．もし10なら10ステップ先の将来値を予測する．
 
% (使用例)
% x=logis(1000,4);
% dim=3; tau=1; y=embed(x,dim,tau);
% Predicted_y = local(y,dim+1,1)% Mは近傍数
 
for i=1:Step 
    
    kinbou=kinboubangou(y,k);
    if k > 1
        vtp=sum(y(kinbou(1:k)+1,:))/k;
    elseif k==1
        vtp=y(kinbou(1)+1,:);
    end
  
    y = [y;vtp];
end

end


function [kinboubangou,ZZ]=kinboubangou(y,kosuu)
    [n,yoko]=size(y);
    A=y(n,:);
    if yoko>1
        LL=sum(((y(1:n-1,:)-A(ones(1,n-1),(1:yoko)')).^2)');
        [z,l]=sort(LL);
        kinboubangou=l(1:kosuu)';
        ZZ=sqrt(z(1:kosuu))';
    elseif yoko==1
        LL=(y(1:n-1,:)-A(ones(1,n-1),(1:yoko)')).^2;
        [Z,l]=sort(LL);    
        kinboubangou=l(1:kosuu);
        ZZ=sqrt(Z(1:kosuu));
    end
end