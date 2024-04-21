%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                  %
%  5代内平均成本看不出明显的单调递减  %
%      但本算法确实可以正常得解      %
%  实际上，平均成本理论上不应当作为   %
%       种群质量的主要评价指标       %
%                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
n=90;
pop_size=20;
gens=5;

%初始化
pop1=round(rand(pop_size,n).^15);
pop2=round(rand(pop_size,n).^15);
pop1=logical(pop1);                   % logical减小内存占用，可能提升效率
pop2=logical(pop2);
%适应度记录
prev_best_fit=zeros(gens,1);
prev_avg_cost=zeros(gens,1);

for gen=1:gens
    disp(['正在进行第',num2str(gen),'次迭代']);
    %评估
    fit_val1=arrayfun(@(index) fitness(pop1(index,:)),1:pop_size)';
    [best_fit1,bestIdx1]=max(fit_val1);
    best_indiv1=pop1(bestIdx1,:);
    fit_val2=arrayfun(@(index) fitness(pop2(index,:)),1:pop_size)';
    [best_fit2,bestIdx2]=max(fit_val2);
    best_indiv2=pop2(bestIdx2,:);
    
    %记录历史
    prev_best_fit(gen)=max(best_fit1,best_fit2);
    disp("当前两种群分别最低成本：");
    disp([1/best_fit1+400,1/best_fit2+400]);
    newpop1=false(size(pop1));
    newpop2=false(size(pop2));
    %选择
    %轮盘赌
    cumul_fit=cumsum(fit_val1)/sum(fit_val1);
    for i=1:pop_size
        selected=rand();
        selected_index=find(cumul_fit>=selected,1);
        newpop1(i,:)=pop1(selected_index,:);
    end
    cumul_fit=cumsum(fit_val2)/sum(fit_val2);
    for i=1:pop_size
        selected=rand();
        selected_index=find(cumul_fit>=selected,1);
        newpop2(i,:)=pop2(selected_index,:);
    end
    %锦标赛
    % selected_index1=TournamentSelection(fit_val1,3,pop_size);
    % selected_index2=TournamentSelection(fit_val2,3,pop_size);
    %截断选择
    % selected_index1=TruncationSelection(fit_val1,15,pop_size);
    % selected_index2=TruncationSelection(fit_val2,15,pop_size);
    %随机遍历选择
    % selected_index1=StochasticUniversalSampling(fit_val1,pop_size);
    % selected_index2=StochasticUniversalSampling(fit_val2,pop_size);
    % for i=1:pop_size
    %     newpop1(i,:)=pop1(selected_index1(i),:);
    % end
    % for i=1:pop_size
    %     newpop2(i,:)=pop2(selected_index2(i),:);
    % end
    
    %交叉
    f_avg1=mean(fit_val1);
    f_avg2=mean(fit_val2);
    prev_avg_cost(gen)=2/(f_avg2+f_avg1)+400;
    disp("总平均成本：");
    disp([num2str(prev_avg_cost(gen))]);
    fprintf('\n');
    for i=1:2:pop_size
        if min(fit_val1(i),fit_val1(i+1))<f_avg1
            cross_rate=1;
        else
            cross_rate=1-0.2*(fit_val1(i)-f_avg1)/(best_fit1-f_avg1);
        end
        if rand()<cross_rate
            t1=randi(n);t2=randi(n);
            cross_pnt_left=min(t1,t2);
            cross_pnt_right=max(t1,t2);
            newpop1(i,cross_pnt_left:cross_pnt_right)=newpop1(i+1,cross_pnt_left:cross_pnt_right);
            newpop1(i+1,cross_pnt_left:cross_pnt_right)=newpop1(i,cross_pnt_left:cross_pnt_right);
        end
        if min(fit_val2(i),fit_val2(i+1))<f_avg2
            cross_rate=1;
        else
            cross_rate=1-0.2*(fit_val2(i)-f_avg2)/(best_fit2-f_avg2);
        end
        if rand()<cross_rate
            t1=randi(n);t2=randi(n);
            cross_pnt_left=min(t1,t2);
            cross_pnt_right=max(t1,t2);
            newpop2(i,cross_pnt_left:cross_pnt_right)=newpop2(i+1,cross_pnt_left:cross_pnt_right);
            newpop2(i+1,cross_pnt_left:cross_pnt_right)=newpop2(i,cross_pnt_left:cross_pnt_right);
        end
    end
    
    %变异
    if gen==1
        mut_rate_ones=0.92;
        mut_rate_zeros=0.08;
    else
        mut_rate_zeros=sum(best_indiv1)/n;
        mut_rate_ones=1-mut_rate_zeros;
    end
    for i=1:pop_size
        if fit_val1(i)<f_avg1
            mut_rate=0.05*n/2/sum(best_indiv1);
        else
            mut_rate=(0.05-0.03*(fit_val1(i)-f_avg1)/(best_fit1-f_avg1))*n/2/sum(best_indiv1);
        end
        for j=1:n
            if newpop1(i,j)==true && rand()<mut_rate*mut_rate_ones || newpop1(i,j)==false && rand()<mut_rate*mut_rate_zeros
                newpop1(i,j)=~newpop1(i,j);
            end
        end
    end
    newpop1(1,:)=best_indiv1;

    if gen==1
        mut_rate_ones=0.92;
        mut_rate_zeros=0.08;
    else
        mut_rate_zeros=sum(best_indiv2)/n;
        mut_rate_ones=1-mut_rate_zeros;
    end
    for i=1:pop_size
        if fit_val2(i)<f_avg2
            mut_rate=0.05*n/2/sum(best_indiv2);
        else
            mut_rate=(0.05-0.03*(fit_val2(i)-f_avg2)/(best_fit2-f_avg2))*n/2/sum(best_indiv2);
        end
        for j=1:n
            if newpop2(i,j)==true && rand()<mut_rate*mut_rate_ones || newpop2(i,j)==false && rand()<mut_rate*mut_rate_zeros
                newpop2(i,j)=~newpop2(i,j);
            end
        end
    end
    newpop2(1,:)=best_indiv2;
    
    %移民
    if rem(gen,3)==0
        newpop2(find(fit_val2==min(fit_val2),1),:)=best_indiv1;
        newpop1(find(fit_val1==min(fit_val1),1),:)=best_indiv2;
    end

    %table=array2table(newpop);
    %writetable(table,'newpop.xlsx');
    %table=array2table(pop);
    %writematrix(pop,'pop.xlsx');
    %更新种群
    pop1=newpop1;
    pop2=newpop2;
end

disp('最优选择：');
if best_fit1>best_fit2
    best_indiv=best_indiv1;
    cost=1/best_fit1+400;
else
    best_indiv=best_indiv2;
    cost=1/best_fit2+400;
end
disp(find(best_indiv));
disp(['最低成本：' num2str(cost)]);
prev_low_cost=1./prev_best_fit+400;
%table=array2table(prev_low_cost);
%writetable(table,'选择-SUS.xlsx');
x=1:gens;
plot(x,prev_low_cost,'-*b',x,prev_avg_cost,'-or');
axis([0,6,400,2400])
set(gca,'XTick',0:1:6)
set(gca,'YTick',400:400:2400)
legend('最低成本','平均成本');
xlabel('x')
ylabel('y')