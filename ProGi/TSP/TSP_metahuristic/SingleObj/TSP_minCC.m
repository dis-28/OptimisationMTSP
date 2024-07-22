function [f,x]=TSP_minCC(x)
x(1)=1;
[numCities,~,~,numDays,adj_mat]=TSPdata;

%% Calculation of Revenue


domain_violation=zeros(numDays,1);

visited=zeros(numCities,1);




%% calculation of total distance

TotalDistance=0;
x(1)=round(x(1));
visited(x(1))=1;
for i=2:numDays
     
    x(i)=round(x(i));
    x(i)=min(numCities,x(i));
    x(i)=max(1,x(i));

    while visited(x(i))==1
        x(i)=randi(numCities,1);
    end

    curVisCity=x(i);prevVisCity=x(i-1);
    if curVisCity<1 || curVisCity>numCities || prevVisCity<1 || prevVisCity>numCities
         domain_violation(i)=10^5;
    else
        curVisCity=x(i);prevVisCity=x(i-1);
        TotalDistance=TotalDistance+adj_mat(curVisCity,prevVisCity);
    end

    visited(curVisCity)=1;
end

TotalDistance=TotalDistance+adj_mat(x(numCities),x(1));



%% Calcuation of fitness function
f=TotalDistance;




