clc
clear all


[numCities,SP,travelCost,numDays,adj_mat,pop_mat]=TSPdata;  %taking data from the data file

Np=50;T=50;NRuns=5;  %setting problem parameters
Pc=0.8;F=0.85;
w=1.7;c1=1.5;c2=1.5;
limit=100;
etac=20;etam=21;pc=0.8;pm=0.3;
prob=@TSP_maxP;      %function handle for caluclulating maxProfit without correction
probC=@TSP_maxPC;    %function handle for caluclulating maxProfit with correction


lb=ones(1,numCities);                 %declaring limit on population with lowerbound and upper bound
ub=ones(1,numCities).*numCities;


bestfitness=NaN(NRuns,5);
bestSolTLBO=NaN(NRuns,numCities);
bestSolDE=NaN(NRuns,numCities);
bestSolPSO=NaN(NRuns,numCities);
bestSolABC=NaN(NRuns,numCities);

for i=1:NRuns
    %employing TLBO meta huristic technique
   
    rng(i,"twister");
    [bestSolTLBO,~,bestfitness(i,1),~,~]=TLBO_NoC(Np,T,lb,ub,probC);

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
maxProfit=-min(min(bestfitness)); % determining max profit and using it calucate for multi OBJ
probMult=@TSP_Mult;          % function handle for maxPofit with min distance to travel


bestfitnessC=NaN(NRuns,1);
bestSolC=NaN(NRuns,numDays);
for i=1:NRuns
    
    rng(i,"twister");
    [bestSolC(i,:),~,bestfitnessC(i,1),~,~]=TLBO_MultiObj(Np,T,lb,ub,probMult,maxProfit);
end


%Comparision  of differerent technique
stat(1,:)=min(bestfitness);
stat(2,:)=max(bestfitness);
stat(3,:)=mean(bestfitness);
stat(4,:)=std(bestfitness);
stat(5,:)=median(bestfitness);

