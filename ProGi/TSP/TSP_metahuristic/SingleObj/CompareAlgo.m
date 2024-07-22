clc
clear all


[numCities,SP,travelCost,numDays,adj_mat]=TSPdata;  %taking data from the data file
NRuns=5;
Np=50;T=100;  %setting problem parameters for TLBO
Pc=0.8;F=0.85; %setting problem parameters for DE
w=1.7;c1=1.5;c2=1.5; %setting problem parameters for PSO
limit=100;%setting problem parameters for ABC
etac=20;etam=21;pc=0.8;pm=0.3;%setting problem parameters for GA

probC=@TSP_minCC;    %function handle for caluclulating maxProfit with correction


lb=ones(1,numCities);                 %declaring limit on population with lowerbound and upper bound
ub=ones(1,numCities).*numCities;




bestfitness=NaN(NRuns,5);


for i=1:NRuns
    %employing TLBO meta huristic technique
    rng(i,"twister");
    [bestSolTLBO(i,:),~,bestfitness(i,1),~,~]=TLBO_NoC(Np,T,lb,ub,probC);
    %employing DE meta huristic technique
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



%Comparision  of differerent technique
stat(1,:)=min(bestfitness);
stat(2,:)=max(bestfitness);
stat(3,:)=mean(bestfitness);
stat(4,:)=std(bestfitness);
stat(5,:)=median(bestfitness);

