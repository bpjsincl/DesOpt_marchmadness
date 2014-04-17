% define all matchups in each round
Round1Matchups = {[1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9], ...
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9], ...
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9], ...
                    [1 16], [2 15], [3 14], [4 13], [5 12], [6 11], [7 10], [8 9]};

Round2Matchups = {[1 9], [12 4], [11 3], [10 2], [1 8], [12 4], [6 3], [7 2], ...
                    [1 8], [12 4], [6 3], [7 2], [1 8], [5 4], [11 14], [7 2]};
                
Round3Matchups = {[1 4], [11 10], [1 4], [3 7], [1 4], [6 2], [8 4], [11 2]};%, ...
%                     [4 1], [10 11], [4 1], [7 3], [4 1], [2 6], [4 8], [2 1]};

% Round4Matchups = {[1 11], [11 1], [4 7], [7 4], [1 2], [2 1], [8 2], [2 8]};
Round4Matchups = {[1 11], [4 7], [1 2], [8 2]};

Round5Matchups = {[2 8], [1 7]};

Round6Matchups = {[7 8]};

Matchups = [{Round1Matchups} {Round2Matchups} {Round3Matchups} {Round4Matchups} {Round5Matchups} {Round6Matchups}];
budgets = [1 .75 .5 .25];

allRtns=[];
budgetAlloc={};
RoundMatchups=[];
for l=1:length(Matchups)
    for q=1:length(budgets)
        RoundMatchups = Matchups{l};
        % calculate probability of team winning for each game in current round (simple probability)
        % Prob = [];
        % for i=1:length(RoundMatchups)
        %     p = 1 - RoundMatchups{i}(1)/(RoundMatchups{i}(1)+RoundMatchups{i}(2));
        %     Prob = [Prob p];
        % end
        % R = 1./Prob;

        % define the budget for a round
        budget = budgets(q); % here the budget is the same for every round, and normalized to 1

        % scales the variance (risk) in the objective function; take more risk as
        % tournament progresses
        theta = 5*length(RoundMatchups); %15 is for when want low risk; .1 for high risk

        % set initial conditions (first guess of what the division of budget might be)
        x0_fmin = budget/length(RoundMatchups)*ones(1,length(RoundMatchups)); %initial guess of length of number of games played in current round
        % A = [eye(length(RoundMatchups),length(RoundMatchups)); -eye(length(RoundMatchups),length(RoundMatchups))];
        % b = [ones(1,length(RoundMatchups)) ones(1,length(RoundMatchups))];
        % Aeq = ones(1,length(RoundMatchups));
        % beq = 1;
        % LB =zeros(1,length(RoundMatchups)); UB = budget*ones(1,length(RoundMatchups));

        A=[];
        b=[];
        Aeq=[];
        beq=[];
        UB=[];LB=[];
        options.MaxFunEvals = 10000;
        options.MaxIter = 1000;
        options.Algorithm = 'active-set'; %active-set works!
        [x_fmincon,fval, exit] = fmincon(@(x) mean_var_func(x, theta, RoundMatchups),x0_fmin,A,b,Aeq,beq,LB,UB,@(x) absSum(x, budget),options);
        [~,rtn,R] = mean_var_func(x_fmincon, theta, RoundMatchups);

        constraint = sum(abs(x_fmincon)); %check equality constraint satisfied

        budgetRtns(q) = rtn;
    end
    budgetRtns(q+1) = 0;
    allRtns = [allRtns; budgetRtns];
    budgetAlloc(l) = {x_fmincon}; % budget allocations for all rounds at one budget percentage
end
allRtns