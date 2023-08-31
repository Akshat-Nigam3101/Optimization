tic
clc
clear
close all
format long g
%% Problem settings
[P,S,F,SC] = Data;
lb = [2 2 2 2 2 2 18000 18000 18000 18000];
ub = [10 10 10 10 10 10 1800000 1800000 1800000 1800000];

prob = @OBJ;                % Fitness function
Quarters= 40;

%% Algorithm parameters
Np = 100;                            % Population Size
T = 300;                             % No. of iterations
B= 270000;
etac = 4;                         % Distribution index for crossover
etam = 7;                         % Distribution index for mutation
Pc = 0.4;                          % Crossover probability
Pm = 0.6;                          % Mutation probability

% M_factor= [0.001 0.001]';
% A_factor= [0.001 0.001]';
% MP=[0 0 0 0]';
% AP=[0 0 0 0]';
% m0=[0 0]';
% a0=[0 0]';
%New_Pop=P;
for j=1:Quarters
    rng(1,'twister')                % Controlling the random number generator used by rand, randi
    [bestsol,bestfitness] = GeneticAlgorithm(prob,lb,ub,Np,T,etac,etam,Pc,Pm,B);
    [f,profit]=OBJ(bestsol,ub,lb,B)
%      A_factor(1)= min((a0(1)+bestsol(7))/B,1);
%      M_factor(1)=min((m0(1)+bestsol(9))/B,1);
%      A_factor(2)=min((a0(2)+bestsol(8))/B,1);
%      M_factor(2)=min((m0(2)+bestsol(10))/B,1);
%      a0(1)=bestsol(7);
%      m0(1)=bestsol(9);
%      a0(2)=bestsol(8);
%      m0(2)=bestsol(10);
%      MP(1)=M_factor(1)*P(1);
%      MP(2)=M_factor(1)*P(2);
%      MP(3)=M_factor(2)*P(3);
%      MP(4)=M_factor(2)*P(4);
%      AP(1)=(1-A_factor(1))*P(1);
%      AP(2)=(1-A_factor(1))*P(2);
%      AP(3)=(1-A_factor(2))*P(3);
%      AP(4)=(1-A_factor(2))*P(4);
%      New_Pop(1)=MP(1)-AP(1);
%      New_Pop(2)=MP(2)-AP(2);
%      New_Pop(3)=MP(3)-AP(3);
%      New_Pop(4)=MP(4)-AP(4);
        
    Stat(1,1) = min(bestfitness);             % Determining the best fitness function value
    Stat(1,2) = max(bestfitness);             % Determining the worst fitness function value
    Stat(1,3) = mean(bestfitness);            % Determining the mean fitness function value
    Stat(1,4) = median(bestfitness);          % Determining the median fitness function value
    Stat(1,5) = std(bestfitness);             % Determining the standard deviation
    B=.2*max(360000,profit)
    
%     
%     n = 0;
%     for j = 1:T+1
%         if BestFitIter(j) <0
%             n = n + 1;
%             y(n) = BestFitIter(j);
%             x(n) = j;
%         end
%     end
%     plot(x,y,'*')
%     hold on
%     
%     xlabel('Iteration')
%     ylabel('Best fitness function value')

end

timeElapsed=toc