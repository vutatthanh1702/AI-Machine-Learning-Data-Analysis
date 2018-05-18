function [kinboubangou,ZZ]=kinboubangou(y,kosuu)

[n,yoko]=size(y);

A=y(n,:);
B=A(ones(1,n-1),(1:yoko)');

LL=sum(((y(1:n-1,:)-B).^2)');
   
[Z,I]=sort(LL)

kinboubangou=I(1:kosuu)'
ZZ=sqrt(Z(1:kosuu))'
