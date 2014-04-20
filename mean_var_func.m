function [y,rtn,R] = mean_var_func(x, theta, RoundMatchups)
    numGames = length(x);
    Prob = [];
    for i=1:numGames
        if x(i) >= 0
            p = 1 - RoundMatchups{i}(1)/(RoundMatchups{i}(1)+RoundMatchups{i}(2));
        else
            % This is because when -ve allocation of budget, betting on
            % team B in (A,B) matchup
            % multiply by -ve so when calculating return positive 
            p = -RoundMatchups{i}(1)/(RoundMatchups{i}(1)+RoundMatchups{i}(2)); 
        end
        Prob = [Prob p];
    end
    R = 1./Prob;

    var_R=[];
    for k =1:numGames
        var_ri = (abs(Prob(k))*(abs(R(k))-mean(abs(R)))^2); %take abs because -ve R above
        var_R = [var_R var_ri];
    end
        
    rtn = R*x';
    risk = -theta*sqrt((x.^2)*var_R');
    y = rtn + risk;
    y=-y;
end