function [c,ceq] = absSum(x,budget)
    for i=1:length(x)
        c(i) = abs(x(i))-budget;
    end
    ceq = sum(abs(x))-budget;
end