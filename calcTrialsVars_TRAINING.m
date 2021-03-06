function [trialProc] = calcTrialsVars_STAIRcontrast(blockNum)
global params;

if params.practice.run == 1
    n = params.practice.nTrials;
else
    n = params.trial.numTrialsInBlock;
end

%%%%%%%----- COVARIATES -----%%%%%%%

numOriDirs = length(params.stim.possibleOri);

numLocs = size(params.block.LocNumOnBlock,2);

numRespOptions = length(params.response.allowedRespKeys);

numTrialsPerCond = params.trial.numTrialsPerLevel;                                                                      

presAbsRespOptions = [1,0]; % ans1 = 1 (present); ans2 = 0 (absent)

%% counter balance variables

[oriDirNum,locNum,ansNum,repNum] = ndgrid(1:numOriDirs,1:numLocs,1:numRespOptions,1:numTrialsPerCond);

if length(oriDirNum(:)) ~= n, error('Number of trials does not match the value set in parameters!'), end

ord = randperm(n);

%% make variable vectors
trialProc = cell(n,1);
for i = 1:n
   trialProc{i}.oriDir = params.stim.possibleOri(blockNum,oriDirNum(ord(i)));
   trialProc{i}.oriDirNum = oriDirNum(ord(i));
   
   trialProc{i}.loc = params.block.LocNumOnBlock(locNum(ord(i)));
   trialProc{i}.locNum = locNum(ord(i));
   
   trialProc{i}.ans = ansNum(ord(i));
   
   trialProc{i}.presAbs = presAbsRespOptions(ansNum(ord(i)));
end




