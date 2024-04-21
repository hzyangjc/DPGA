function [selected_indices] = TruncationSelection(fitness, selection, pop_size)
    sorted=sort(fitness);
    selected_indices=zeros(1,pop_size);
    for i=1:pop_size
        selected_indices(i)=find(fitness==sorted(pop_size-rem(i-1,selection)),1);
    end
end