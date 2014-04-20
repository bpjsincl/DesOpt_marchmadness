% ---------------------------------------------------------------------
% Brian Sinclair
% 
% Description:
% The following builds an novel application of expanding on the myopic approach 
% into a dynamic portfolio optimization problem where the budget for the following 
% round is the return on investment from the previous round.
% 
% Notes:
%  - Sensitive to initial guess 
%  - simple probability calculation makes unrealistic because because risk
%  is in difficult to weight
% ---------------------------------------------------------------------

% define all matchups in each round
clear all; close all;
Round1Matchups = {[1 16], [8 9], [5 12], [4 13], [6 11], [3 14], [7 10], [2 15], ...
                    [1 16], [8 9], [5 12], [4 13], [6 11], [3 14], [7 10], [2 15], ...
                    [1 16], [8 9], [5 12], [4 13], [6 11], [3 14], [7 10], [2 15], ...
                    [1 16], [8 9], [5 12], [4 13], [6 11], [3 14], [7 10], [2 15]};
Round2Matchups = {[1 9], [12 4], [11 3], [10 2], [1 8], [12 4], [6 3], [7 2], ...
                    [1 8], [12 4], [6 3], [7 2], [1 8], [5 4], [11 14], [7 2]};                
Round3Matchups = {[1 4], [11 10], [1 4], [3 7], [1 4], [6 2], [8 4], [11 2]};
Round4Matchups = {[1 11], [4 7], [1 2], [8 2]};
Round5Matchups = {[8 2], [1 7]};
Round6Matchups = {[7 8]};

% define all winners in each round (in same order as matchups)
round1Winners = [1 -1 -1 1 -1 1 -1 1, ...
                 1  1 -1 1  1 1  1 1, ...
                 1  1 -1 1  1 1  1 1, ...
                 1  1  1 1 -1 -1 1 1];
round2Winners = [1 -1 1 1 1 -1 -1 1 1 -1 1 -1 -1 -1 1 -1];
round3Winners = [1 1 -1 -1 1 -1 1 -1];
round4Winners = [1 -1 -1 1];
round5Winners = [1 -1];
round6Winners = 1;

Matchups = [{Round1Matchups} {Round2Matchups} {Round3Matchups} {Round4Matchups} {Round5Matchups} {Round6Matchups}];
Winners = [{round1Winners} {round2Winners} {round3Winners} {round4Winners} {round5Winners} {round6Winners}];
percents = [1 .75 .5 .25 0];
dpPercents = percents;
rtn = 1;

prevRndCount = 1;
budgetRtns=[rtn];
startRtns=[1 1 1 1 1];
allRtns=[startRtns]; %init as percents for as if Round 0 exists
for k=1:length(dpPercents)
    budgetAlloc={};
    RoundMatchups=[];
    allRtns = [allRtns; startRtns];
    for l=1:length(Matchups)
        round = l;
%         prevMaxRtn = budgetRtns(1); %return from previous round at 100%
        for q=1:length(percents)
            RoundMatchups = Matchups{l};
            RoundWinners = Winners{l};
            % calculate probability of team winning for each game in current round (simple probability)
            % Prob = [];
            % for i=1:length(RoundMatchups)
            %     p = 1 - RoundMatchups{i}(1)/(RoundMatchups{i}(1)+RoundMatchups{i}(2));
            %     Prob = [Prob p];
            % end
            % R = 1./Prob;

            % define the budget for a round
            currPercent = percents(q);
            prevRtn = allRtns(end-1,k);
            if round==1
                prevPercent = 1;
            else
                prevPercent = dpPercents(k);
            end
%             prevMaxRtn = prevMaxRtn
            budget = currPercent*(currPercent*prevRtn + (1-prevPercent));%*prevRtn;
    %         budget = percents(q)*rtn; % here the budget is the same for every round, and normalized to 1

            % scales the variance (risk) in the objective function; take more risk as
            % tournament progresses
            theta = 1*length(RoundMatchups); %15 is for when want low risk; 1 for high risk

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
            xWinners = checkwinners(x_fmincon,RoundWinners); %xWinners will be a vector of winning bets
            [~,rtn,R] = mean_var_func(xWinners, theta, RoundMatchups);

            constraint = sum(abs(x_fmincon)); %check equality constraint satisfied

            budgetRtns(q) = rtn;
        end
        allRtns = [allRtns; budgetRtns];
        prevRndCount = prevRndCount+1;
        budgetAlloc(l) = {x_fmincon}; % budget allocations for all rounds at one budget percentage
    end
    allRtns = [allRtns; startRtns]; %add start to returns at end for next percentage allocation calculations
end
save('allRtns.mat','allRtns');
allRtns