%%%%%%% �𰸼������ 2024-3-12 %%%%%%%% 
clear;
my_answer=[6 20 30 45 60 74 84];%�����ѡ�������д�ڴ�
my_answer_n=size(my_answer,2);

% ��׼����ԭʼ���ݶ���
minput=dlmread('dataform_train2024.csv');
[M,N]=size(minput);
Nsample=M/2; Npoint=N;
volt=zeros(Nsample,Npoint);
tempr=zeros(Nsample,Npoint);
est_tempr=zeros(Nsample,Npoint);
for i=1:Nsample
    volt(i,:)=minput(2*i,:);
    tempr(i,:)=minput(2*i-1,:);
end

% �������
for sample=1:Nsample
    premea_volt=volt(sample,my_answer);
    premea_tempr=tempr(sample,my_answer);
    % �����Ķ�����㷽��д�뺯��mycurvefitting
    est_tempr(sample,:)=my_spline(premea_volt,premea_tempr,volt(sample,:));
end

    
% �ɱ�����
Q=80;
errabs=abs(tempr-est_tempr);

le0_5=(errabs<=0.5);
le1_0=(errabs<=1.0);
le1_5=(errabs<=1.5);
le2_0=(errabs<=2);
g2_0=(errabs>2);

sij=1*(le1_0-le0_5)+10*(le1_5-le1_0)+30*(le2_0-le1_5)+80000*g2_0;
si=sum(sij,2)+Q*ones(Nsample,1)*length(my_answer);
cost=sum(si)/Nsample;

% ��ʾ���
fprintf('\n�����㣬��Ĵ𰸶�Ӧ������ɱ�Ϊ%5.2f\n',cost);