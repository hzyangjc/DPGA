function selected = StochasticUniversalSampling(fitness,pop_size)
    [ind,~] = size(fitness);
    
    cumfit = cumsum(fitness);
    trials = cumfit(ind) / pop_size * (rand + (0:pop_size-1)');
    f = cumfit(:, ones(1, pop_size));
    t = trials(:, ones(1, ind))';
    [selected, ~] = find(t < f & [ zeros(1, pop_size); f(1:ind-1, :) ] <= t);
    
    [~, shuf] = sort(rand(pop_size, 1));
    selected = selected(shuf);
end