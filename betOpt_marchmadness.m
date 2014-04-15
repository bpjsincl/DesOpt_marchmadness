% first, define the problem for two games
p1 = (1 - 1/(1+16));	% seed 1 vs 16
p2 = (2 - 2/(2+15));	% seed 2 vs 15

% set some x's?
x = [0.5; 0.5;]
x1 = x(1);
x2 = x(2);

% calculate the return (r) for games 1 and 2
r1 = (x1 / p1) - x1;
r2 = (x2 / p2) - x2;

R = [p1; p2;]

% define the budget for a round
b = 1; % here the budget is the same for every round, and normalized to 1

% scales the variance (risk) in the objective function
theta = 0.5;

% not sure about ol' mu...
mu = 0.5;

% should mu be indexed or is it one value for all games?
variance = (x(1).^2) * (p1 * (r1 - mu)^2) + (x(2).^2) * (p2 * (r2 - mu)^2);

% set initial conditions (first guess of what the division of budget might be)
x0_fmin = [0.5 0.5];

A = [0 0];
b = 0;
Aeq = [1 1];
beq = 1;

% fmincon is our solver for the minimization problem
[x_fmincon,fval] = fmincon(@(x) obj_func(x,r1,r2,theta,variance),x0_fmin,A,b,Aeq,beq)