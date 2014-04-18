function [ y ] = checkwinners(x_fmincon, roundWinners)
    c = x_fmincon.*roundWinners>0;
    y = c.*x_fmincon;
end