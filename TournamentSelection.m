function [selected_indices] = TournamentSelection(fitness, tournamentSize, numSelected)
    populationSize = length(fitness);
    selected_indices = zeros(1, numSelected);
    
    for i = 1:numSelected
        tournamentContestants = randperm(populationSize, tournamentSize);
        [~, bestIndex] = max(fitness(tournamentContestants));
        winner = tournamentContestants(bestIndex);
        selected_indices(i) = winner;
    end
end