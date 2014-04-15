function y = obj_func(x, r1, r2, theta, variance)
    % The objective function to describe our problem
    y = r1 * x(1) + r2 * x(2) - theta * sqrt(variance);
end