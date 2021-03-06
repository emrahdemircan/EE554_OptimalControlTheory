function [kp,ki,kd] = pidGenetic(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,populationSize,numberOfGenerations,Uj,Lj)
    persistent bestParent nextBestParent lastBestCost
    % genetic algorithm variables
    chromosomeLengthForKx = 10;
    % let there be at least 10 chromosomes in the population
    if populationSize < 10
        populationSize = 10;
    end
    elitistSelectionValue = 2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create the first popuation in random
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % an individual in the population is coded like |cost|KP|KI|KD|
    population = zeros(populationSize, 1 + 3*chromosomeLengthForKx);
    for ind=1:populationSize
        for gene=1:(3*chromosomeLengthForKx)
            % an individual is coded in binary form, 0s and 1s...
            population(ind,1+gene) = randi(2,1,1)-1;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % evaluate the population cost values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j_index=1:populationSize
        cost = evaluate_j_val(population(j_index,:),chromosomeLengthForKx,Uj,Lj,t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows);
        cost = 1/(1+cost);       
        population(j_index,1) = cost;
    end
    %sort the population in ascending order of cost cell
    sortedPopulation = sortrows(population,-1);
    % take last best results into consideration
    lastBestCost = sortedPopulation(1,1);
    bestParent = sortedPopulation(1,:);
    nextBestParent = sortedPopulation(2,:);
    fprintf('lastBestCost: %d\n',sortedPopulation(1,1));
    [kp,ki,kd] = evaluate_k(bestParent,chromosomeLengthForKx,Uj,Lj);
    fprintf('bestParent: KP:%d KI:%d KD:%d\n',kp,ki,kd);
    [kp,ki,kd] = evaluate_k(nextBestParent,chromosomeLengthForKx,Uj,Lj);
    fprintf('nextBestParent: KP:%d KI:%d KD:%d\n',kp,ki,kd);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Begin GA iterations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for generation=1:numberOfGenerations
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % selection by truncation: get n best valued chromosomes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        population = zeros(populationSize, 1 + 3*chromosomeLengthForKx);
        for select=1:elitistSelectionValue
            population(select,:) = sortedPopulation(select,:);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % regenerate from best 2 selected parents
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for ind=elitistSelectionValue+1:populationSize
            population(ind,:) = sortedPopulation(1,:);
            crossoverPointStart = randi(3*chromosomeLengthForKx-1,1,1);
            crossoverPointEnd = crossoverPointStart + randi(3*chromosomeLengthForKx-crossoverPointStart,1,1);            
            for co=crossoverPointStart:crossoverPointEnd
                population(ind,1+co) = population(2,1+co);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % insert mutation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for ind=1:populationSize
            % there can be at most 4 mutations which is probabilistic!
            mutationNumber = randi(4,1,1);
            for n=1:mutationNumber
                % same mutation point can be selected more than once,
                % probability.
                mutationPoint = randi(3*chromosomeLengthForKx,1,1);
                if population(ind,1+mutationPoint) == 1
                    population(ind,1+mutationPoint) = 0;
                else
                    population(ind,1+mutationPoint) = 1;
                end
            end
        end        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % evaluate the population cost values
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j_index=1:populationSize
            cost = evaluate_j_val(population(j_index,:),chromosomeLengthForKx,Uj,Lj,t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows);
            cost = 1/(1+cost); 
            population(j_index,1) = cost;
        end
        %sort the population in ascending order of cost cell
        sortedPopulation = sortrows(population,-1);
        fprintf('Generation:%d Best Cost: %d\n',generation,sortedPopulation(1,1));
        % get the best chromosomes and convert to kp/ki/kd
        [kp,ki,kd] = evaluate_k(sortedPopulation(1,:),chromosomeLengthForKx,Uj,Lj);
        fprintf('KP:%d KI:%d KD:%d\n',kp,ki,kd);
        % if last results are not better than the previous generation
        % return back to the previous generation and parents
        if lastBestCost < sortedPopulation(1,1)
            fprintf('This generation is not better than the previous-> lastBestCost%d Best Cost: %d\n',lastBestCost,sortedPopulation(1,1));
            sortedPopulation(1,:) = bestParent;
            sortedPopulation(2,:) = nextBestParent;
        else
            % change the best results here
            fprintf('This generation is better than the previous-> lastBestCost%d Best Cost: %d\n',lastBestCost,sortedPopulation(1,1));
            lastBestCost = sortedPopulation(1,1);
            bestParent = sortedPopulation(1,:);
            nextBestParent = sortedPopulation(2,:);
        end
    end
end % function [kp,ki,kd] = pidGenetic(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,populationSize,numberOfGenerations)

% function to evaluate kp ki kd values from chromosome arrays
function [kp_val,ki_val,kd_val] = evaluate_k(k_cromosome,chromosomeLengthForKx,Uj,Lj)
    k_upperLimit = Uj;
    k_lowerLimit = Lj;
    k_delta = k_upperLimit - k_lowerLimit;
    [~,col] = size(k_cromosome);
    % last part of chromosome is KD
    kd_val = 0.0;
    for c=col:-1:(col-chromosomeLengthForKx+1)
        kd_val = kd_val + (2^(col-c))*k_cromosome(c);
    end
    kd_val = k_lowerLimit + k_delta*kd_val/(2^chromosomeLengthForKx);
    % KI is in the middle of the chromosome
    col = col-chromosomeLengthForKx;
    ki_val = 0.0;
    for c=col:-1:(col-chromosomeLengthForKx+1)
        ki_val = ki_val + (2^(col-c))*k_cromosome(c);
    end
    ki_val = k_lowerLimit + k_delta*ki_val/(2^chromosomeLengthForKx);    
    % KI is in the middle of the chromosome
    col = col-chromosomeLengthForKx;
    kp_val = 0.0;
    for c=col:-1:(col-chromosomeLengthForKx+1)
        kp_val = kp_val + (2^(col-c))*k_cromosome(c);
    end
    kp_val = k_lowerLimit + k_delta*kp_val/(2^chromosomeLengthForKx);    
end % function [kp_val,ki_val,kd_val] = evaluate_k(k_cromosome,chromosomeLengthForKx)

% function to evaluate the cost with given k chromosomes
function j_val = evaluate_j_val(k_chromosome,chromosomeLengthForKx,Uj,Lj,t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows)
    [KP,KI,KD] = evaluate_k(k_chromosome,chromosomeLengthForKx,Uj,Lj);
    [~,~,j_val] = aqm_sim(t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows,3,KP,KI,KD);
end % function j_val = evaluate_j_val(k_chromosome,chromosomeLengthForKx,t0,tf,linkCapacity,desiredQueueLength,maxQueueLength,numberOfFlows)