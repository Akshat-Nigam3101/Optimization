function [f,profit] = OBJ(x,ub,lb,B)

    % number of higher, upper middle, lower middle and lower class population
    P=[200000 270000 270000 180000]';
    % salary of each type of chef
    S=[300000 200000 135000 90000 72000 45000]';
    % avg spending from each type of customer at each restaurant
    F=[1000 400 300 150]';
    % serving capacity
    SC=[1400 1200 900 2700 1800 900]';
    
     EmpCap = 25;                       % Maximum number of Employees to be occupied
     SalMax= 4000000;                     % Available Budget for Salary of Employees
     TotalFineChef=x(1)+x(2)+x(3);      % Total number of chefs in fine dining restaurant
     TotalCasualChef=x(4)+x(5)+x(6);    % Total number of chefs in casual dining restaurant
     AmbianceCost1=x(7);                % Amount allocated for Ambiance in fine dining restaurant
     AmbianceCost2=x(8);                % Amount allocated for Ambiance in casual dining restaurant
     MarketingCost1=x(9);               % Amount allocated for marketing in fine dining restaurant
     MarketingCost2=x(10);              % Amount allocated for marketing in casual dining restaurant

%% Evaluation of probability of customers coming to restaurants based on number of different types of chefs

     PR=[0 0 0 0]';

     PR(1)= 0.5*(x(1)/TotalFineChef)+0.3*(x(2)/TotalFineChef)+0.2*(x(3)/TotalFineChef);
     PR(2)= -0.1*(x(1)/TotalFineChef)+0.5*(x(2)/TotalFineChef)+0.6*(x(3)/TotalFineChef);
     PR(3)= 0.2*(x(4)/TotalCasualChef)+0.5*(x(5)/TotalCasualChef)+0.3*(x(6)/TotalCasualChef);
     PR(4)= 0.1*(x(4)/TotalCasualChef)+0.2*(x(5)/TotalCasualChef)+0.7*(x(6)/TotalCasualChef);

%% Evaluation of New population based on the nature of investment in Ambiance and Marketing

     NewPop=P;       % initially new population equals initial population pool

     % Following factors determines the relative amounts allocated to
     % Ambiance nad Marketing in Fine and Casual Dining Restaurants

     A_factor(1)=min(AmbianceCost1/B,1)*B/ub(7);
     A_factor(2)=min(AmbianceCost2/B,1)*B/ub(8);
     M_factor(1)=min(MarketingCost1/B,1)*B/ub(9);
     M_factor(2)=min(MarketingCost2/B,1)*B/ub(10);

     % Following factors account for the loss of customers due to lack of 
     % investing in Ambiance and Marketing in Fine and Casual Dining Restaurants

     MLoss(1)=0.3*(1-M_factor(1))*P(1);
     MLoss(2)=0.6*(1-M_factor(1))*P(2);
     MLoss(3)=0.5*(1-M_factor(2))*P(3);
     MLoss(4)=0.7*(1-M_factor(2))*P(4);
     ALoss(1)=0.7*(1-A_factor(1))*P(1);
     ALoss(2)=0.4*(1-A_factor(1))*P(2);
     ALoss(3)=0.5*(1-A_factor(2))*P(3);
     ALoss(4)=0.3*(1-A_factor(2))*P(4);
     NewPop(1)=P(1)-MLoss(1)-ALoss(1);
     NewPop(2)=P(2)-MLoss(2)-ALoss(2);
     NewPop(3)=P(3)-MLoss(3)-ALoss(3);
     NewPop(4)=P(4)-MLoss(4)-ALoss(4);

%% Revenue Calculations

    % Calculating serving capacity of chefs
    CasualChefCap=0;         % Serving capacity of chefs in casual dining restaurant
    FineChefCap=0;           % Serving capacity of chefs in fine dining restaurant
    for j=1:length(SC)
        if j>=4
            CasualChefCap = CasualChefCap + SC(j)*x(j);
        else
            FineChefCap = FineChefCap + SC(j)*x(j);
        end
    end
    
    % Calculating revenue generated
    Revenue=0;
    ServingCap=FineChefCap;
    for j = 1: length(F)
        if j>=3
            ServingCap=CasualChefCap;
        end
        Revenue = Revenue + F(j)*(min(NewPop(j),ServingCap))*PR(j);
    end

%% Cost Calculations

    % Chef salary calculation
    EmpSalary=0;
    for j = 1: length(S)
        EmpSalary = EmpSalary + S(j)*x(j);
    end
    
%% Penalties and Constraints
    
    % Employee Salary constraint
    PenaltySalary = 0;                             % penalty due to exceeding employee salary budget
    if  EmpSalary > SalMax                         
        PenaltySalary = (100*(EmpSalary - SalMax))^2;       
    end
    % Total Employee Count constraint
    TotalEmp = TotalFineChef + TotalCasualChef;
    PenaltyEmp = 0;                                % penalty due to exceeding maximum employee count
    if  TotalEmp > EmpCap                         
        PenaltyEmp = (100*(TotalEmp - EmpCap))^2;       
    end
    
    % Ambiance and marketing budget constraint
    PenaltyExtraBudget = 0;                        % penalty due to exceeding Ambiance and marketing budget
    if  x(7)+x(8)+x(9)+x(10) > B                         
        PenaltyExtraBudget = (x(7)+x(8)+x(9)+x(10) - B)^2;       
    end
    
    % Number of senior chef constraint in fine dining
    PenaltySenior1 = 0;                            % penalty due to violating senior chef constraint in fine dining 
    if 2*x(1) < x(2)+x(3)                      
        PenaltySenior1 = (10000*(2*x(1) - (x(2)+x(3))))^2;
    end
    
    % Number of senior chef constraint in casual dining
    PenaltySenior2 = 0;                            % penalty due to violating senior chef constraint in fine dining
    if 2*x(4) < x(5)+x(6)                      
        PenaltySenior2 = (100*(2*x(4) - x(5)+x(6)))^2;   
    end
%% Profit and Fitness Calculations

    profit = Revenue - (EmpSalary + AmbianceCost1 + AmbianceCost2 + MarketingCost1 + MarketingCost2);   % Profit
    
    f = -profit + 10^15*(PenaltyEmp + PenaltySenior1 + PenaltySenior2 + PenaltyExtraBudget + PenaltySalary);   % Fitness value