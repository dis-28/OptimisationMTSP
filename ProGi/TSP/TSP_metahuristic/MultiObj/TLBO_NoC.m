

function [bestsol,BestFitIter,bestfitness,P,f]=TLBO_NoC(Np,T,lb,ub,prob)
[numCities,~,~,~,~,~]=TSPdata;

f = NaN(Np,1);                      % Vector to store the fitness function value of the population members
BestFitIter = NaN(T+1,1);           % Vector to store the best fitness function value in every iteration
D = length(lb);                     % Determining the number of decision variables in the problem
P = randi(numCities,Np,numCities);   % Generation of the initial population


for p = 1:Np
    [f(p),P(p,:)] = prob(P(p,:));            % Evaluating the fitness function of the initial population
end
BestFitIter(1) = min(f);

for t = 1: T
    
    for i = 1:Np

        Xmean = mean(P);            % Determining mean of the population
        

        [~,ind] = min(f);           % Detemining the location of the teacher
        Xbest = P(ind,:);           % Copying the solution acting as teacher
        
        TF = randi([1 2],1,1);      % Generating either 1 or 2 randomly for teaching factor
        
        Xnew = P(i,:) + rand(1,D).*(Xbest - TF*Xmean);  % Generating the new solution
        


        Xnew = min(ub, Xnew);       % Bounding the violating variables to their upper bound
        Xnew = max(lb, Xnew);       % Bounding the violating variables to their lower bound
        
        [fnew,Xnew] = prob(Xnew);          % Evaluating the fitness of the newly generated solution
        
        if (fnew < f(i))            % Greedy selection
            P(i,:) = Xnew;          % Include the new solution in population
            f(i) = fnew;            % Include the fitness function value of the new solution in population
        end
        
        

        
        p = randi([1 Np],1,1);      % Selection of random parter
        
        
        while i == p
            p = randi([1 Np],1,1);  % Selection of random parter
        end
        
        if f(i)< f(p)    % Select the appropriate equation to be used in Learner phase
            Xnew = P(i,:) + rand(1, D).*(P(i,:) - P(p,:));  % Generating the new solution
        else
            Xnew = P(i,:) - rand(1, D).*(P(i,:) - P(p,:));  % Generating the new solution
        end


        Xnew = min(ub, Xnew);       % Bounding the violating variables to their upper bound
        Xnew = max(lb, Xnew);       % Bounding the violating variables to their lower bound
        
        [fnew,Xnew] = prob(Xnew);          % Evaluating the fitness of the newly generated solution
        
        if (fnew < f(i))            % Greedy selection
            P(i,:) = Xnew;          % Include the new solution in population
            f(i) = fnew;            % Include the fitness function value of the new solution in population
        end
        
    end
    
    BestFitIter(t+1) = min(f);      % Storing the best value of each iteration
end
[bestfitness,ind] = min(f);
bestsol = P(ind,:);