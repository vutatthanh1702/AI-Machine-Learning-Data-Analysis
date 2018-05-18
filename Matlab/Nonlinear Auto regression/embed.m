function v=embed(y,dim,lag)
[n,c]=size(y);
if n<c
    y=y';[n,c]=size(y);
end

if n<lag*(dim-1)+1
    error('too small to be embedded with the given lag and dimention.');
end

m=n-(dim-1 )*lag;
v=zeros(m,c*dim);
count=0;
for ii=1:dim
    jj=(ii-1)*lag;
    for ci=1:c
        v(:,c*(ii-1)+ci)=y(jj+1:jj+m,ci);
    end
end
