function [f,x]=MTSP_minCC(x)
[numSalesmen,numCities,~,travelCost,numDays,adj_mat]=MTSPdata;
for i=1:numSalesmen
    x(1+(i-1)*numDays)=1;  %every salesman will start with depot city
end



%% Calculation of Revenue


domain_violation=0;

visited=zeros(numCities,1);
visited(1)=1;



%% calculation of total distance

TotalDistance=0;

for j=1:numSalesmen
    %calculation for total distance travelled by each salesman

    for i=2:numDays
        x(i+(j-1)*numDays)=round(x(i+(j-1)*numDays));
        x(i+(j-1)*numDays)=min(x(i+(j-1)*numDays),numCities);
        x(i+(j-1)*numDays)=max(x(i+(j-1)*numDays),1);
        if x(i+(j-1)*numDays)==1
            %salesmen has completed its journey
            continue;
        end
        while visited(x(i+(j-1)*numDays))==1 && x(i+(j-1)*numDays)>1

            %it may happed that salesmen went to depot city afer completing
            %his tour so x(i)=1;
            x(i+(j-1)*numDays)=randi(numCities,1);
        end
    
        curVisCity=x(i+(j-1)*numDays);prevVisCity=x(i-1+(j-1)*numDays);
        if curVisCity<1 || curVisCity>numCities || prevVisCity<1 || prevVisCity>numCities
             domain_violation=10^5;
    
        else
            TotalDistance=TotalDistance+adj_mat(curVisCity,prevVisCity);
        end
    
        visited(curVisCity)=1;
    end
end

for i=1:numSalesmen
    %returning of every slaesmen to depot city
    TotalDistance=TotalDistance+adj_mat(x(numDays+(i-1)*numDays),1);
end
visitViolation=0;

for i=1:numCities
    %all city has to be visited exaclty once
    if visited(i)==0
        visitViolation=10^5;
    end
end

TotalCost=travelCost*TotalDistance+(domain_violation+visitViolation)*10^15;
%% Calcuation of fitness function
f=TotalCost;




