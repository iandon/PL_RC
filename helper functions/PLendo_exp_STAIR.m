clear all; 
addpath(genpath('helper functions'));
PLendo_defs_STAIR; 
global params; params.practice.run = 0;

params.eye.run = 0;
params.stair.run = 0;
params.stim.colorTest = 0;

%initials = 'test'; sesNum = '0';    
initials = input('Please enter subject initials: \n', 's'); initials = upper(initials);
params.subj.gender = input('Please enter subject GENDER: M/F/O \n', 's');
params.subj.age = input('Please enter subject AGE: \n', 's');
sesNumquest = input('Please enter the session number:\n', 's'); sesNum = str2double(sesNumquest); params.save.sesNum = sesNum; params.ses.sesNum = sesNum;
sesTypequest = input('Test(0) or Training(1)? \n', 's'); sesType = str2double(sesTypequest); params.save.sesType = sesType;
% TRAIN LOCATION is in Plexp_defs file -> Make sure it is the right one!

if (sesNumquest > 1) && ~strcmp(initials,params.save.SubjectInitials)
     error('Check if settings file used is correct for this participant'); 
end

if sesType == 0; params.preCue.type = 0; end 

numBlocks = params.block.numBlocks;
nTrials = params.trial.numTrialsInBlock;

switch sesType
    case 0
        switch params.stim.orderType
            case 1
                switch params.stim.trainLoc
                    case 1; params.stim.possibleStimNums = [1, 4; 2, 3];
                    case 2; params.stim.possibleStimNums = [2, 3; 1, 4];
                end
            case 2
                switch params.stim.trainLoc
                    case 2; params.stim.possibleStimNums = [1, 4; 2, 3];
                    case 1; params.stim.possibleStimNums = [2, 3; 1, 4];
                end
        end
    case 1
        if params.stim.trainLoc == 1, params.stim.possibleStimNums = [1,4];
        elseif params.stim.trainLoc == 2, params.stim.possibleStimNums = [2,3];
        else
            trainLocMSG = sprintf('Training location must be a # 1 or 2 \n \n 1 : Top & Bottom Left \n 2 : Top & Bottom Right \n 3 : Top Left & Top Right \n 4 : Bottom Left & Bottom Right');
            error(trainLocMSG)
        end
end


StimNumOnBlockPRE = params.stim.possibleStimNums;
StimOnBlockORD = randperm(size(params.stim.possibleStimNums,1));
StimNumOnBlockPRE2 = StimNumOnBlockPRE(StimOnBlockORD, :);
numRep = numBlocks/size(params.stim.possibleStimNums,1);
if mod(numRep,1) ~= 0
    error('Number of Blocks must be a multiple of # of possible stimulus locations')
end
params.block.StimNumOnBlock = repmat(StimNumOnBlockPRE2, [numRep,1]);

%params.screen.num
wPtr = Screen('OpenWindow', params.screen.num, params.screen.bkColor, params.screen.rectPix);
%Load  new gamma table to fit the current scre 
startclut = Screen('ReadNormalizedGammaTable', params.screen.num);
load( params.screen.calib_filename); 
new_gamma_table = repmat(calib.table, 1, 3);
Priority(MaxPriority(wPtr));
Screen('LoadNormalizedGammaTable',params.screen.num,new_gamma_table,[]);     

% instructions(wPtr);  
%%%% ------------  Start experiment  ----------%%%%%
NanMtxBlock = nan(1, nTrials);
results.Ses = cell(numBlocks,1);
sesStair1 = cell(numBlocks,1); sesStair2 = cell(numBlocks,1);sesStair3 = cell(numBlocks,1);sesStair4 = cell(numBlocks,1);
expData = cell(numBlocks, 1);



if params.eye.run
    Eyelink('Initialize');
    el = prepEyelink(wPtr);
    ELfileName = sprintf('%s%d', initials, sesNum); edfFileStatus = Eyelink('OpenFile', ELfileName);
    if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...'); return; end
    cal = EyelinkDoTrackerSetup(el);
end


halfWay = 0;halfWaySes = 0; 
for b = 1:numBlocks
    
    
    [trialProc] = calcTrialsVars_STAIR(b);
    
    if sesType == 1
        if halfWaySes == 0
            if (b-1) >= (numBlocks/2)
                halfWaySes = 1;
                halfwayBreak(wPtr,b);
            end
        end
    end
    
    instructions(wPtr);
    
    driftCorr = 1;
    if params.eye.run && (b > 1)
        driftCorr = EyelinkDoDriftCorrect(el, params.screen.centerPix(1),...
                                          params.screen.centerPix(2), 1, 1);
    end
    
    if params.eye.run && ~driftCorr
        EyelinkDoDriftCorrect(el, 'c');
    end
    
    
    stair{b} = upDownStaircase(1,2, params.stair.startOri/params.stair.maxThresh,[params.stair.startStepsize/params.stair.maxThresh,params.stair.minStepsize],'levitt');
    stair{b}.minThreshold = params.stair.minThresh/params.stair.maxThresh; stair{b}.maxThreshold = 1; 
%     stair{b}.minStepsize = params.stair.minStepsize;
        
    
    clear results.Block
    results.Block = struct('rt',{NanMtxBlock},...
                           'key', {NanMtxBlock},...
                           'correct',{NanMtxBlock});
                       
    clear breakFix.Block
    breakFix.Block = struct('check', {[]}, 'track', {[]}, 'count', {0}, 'recent', {0});
    breakFix.Block.count = 0; breakFix.Block.recent = 0; breakFix.Block.recalCount = 0;

    timestamp = cell(nTrials, 1); halfWay = 0;
    j = 0; nTrialsUPDATE = nTrials;
    while j < nTrialsUPDATE
        j = j + 1;
        i = floor(j) - breakFix.Block.count;
        recal = 0;
        
        if (i > (nTrials/2)) && (halfWay == 0)
            halfWay = 1; halfwayBreakblock(wPtr,b);
        end
        
        
        oriCurrent = stair{b}.threshold;
        
        targetAngle = (trialProc{i}.targets.angle*oriCurrent)+180;
        
        cont = trialProc{i}.cont;


        [breakFix.Block.check, correctTrial, respTrial, trialProc{i}.timestamp]...
                                      = trial(wPtr, b, i, trialProc{i}.stimNum,... 
                                              trialProc{i}.preCue.locs, trialProc{i}.angle,...
                                              trialProc{i}.stimLocs, trialProc{i}.postCueLocs,...
                                              cont, targetAngle, trialProc{i}.phase_offset, trialProc{i}.targets.validity);
        if breakFix.Block.check == 1
            beep3(237,157,.1,0);
            nTrialsUPDATE = nTrialsUPDATE + 1;
            breakFix.Block.count = breakFix.Block.count + 1;
            [trialProc, recal, breakFix.Block.recent, breakFix.Block.track]...
                                             = breakProc(trialProc, nTrials,...
                                                         i, j, breakFix.Block.count,...
                                                         breakFix.Block.track,...
                                                         breakFix.Block.recent);
           stair{b} = upDownStaircase(stair{b}, correctTrial);                                
        else    %Note: if there is no fixation break, the trial is not taken into account for stair casing
            results.Block.rt(i)      = respTrial.rt; results.Block.key(i)     = respTrial.key(1);
            results.Block.correct(i) = correctTrial;
            Screen('Close');
        end
        
        if recal; breakFix.Block.recalCount = breakFix.Block.recalCount + 1; recalProc(el, wPtr); end
    end
    
    if params.eye.run == 1
    Eyelink('Message', '~*~*~*~*BLOCK END*~*~*~*~');
    end
    dircB = sprintf('results/%s/%s/Block%d', params.save.expTypeDirName,initials,b);
    blockFileName = sprintf('%s_%s_BlockData_Ses%d_Block%d.mat',...
                            params.save.fileName, initials, sesNum, b);
    
    results.Ses{b}.rt = results.Block.rt; %Each row in each .mat w/in resultsSes is a separate block
    results.Ses{b}.key = results.Block.key; results.Ses{b}.correct = results.Block.correct;
    
    breakFix.Ses{b}.count = breakFix.Block.count; breakFix.Ses{b}.track = breakFix.Block.track;
    breakFix.Ses{b}.check = breakFix.Block.check; breakFix.Ses{b}.recent = breakFix.Block.recent;
    breakFix.Ses{b}.recalCount = breakFix.Block.recalCount;
    
    correctProp = 0;
    for tt = 1:nTrials
        if results.Block.correct(tt) == 1, correctProp = correctProp+1; end
    end
    correctPercent = 100*(correctProp/nTrials);
    blockBreak(wPtr, b, correctPercent);
    
    
    
    expData{b}.procedure = trialProc;
    expData{b}.accuracy = correctPercent;
    if params.stair.run
        sesStair1{b} = stair{1}; sesStair2{b} = stair{2}; sesStair3{b} = stair{3}; sesStair4{b} = stair{4};
        save(blockFileName, 'expData', 'results','sesNum', 'params', 'breakFix', 'stair');
    else
        save(blockFileName, 'expData', 'results','sesNum', 'params', 'breakFix');
    end
    
    if params.eye.run
    Eyelink('StopRecording'); Eyelink('Message', sprintf('Block # %d Complete', b));
    end
    
    
    
    
    Screen('Close');
end
expEndDisp(wPtr);


if params.stair.run
sesStair = struct('Stair1', {sesStair1}, 'Stair2', {sesStair2}, 'Stair3', {sesStair3}, 'Stair4', {sesStair4},'StimNumOnBlock', {params.block.StimNumOnBlock});
end

%%%%%------------- Save all experiment data ----------%%%%%
c = clock;
homedir = pwd; 
dirc = sprintf('results/%s/%s', params.save.expTypeDirName,initials);
mkdir(dirc); cd(dirc)
if params.eye.run; Eyelink('ReceiveFile', ELfileName, dirc,1); Eyelink('CloseFile'); Eyelink('Shutdown'); end
Screen('Close');
date = sprintf('Date:%02d/%02d/%4d  Time:%02d:%02d:%02i ', c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
saveExpFile = sprintf('%s_results_%s_ses%d_%02d_%02d_%4d_time_%02d_%02d_%02i.mat',...
                      params.save.fileName, initials, sesNum,...
                      c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
if params.stair.run                
    save(saveExpFile ,'expData', 'results','sesNum', 'params', 'date', 'sesStair', 'breakFix');
else
    save(saveExpFile ,'expData', 'results','sesNum', 'params', 'date', 'breakFix');
end
cd(homedir);
%%%%%--------------------------------------------------%%%%%

%delete('tmpData.mat');
Screen('LoadNormalizedGammaTable',params.screen.num,startclut,[]);
Screen('CloseAll');
disp('Done!');



