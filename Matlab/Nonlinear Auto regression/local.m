function vtp = local(y,k,Step)
%%%% ����`�\���@(���[�����c�ސ��@)�̃v���O����. ���ȏ� ��(5.5.3)

% y �͖��ߍ��݌�̑������x�N�g�� (��) y=embed(x,3,1)�ȂǁD
% k �͋ߖT���Dk=���ߍ��ݎ���dim+1 �Ȃǂ���ԁD
% Step �͗\���X�e�b�v���D����10�Ȃ�10�X�e�b�v��̏����l��\������D
 
% (�g�p��)
% x=logis(1000,4);
% dim=3; tau=1; y=embed(x,dim,tau);
% Predicted_y = local(y,dim+1,1)% M�͋ߖT��
 
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