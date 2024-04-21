function fitness=fitness(individual)
    % 只读取一次数据提高效率
    persistent data;
    if isempty(data)
        table=readtable("dataform_train2024.csv");
        data=table2array(table);
    end
    
    % 三次样条插值、多项式拟合
    datanum=2000;
    X=find(individual);
    len=length(X);
    if len<2
        fitness=0;
        return;
    end
    yi=data(2:2:2*datanum,1:90);
    y=data(2:2:2*datanum,X);
    V=zeros(datanum,90);
    for i=1:datanum
        V(i,:)=interp1(y(i,:),X,yi(i,:),'spline');
    end
    %table=array2table(Y);
    %writetable(table,"Y.csv");

    % 成本计算
    fitness=80*length(X);
    delta=abs(V-(1:90));
    s1=sum(sum(delta>0.5));
    s2=sum(sum(delta>1))*9;
    s3=sum(sum(delta>1.5))*20;
    s4=sum(sum(delta>2))*79970;
    fitness=fitness+(s1+s2+s3+s4)/datanum;
    fitness=1/(fitness-400);    % -400，突出优质个体的适应度优势，提高收敛速度

end