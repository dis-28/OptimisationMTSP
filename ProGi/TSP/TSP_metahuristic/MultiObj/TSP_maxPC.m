function [f,x]=TSP_maxPC(x)
x(1)=1;
[numCities,SP,travelCost,numDays,adj_mat,pop_mat]=TSPdata;

%% Calculation of Revenue
x=round(x);
x=min(numDays,x);
x=max(1,x);
Revenue=zeros(numDays,1);
domain_violation=zeros(numDays,1);

visited=zeros(numCities,1);
visit_violation=zeros(numCities,1);


for i=1:numDays
     

    x(i)=round(x(i));
    
    while visited(x(i))==1
        x(i)=randi(numCities,1);
    end
    visitingCity=x(i);

    numPeople=pop_mat(visitingCity,i);
    Revenue(i)=SP*numPeople;
    visited(visitingCity)=1;
end

%% calculation of total distance

TotalDistance=0;

for i=2:numDays
     
    curVisCity=x(i);prevVisCity=x(i-1);
    if curVisCity<1 || curVisCity>numCities || prevVisCity<1 || prevVisCity>numCities
         domain_violation(i)=10^5;

    else
        TotalDistance=TotalDistance+adj_mat(curVisCity,prevVisCity);


    end
end

TotalDistance=TotalDistance+adj_mat(x(numCities),x(1));
TotalCost=travelCost*TotalDistance;
%% Calcuation of fitness function
profit=sum(Revenue)-TotalCost;
f=-profit;



