function [ vtp, A ] = NAR_long( X, Y, X_END )
%[戻値]
% vtp: 予測値
% A: 推定係数行列
%[引値]
% X: 独立変数
% Y: 従属変数
% X_END: 被係数ベクトル

Low = size( X, 1 ); %縦のサイズ
[NN, Euc ] = kinboubangou( [X;X_END], Low ); %近傍番号と距離の抽出
W = diag(exp(-Euc)); %加重行列の作成
X2 = W*[X( NN, : ),ones(Low,1)]; %加重独立変数行列
Y = W*Y( NN ); %加重従属変数
A = X2\Y; %係数推定(最小二乗法)
vtp = [X_END,1]*A; %予測値