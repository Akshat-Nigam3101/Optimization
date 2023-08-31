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
tic
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

MaxIt=20;         % Maximum Number of Iterations

nPop=100;            % Number of Fireflies (Swarm Size)

gamma=1;            % Light Absorption Coefficient

beta0=2;            % Attraction Coefficient Base Value

alpha=0.2;          % Mutation Coefficient

alpha_damp=0.98;    % Mutation Coefficient Damping Ratio
Quarters=15;
delta=0.05*(ub-lb);     % Uniform Mutation Range
B=270000;
m=2;
Profit=zeros(Quarters)';
CostFunction=@(x,ub,lb,B) OBJ(x,ub,lb,B);        % Cost Function
for i=1:Quarters
rng(1,'twister')                % Controlling the random number generator used by rand, randi
    [BestSol,BestCost] = fa(CostFunction,lb,ub,nPop,VarSize,gamma,beta0,alpha,alpha_damp,delta,m,MaxIt,B);
    BestSol
    Profit(i)=-BestSol.Cost;
    B=.2*max(360000,Profit(i));
end
%figure;
%plot(BestCost,'LineWidth',2);
plot(Profit,'LineWidth',2);
xlabel('Quarters');
ylabel('Profit');
hold("all");
timeElapsed=toc