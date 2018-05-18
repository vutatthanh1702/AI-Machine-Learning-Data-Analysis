function [ true, pre, Ac, Er ] = preNAR_EXP( x, dim, tau, FP, L_d )
%{
[Output]
    true: true value
    pre: prediction value
    Ac: Prediction Acuuracy ( correlation coefficient)
    Er: Prediction Error ( Normalized Mean Square Error )
[Input]
    x: time series data
    dim: embedding dimension
    tau: delay time
    FP: First Prediction time
    L_d: learning data
%}

[ tate, yoko ] = size( x );
if tate < yoko
    x = x';
end

L = length( x ) - FP + L_d;
pre = zeros( L, 1 );
true = zeros( L, 1 );
for t= 1:L
    true(t) = x( FP-L_d+t );
    if L_d>=t
        X = embed( x(t:FP-L_d+t-1), dim, tau );
        pre(t) = NAR_long(X(1:end-1,:),X(2:end,end),X(end,:));
    else
        X = embed( x(t-L_d:FP-L_d+t-1), dim, tau );
        pre(t) = NAR_long(X(1:end-1,:),X(2:end,end),X(end,:));
    end
end
Ac = soukan( true(L_d+1:end), pre(L_d+1:end) );
Er = seikika_gosa( true(L_d+1:end), pre(L_d+1:end) );