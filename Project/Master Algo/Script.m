%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YOEA112
% Project Title: Implementation of Firefly Algorithm (FA) in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%
tic;
clc;
clear;
close all;
format long g
%% Problem Definition

nVar=10;                 % Number of Decision Variables

VarSize=[1 nVar];       % Decision Variables Matrix Size

% lb = [2 2 2 2 2 2 200 200 200 200];                               % Decision Variables Lower Bound
% ub = [10 10 10 10 10 10 20000 20000 20000 20000];                 % Decision Variables Upper Bound
lb = [2 2 2 2 2 2 18000 18000 18000 18000];
ub = [10 10 10 10 10 10 1800000 1800000 1800000 1800000];

%% Firefly Algorithm Parameters

MaxIt=25;         % Maximum Number of Iterations

nPop=100;            % Number of Fireflies (Swarm Size)

gamma=1;            % Light Absorption Coefficient

beta0=2;            % Attraction Coefficient Base Value

alpha=0.2;          % Mutation Coefficient

alpha_damp=0.98;    % Mutation Coefficient Damping Ratio
 Quarters=20;
delta=0.05*(ub-lb);     % Uniform Mutation Range
MA_B=130000;
m=2;

%graphss
Profit=zeros([1 Quarters+1]);
Profit(1)=0;
Mark1=zeros([1 Quarters]);
Mark2=zeros([1 Quarters]);
Amb1=zeros([1 Quarters+1]);
Amb2=zeros([1 Quarters+1]);
Amb1(1)=0;
Amb2(2)=0;

CostFunction=@(x,ub,lb,B) OBJ(x,ub,lb,B);        % Cost Function
for i=1:Quarters
rng(1,'twister')                % Controlling the random number generator used by rand, randi
    [BestSol,BestFitIter] = fa(CostFunction,lb,ub,nPop,VarSize,gamma,beta0,alpha,alpha_damp,delta,m,MaxIt,MA_B);
    BestSol
    Profit(i+1)=-BestSol.Cost;
    Mark1(i)=BestSol.Position(9);
    Mark2(i)=BestSol.Position(10);
    Amb1(i+1)=BestSol.Position(7);
    Amb2(i+1)=BestSol.Position(8);
    MA_B=.2*max(360000,Profit(i+1));
end

semilogy(BestFitIter-min(BestFitIter),'--','LineWidth',2);
xlabel('Iterations');
ylabel('Fitness');
hold on

% plot(Amb2,'--','LineWidth',2);
% xlabel('Quarters');
% ylabel('Ambiance Budget');
% hold on;

% plot(Profit,'--','LineWidth',2);
% xlabel('Quarters');
% ylabel('Profit');
% hold on;
timeElapsed=toc
%% Genetic Algorithm
prob = @OBJ;
Np = 100;                            % Population Size
T = 300;                             % No. of iterations
MA_B= 130000;
etac = 4;                         % Distribution index for crossover
etam = 7;                         % Distribution index for mutation
Pc = 0.8;                          % Crossover probability
Pm = 0.2;                          % Mutation probability

for j=1:Quarters
    %rng(1,'twister')                % Controlling the random number generator used by rand, randi
    [bestsol,bestfitness,BestFitIter] = GeneticAlgorithm(prob,lb,ub,Np,T,etac,etam,Pc,Pm,MA_B);
    [f,profit]=OBJ(bestsol,ub,lb,MA_B)
    Profit(j+1)=profit;
    Mark1(j)=bestsol(9);
    Mark2(j)=bestsol(10);
    Amb1(j+1)=bestsol(7);
    Amb2(j+1)=bestsol(8);
    Stat(1,1) = min(bestfitness);             % Determining the best fitness function value
    Stat(1,2) = max(bestfitness);             % Determining the worst fitness function value
    Stat(1,3) = mean(bestfitness);            % Determining the mean fitness function value
    Stat(1,4) = median(bestfitness);          % Determining the median fitness function value
    Stat(1,5) = std(bestfitness);             % Determining the standard deviation
    MA_B=.2*max(360000,profit)

end

semilogy(BestFitIter-min(BestFitIter),':','LineWidth',2);
xlabel('Iterations');
ylabel('Fitness');
hold on

% plot(Amb2,':','LineWidth',2);
% xlabel('Quarters');
% ylabel('Ambiance Budget');
% hold on;

% plot(Profit,':','LineWidth',2);
% xlabel('Quarters');
% ylabel('Profit');
% hold on;
timeElapsed=toc
%% TLBO

Np = 100;                     % Population Size
T = 50;                      % No. of iterations
MA_B= 130000;                      % Ambiance and Marketing budget

for j=1:Quarters
    rng(1,'twister')                % Controlling the random number generator used by rand, randi
    [bestsol,bestfitness,BestFitIter,~,~] = TLBO(prob,lb,ub,Np,T,MA_B)
    [f,profit]=OBJ(bestsol,ub,lb,MA_B)
    Profit(j+1)=profit;
    Mark1(j)=bestsol(9);
    Mark2(j)=bestsol(10);
    Amb1(j+1)=bestsol(7);
    Amb2(j+1)=bestsol(8);
    Stat(1,1) = min(bestfitness);             % Determining the best fitness function value
    Stat(1,2) = max(bestfitness);             % Determining the worst fitness function value
    Stat(1,3) = mean(bestfitness);            % Determining the mean fitness function value
    Stat(1,4) = median(bestfitness);          % Determining the median fitness function value
    Stat(1,5) = std(bestfitness);             % Determining the standard deviation
    MA_B=.2*max(360000,profit);

end

semilogy(BestFitIter-min(BestFitIter),'LineWidth',2);
xlabel('Iterations');
ylabel('f(x) - min(f(x))');
hold on
legend('FA','GA','TLBO');
title("Fitness value at each iteration");
subtitle("At Quarter 20");
%ylim([-7000000 7000000]);
xlim([0 50]);
hold off

% plot(Amb2,'LineWidth',2);
% xlabel('Quarters');
% ylabel('Ambiance Budget');
% hold on
% legend('FA','GA','TLBO');
% title("Quarterly Ambiance Budget in Casual Dining");
% hold off
timeElapsed=toc
% plot(Profit,'LineWidth',2);
% xlabel('Quarters');
% ylabel('Profit');
% hold on
% legend('FA','GA','TLBO');
% title("Quarterly Profit");
% hold off