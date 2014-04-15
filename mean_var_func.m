function y = mean_var_func(x, theta, Prob)
    R=[];
    numGames = length(x);
    for i = 1:numGames
        ri = (x(i)/Prob(i))-x(i);
        R = [R ri];
    end
    var_R=[];
    for k =1:numGames
        var_ri = (Prob(k)*(R(k)-R*x').^2);
        var_R = [var_R var_ri];
    end
    
    y = R*x' - theta*sqrt(x.^2*var_R');
end