clear;

num_stages = 3;	% number of rounds in the tournament
num_states = 3;	% number of possible bets at each round

% data from portfolio optimization
benefits = [5 10 8; 4 7 3; 11 13 15];
benefits(:,:,2) = [6 12 9; 1 2 16; 20 22 23];
benefits(:,:,3) = [30 29 28; 27 26 25; 24 14 17];

% extend for more states and stages...

opt_list = [];	% stores benefit at current state, and optimal decision location

for curr_stage = num_stages:-1:1
	for curr_state = 1:num_states		
		[curr_benefit, opt_dsg] = max(benefits(curr_state, :, curr_stage));
		opt_list = [opt_list; curr_benefit, opt_dsg, curr_state, curr_stage];
	end
	% need max of sum of best path here and best path previously
end

% [max_1 path_1] = max(opt_list(1:3, 1));
% [max_2 path_2] = max(opt_list(4:6, 1));
% [max_3 path_3] = max(opt_list(7:9, 1));

% opt_list
% max_list = [max_1 path_1; max_2 path_2; max_3 path_3]

% total_return = max_1 + max_2 + max_3