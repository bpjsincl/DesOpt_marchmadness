function [transitionRtns] = DPsetup(allRtns)
    transitionRtns = [];
    bias = 2; %needed for ones vectors in allRtns at beginning =
    numRounds = 6;
    for transitions=1:numRounds
        allRoundRtns =allRtns(transitions+bias:8:end,:); %allRtns(3:8:end,:) for round 1 rtns
        transitionRtns(:,:,transitions) = allRoundRtns;
    end
end

