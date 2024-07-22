clc
clear all


[numSalesmen,numCities,SP,travelCost,numDays,adj_mat]=MTSPdata;  %taking data from the data file

Np=50;T=100;NRuns=5;  %setting problem parameters
Pc=0.8;F=0.85;
w=1.7;c1=1.5;c2=1.5;
limit=100;
etac=20;etam=21;pc=0.8;pm=0.3;
probC=@MTSP_minCC;    %function handle for caluclulating maxProfit with correction


lb=ones(1,numCities*numSalesmen);                 %declaring limit on population with lowerbound and upper bound
ub=ones(1,numCities*numSalesmen)*numCities;





bestfitness=NaN(NRuns,5);



for i=1:NRuns
    %employing TLBO meta huristic technique
    rng(i,"twister");
    [bestSolTLBO(i,:),~,bestfitness(i,1),~,~]=TLBO_NoC(Np,T,lb,ub,probC);
    

    rng(i,"twister");
    [bestSolDE(i,:),bestfitness(i,2),~,~,~]=DifferentialEvolution(probC,lb,ub,Np,T,Pc,F);
    %employing PSO meta huristic technique

    rng(i,"twister");
    [bestSolPSO(i,:),bestfitness(i,3),~,~,~]=PSO(probC,lb,ub,Np,T,w,c1,c2);
    
    rng(i,"twister");
    [bestSolABC(i,:),bestfitness(i,4)]=ABC(probC,lb,ub,Np,T,limit);

    rng(i,"twister");
    [bestSolGA(i,:),bestfitness(i,5)]=GeneticAlgorithm(probC,lb,ub,Np,T,etac,etam,pc,pm);

end

[minCost,minInd]=min(bestfitness(1,:));
Ans=bestSolTLBO(minInd,:);

for i=1:numSalesmen
    
    fprintf('%d Salesman\n',i);
    for j=1:numDays
        fprintf('%d city on %d day \n',Ans((i-1)*numDays+j),j);
    end
    fprintf('\n');
end


%Comparision  of differerent technique
stat(1,:)=min(bestfitness);
stat(2,:)=max(bestfitness);
stat(3,:)=mean(bestfitness);
stat(4,:)=std(bestfitness);
stat(5,:)=median(bestfitness);

