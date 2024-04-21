n=90;
pop_size=200;
gens=150;
cross_rate=0.9;
mut_rate=0.3;

%初始化
pop=round(rand(pop_size,n).^12);
pop=logical(pop);                   % logical减小内存占用，可能提升效率
%适应度记录
prev_best_fit=zeros(gens,1);

pre_interp=zeros(1,90);

for gen=1:gens
    disp(['正在进行第',num2str(gen),'次迭代']);
    %评估
    fit_val=arrayfun(@(index) fitness(pop(index,:)),1:pop_size)';
    [best_fit,bestIdx]=max(fit_val);
    best_indiv=pop(bestIdx,:);
    
    %记录历史
    prev_best_fit(gen)=best_fit;
    disp(1/best_fit+400);

    %选择
    cumul_fit=cumsum(fit_val)/sum(fit_val);
    newpop=false(size(pop));
    for i=1:pop_size
        selected=rand();
        selected_index=find(cumul_fit>=selected,1);
        newpop(i,:)=pop(selected_index,:);
    end
    
    %交叉
    for i=1:2:pop_size
        if rand()<cross_rate
            cross_pnt=randi(n);
            newpop(i,1:cross_pnt)=newpop(i+1,1:cross_pnt);
            newpop(i+1,1:cross_pnt)=newpop(i,1:cross_pnt);
        end
    end
    
    %变异

    if gen==1
        mut_rate_ones=0.3*0.92;
        mut_rate_zeros=0.3*0.08;
    else
        mut_rate_zeros=mut_rate*sum(best_indiv)/n;
        mut_rate_ones=mut_rate-mut_rate_zeros;
    end
    for i=1:pop_size
        for j=1:n
            if newpop(i,j)==true && rand()<mut_rate_ones || newpop(i,j)==false && rand()<mut_rate_zeros
                newpop(i,j)=~newpop(i,j);
            end
        end
    end
    newpop(1,:)=best_indiv;
    
    %table=array2table(newpop);
    %writetable(table,'newpop.xlsx');
    %table=array2table(pop);
    %writematrix(pop,'pop.xlsx');
    %更新种群
    pop=newpop;
end

disp('最优选择：');
disp(find(best_indiv));
disp(['最低成本：' num2str(1/best_fit+400)]);