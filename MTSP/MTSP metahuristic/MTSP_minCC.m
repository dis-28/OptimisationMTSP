function [f,x]=MTSP_minCC(x)
[numSalesmen,numCities,~,~,numDays,adj_mat,maxVis]=MTSPdata;
x=round(x);
x=min(numDays,x);
x=max(1,x);

for i=1:numSalesmen
    x(1+(i-1)*numDays)=1;  %every salesman will start with depot city
end



%% Calculation of Revenue


domain_violation=0;
salesM_violation=0;
visited=zeros(numCities,1);
visited(1)=1;



%% calculation of total distance

TotalDistance=0;

for j=1:numSalesmen
    %calculation for total distance travelled by each salesman
    numVis=0;
    for i=2:numDays
        
        if x(i+(j-1)*numDays)==1
            TotalDistance=TotalDistance+adj_mat(x(i-1+(j-1)*numDays),1);

            for k=i+1:numDays
                x(k+(j-1)*numDays)=1;
            end
            break;
        end
        while visited(x(i+(j-1)*numDays))==1 && x(i+(j-1)*numDays)>1

            %it may happed that salesmen went to depot city afer completing
            %his tour so x(i)=1;
            x(i+(j-1)*numDays)=randi(numCities,1);
        end
        
        if x(i+(j-1)*numDays)==1
            TotalDistance=TotalDistance+adj_mat(x(i-1+(j-1)*numDays),1);

            for k=i+1:numDays
                x(k+(j-1)*numDays)=1;
            end
            break;
        end

        curVisCity=x(i+(j-1)*numDays);prevVisCity=x(i-1+(j-1)*numDays);
        if curVisCity<1 || curVisCity>numCities || prevVisCity<1 || prevVisCity>numCities
             domain_violation=10^5;
    
        else
            TotalDistance=TotalDistance+adj_mat(curVisCity,prevVisCity);
            if prevVisCity~=curVisCity
                numVis=numVis+1;
            end
        end
        
        visited(curVisCity)=1;
    end

    if numVis>maxVis
        salesM_violation=10^5;
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


%% Calcuation of fitness function
f=TotalDistance+(domain_violation+visitViolation+salesM_violation)*10^15;




