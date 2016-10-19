function [numBlocks, nTrials] = initBlockVars(sesType)
global params

numBlocks = params.block.numBlocks;
nTrials = params.trial.numTrialsInBlock;

switch sesType
    case 0
        switch params.stim.orderType
            case 1
                switch params.stim.trainLoc
                    case 1; params.stim.possibleLocNums = [1;2];
                    case 2; params.stim.possibleLocNums = [2;1];
                end
            case 2
                switch params.stim.trainLoc
                    case 2; params.stim.possibleLocNums = [1;2];
                    case 1; params.stim.possibleLocNums = [2;1];
                end
        end
    case 1
        switch params.stim.trainLoc
            case 1, params.stim.possibleLocNums = [1];
            case 2, params.stim.possibleLocNums = [2];
        end
end

LocNumOnBlockPRE = params.stim.possibleLocNums;
numRep = numBlocks/size(params.stim.possibleLocNums,1);
if mod(numRep,1) ~= 0
    error('Number of Blocks must be a multiple of # of possible stimulus locations')
end
params.block.LocNumOnBlock = repmat(LocNumOnBlockPRE, [numRep,1]);