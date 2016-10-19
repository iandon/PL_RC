function [trialProc] = calcTrialsVars_ConstStim(blockNum)
global params;

if params.practice.run == 1
    n = params.practice.nTrials;
else
    n = params.trial.numTrialsInBlock;
end

%%%%%%%----- COVARIATES -----%%%%%%%

numAngles = length(params.stim.possibleAngles);

numLocs = size(params.block.StimNumOnBlock,2);

numContLevels = length(params.stim.contLevels);

numTrialsPerLevel = params.trial.numTrialsPerLevel;


numCovarCombos = numAngles*numLocs*numContLevels*(numTrialsPerLevel/numAngles); % CHECK TO SEE IF numTrialsPerLevel is even!!! (numTrialsPerLevel/numLocss) should be an integer
numCovarCombosNoRep =  numAngles*numLocs*numContLevels;


%Check if number of trials is OK - i.e is a multiple of the total number of
%variable parameter combinations

if (round(n/(numCovarCombos))-(n/(numCovarCombos)))~=0
       error('Number of trials must be able to be divided by number of possible angles times number of possible locations');
end

ord = randperm(n);



%%%%%%----  Constrast -----%%%%%%%%

numCovNOTcont = numCovarCombos/numContLevels;

contLevelNumPRE = [1:numContLevels]';

contLevelNumMTX = repmat(contLevelNumPRE, [numCovNOTcont,1]);

contLevelNum = contLevelNumMTX(ord,:);

size(contLevelNum)

cont = nan(n,1);
for i = 1:n
    cont(i) = params.stim.contLevels(1,contLevelNum(i));
end


%%%%%%----  Stimulus location -----%%%%%%%%
% If locations of stimuli do not change through the experiment, use following code. Otherwise
% change code here

numCovNOTloc = numCovarCombos/numLocs;

numCovNOTlocNoRep = numCovarCombosNoRep/numLocs;


stimNumPosspre = nan(numCovarCombosNoRep/numAngles,1);
for i = 1:numLocs
    stimNumPosspre((1+((i-1)*numContLevels):(i*numContLevels))) = i*ones(numContLevels,1);
end

stimNumPossMTX = repmat(stimNumPosspre, [numTrialsPerLevel,1]);

stimNumPoss = stimNumPossMTX(ord);

stimNum = nan(n,1);
stimLocs = nan(n,2);
for i = 1:n
    stimNum(i) = params.block.StimNumOnBlock(blockNum,stimNumPoss(i));
    stimLocs(i,:) = params.stim.locationsPix(stimNum(i),:);
end


%%%%%%%----- Angles -----%%%%%%%
% Computing angles for all stimuli for all trials, so angles are
% distributed randomly

numCovNOTanglesNoRep = numCovarCombosNoRep/numAngles;

numCovNOTangles = numCovarCombos/numAngles;

             
anglesMTXpre = nan(numCovNOTanglesNoRep*numLocs,1); %length is the product of # of each covariate
for i = 1:numAngles
    anglesMTXpre((1+((i-1)*numCovNOTanglesNoRep)):(i*numCovNOTanglesNoRep)) = i*ones(numCovNOTanglesNoRep,1);
end

anglesMTX = repmat(anglesMTXpre, (numTrialsPerLevel/numAngles),1);

angleNum = anglesMTX(ord,:);

angle = nan(n,1);
for i = 1:n
	angle(i) = params.stim.possibleAngles(angleNum(i));
end



%%%%%%----  Cue Validity -----%%%%%%%%
% Validity = Does the cued location equal the post cue location?

if params.preCue.type == 0
    propValid = 0;
elseif params.preCue.type == 1
    propValid = params.preCueExg.validity;
end
validitiesPRE = rand(n,1);
validities = validitiesPRE < propValid;

%%%%%%----  Pre Cued location -----%%%%%%%%

cueLocs = nan(n,2);
cuedStimNum = nan(n,1);
for i = 1:n
    if validities(i) == 1
        cuedStimNum(i) = stimNum(i,1);
        cueLocs(i,:) = [params.preCueExg.locationsPix(stimNum(i,1),1),...
                        params.preCueExg.locationsPix(stimNum(i,1),2)];
    elseif validities(i) == 0
        cuedStimNum(i) = 0;
        cueLocs(i,:) = params.screenVar.centerPix;
    elseif validities(i) == 2
        cuedStimNum(i) = stimNum(i,2);
        cueLocs(i,:) = [params.preCueExg.locationsPix(stimNum(i,2),1),...
                        params.preCueExg.locationsPix(stimNum(i,2),2)]; %Location of cue corresponding to distractor1
        % NOTE: the current exp only has 1 stimulus. If there are 2, this
        % would cue the distractor on invalid trials (validity = 2)
    end
end

% update cue location to be slightly different from stim location
%prop = params.precueExg.radiusPix/params.stim.radiusPix;
%cueLocs =  [(1-prop)* params.screenVar.centerPix(1) + (prop)*cuedStimLocs(:,1) ,...
%            (1-prop)* params.screenVar.centerPix(2) + (prop)*cuedStimLocs(:,2)];
        

preCue = struct('locs', cueLocs,'cuedStimNum', cuedStimNum); 


%%%%%%----  Post Cued location -----%%%%%%%%
postCueLocs = stimLocs; %Post cue is always pointing to the target. if there is more than 1 stimulus, postCueLocs = stimLocs(:,1,:);
targetNums = stimNum; %Target is always the only stimulus on the screen. If there is more than 1 stimulus on the screen, targNum = stimNum(:,1);



%%%%%%----  Phase offset -----%%%%%%%%
phase_offset = 2*pi*rand(size(stimNum));


%%%%%%----  Staircase Order -----%%%%%%%%
if params.stair.run
    stairNumPoss1 = 1:params.stair.numStaircases; stairNumPoss1 = stairNumPoss1';
    stairNumPoss2 = (1+params.stair.numStaircases):(params.stair.numStaircases*numLocs); stairNumPoss2 = stairNumPoss2';
    
    stairNumpre2 = repmat(stairNumPoss1, [(params.stair.numTrialsPerStaircase),1]);
    stairNumpre3 = repmat(stairNumPoss2, [(params.stair.numTrialsPerStaircase),1]);
    
    stairOrd = randperm(size(stairNumpre2,1));
    stairOrd2 = randperm(size(stairNumpre3,1));
    
    stairNumpre4 = [stairNumpre2(stairOrd), stairNumpre3(stairOrd2)];
    stairNum = nan(n,1); stair1Count = 0; stair2Count = 0;
    for i = 1:n
        if stimNum(i) == params.block.StimNumOnBlock(blockNum,1)
            stair1Count = stair1Count + 1;
            stairNum(i) = stairNumpre4(stair1Count,1);
        elseif stimNum(i) == params.block.StimNumOnBlock(blockNum,2)
            stair2Count = stair2Count + 1;
            stairNum(i) = stairNumpre4(stair2Count,2);
        end
    end
    
end
%%%%%NOTE: will have to factor in # of trials



%%%%%%----  Target's data -----%%%%%%%%

targets = cell(n,1);
for idx = 1:n
    targets{idx}.angle = angle(idx,1);
    targetsP{idx}.cont = cont(idx,1);
    targets{idx}.validity = validities(idx);
    targets{idx}.num = targetNums(idx);
    targets{idx}.loc = postCueLocs(idx);
end
    
trialNum = 1:n;
trialNum = trialNum';
% % 
% % trial = struct('angles', angles, 'cont', cont, 'stimLocs', stimLocs,...
% %                'precue', precue, 'validities',validities, 'postCueLocs', postCueLocs,...
% %                'targets', targets, 'phase_offset', phase_offset, 'stairNum',stairNum,...
% %                'trialNum', trialNum);
           
    
trialProc = cell(n,1);
for i = 1:n
    trialProc{i}.trialNum = trialNum(i);
    trialProc{i}.angle = angle(i,:);
    trialProc{i}.angleNum = angleNum(i,:);
    trialProc{i}.stimNum = stimNum(i,:);
    trialProc{i}.stimLocs = stimLocs(i,:);
    trialProc{i}.preCue.locs = preCue.locs(i,:); 
    trialProc{i}.preCue.cuedStimNum = preCue.cuedStimNum(i);
    trialProc{i}.validity = validities(i);
    trialProc{i}.postCueLocs = postCueLocs(i,:);
    trialProc{i}.targets = targets{i};
    trialProc{i}.phase_offset = phase_offset(i);
    if params.stair.run == 1, trialProc{i}.stairNum = stairNum(i); end
    trialProc{i}.cont = cont(i,:);
    trialProc{i}.contLevelNum = contLevelNum(i,:);
end



end





