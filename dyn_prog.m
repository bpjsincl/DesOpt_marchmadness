clear;

num_stages = 6;	% number of rounds in the tournament
num_states = 5;	% number of possible bets at each round

% % data from portfolio optimization
% benefits = [5 10 8 3 5; 4 7 3 1 2; 11 13 15 11 12; 1 2 16 14 12; 3 1 4 6 7];
% benefits(:,:,2) = [6 12 9 12 1; 1 2 16 14 12; 20 22 23 22 12; 7 3 4 3 5; 2 4 5 8 7];
% benefits(:,:,3) = [30 29 28 16 19; 27 26 25 6 5; 24 14 17 12 1; 2 43 5 3 2; 3 5 3 6 3];
% benefits(:,:,4) = [1 2 1 4 6; 7 6 5 2 4; 4 4 7 8 6; 8 6 5 3 2; 2 3 7 4 7];
% benefits(:,:,5) = [4 2 15 23 22; 12 11 14 1 2; 3 3 5 13 16; 1 8 5 4 9; 2 5 6 7 3];
% benefits(:,:,6) = [12 41 12 5 22; 23 22 15 12 1; 1 2 3 4 5; 2 7 4 6 5; 1 4 6 8 90];

allRtns = importdata('allRtns.mat');
benefits = DPsetup(allRtns);
keySet =   {'5', '4', '3', '2', '1'};
valueSet = [0, .25, .5, .75, 1];
allocationMap = containers.Map(keySet,valueSet);

% extend for more states and stages...

opt_list = [];	% stores benefit at current state, and optimal decision location
[state_benefit, opt_dsg] = max(benefits(:, :, num_stages));
[row, col] = max(state_benefit);
state_benefit = row;
opt_dsg = opt_dsg(col);

opt_list = [opt_list; state_benefit, opt_dsg];

for curr_stage = (num_stages-1):-1:1
	[state_benefit, opt_dsg] = max(benefits(:, opt_dsg, curr_stage));
	opt_list = [opt_list; state_benefit, opt_dsg];
end

pathCell = num2str(opt_list(:,2))';
for q=1:length(pathCell)
    revPath(q) = allocationMap(pathCell(q));
end
path = [fliplr(revPath) 1]
pathRtns = fliplr(opt_list(:,1)')
totRtn = sum(opt_list(:,1))
