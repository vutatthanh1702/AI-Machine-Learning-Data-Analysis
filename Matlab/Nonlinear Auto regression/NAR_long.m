function [ vtp, A ] = NAR_long( X, Y, X_END )
%[�ߒl]
% vtp: �\���l
% A: ����W���s��
%[���l]
% X: �Ɨ��ϐ�
% Y: �]���ϐ�
% X_END: ��W���x�N�g��

Low = size( X, 1 ); %�c�̃T�C�Y
[NN, Euc ] = kinboubangou( [X;X_END], Low ); %�ߖT�ԍ��Ƌ����̒��o
W = diag(exp(-Euc)); %���d�s��̍쐬
X2 = W*[X( NN, : ),ones(Low,1)]; %���d�Ɨ��ϐ��s��
Y = W*Y( NN ); %���d�]���ϐ�
A = X2\Y; %�W������(�ŏ����@)
vtp = [X_END,1]*A; %�\���l