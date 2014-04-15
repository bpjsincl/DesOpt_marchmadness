% define all matchups in each round
Round1Matchups = {[1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9],
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9],
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9],
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9]};

Round2Matchups = {[1 9], [12 4], [11 3], [10 2], [1 8], [12 4], [6 3], [7 2],
                    [1 8], [12 4], [6 3], [7 2], [1 8], [5 4], [11 14], [7 2]};
                
Round3Matchups = {[1 4], [11 10], [1 4], [3 7], [1 4], [6 2], [8 4], [11 2]};

Round4Matchups = {[1 11], [4 7], [1 2], [8 2]};

Round5Matchups = {[2 8], [1 7]};

Round6Matchups = {[7 8]};

RoundMatchups = Round1Matchups;
perAllocated = 1;

% calculate probability of team winning for each game in current round (simple probability)
Prob = [];
for i=1:length(RoundMatchups)
    p = 1 - RoundMatchups{i}(1)/(RoundMatchups{i}(1)+RoundMatchups{i}(2));
    Prob = [Prob p];
end

% define the budget for a round
budget = perAllocated*1; % here the budget is the same for every round, and normalized to 1

% scales the variance (risk) in the objective function
theta = 0.5;

% set initial conditions (first guess of what the division of budget might be)
x0_fmin = budget*0.5*ones(1,length(RoundMatchups)); %initial guess of length of number of games played in current round

A = [];
b = [];
Aeq = ones(1,length(RoundMatchups));
beq = budget;
LB = zeros(1,length(RoundMatchups)); UB = budget*ones(1,length(RoundMatchups));

% fmincon is our solver for the minimization problem
[x_fmincon,fval] = fmincon(@(x) mean_var_func(x, theta, Prob),x0_fmin,A,b,Aeq,beq,LB,UB)