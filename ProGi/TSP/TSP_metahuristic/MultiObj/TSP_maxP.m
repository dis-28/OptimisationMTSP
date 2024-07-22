function [f,x]=TSP_maxP(x)
x(1)=1;
[numCities,SP,travelCost,numDays,adj_mat,pop_mat]=TSPdata;

%% Calculation of Revenue

Revenue=zeros(numDays,1);
domain_violation=zeros(numDays,1);

visited=zeros(numCities,1);
visit_violation=zeros(numCities,1);

% Here the decision varaible is n*1 matrix where the i depicts the ith day
% x(i) city got visited by the salesman
for i=1:numDays
     

    x(i)=round(x(i));  %as day and city has to be whole number
    
    visitingCity=x(i);
    if visitingCity>=1 && visitingCity <=numDays   

        if visited(visitingCity)==1  % cannot visit the same city twice

         visit_violation(i)=10^5;
        else
    
        numPeople=pop_mat(visitingCity,i);  %number of buyer in that city on ith perticular day
        Revenue(i)=SP*numPeople;            %revenue numbe rof people buying the product
        visited(visitingCity)=1;            %mark that city as visited
        end
    else
        domain_violation(i)=10^5;           % the decision variable are only allowed form 1 to numCities
    end
end

%% calculation of total distance

TotalDistance=0;

for i=2:numDays
     
    curVisCity=x(i);prevVisCity=x(i-1);
    if curVisCity<1 || curVisCity>numCities || prevVisCity<1 || prevVisCity>numCities
         domain_violation(i)=10^5;

    else
        TotalDistance=TotalDistance+adj_mat(curVisCity,prevVisCity);  %since on the ith day the salesman will travel from prevCity to the current city


    end
end

TotalDistance=TotalDistance+adj_mat(x(numCities),x(1)); %this also includes the distance of returning from last location to first
TotalCost=travelCost*TotalDistance;
%% Calcuation of fitness function
profit=sum(Revenue)-TotalCost;  
f=-profit+10^15*(sum(domain_violation)+sum(visit_violation));



