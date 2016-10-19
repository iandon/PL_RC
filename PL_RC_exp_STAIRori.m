clear all; 
addpath(genpath('helper functions'));
addpath(genpath('mgl'));

PL_RC_params;

global params; params.practice.run = 0;

params.eye.run = 0;
% params.stair.run = 0; 
params.stim.colorTest = 0;



%% get subject info and check if it is the right subject
%initials = 'test'; sesNum = '0';

testQ = input('Testing code (0), or running exp (1)? \n', 's'); testQ = str2double(testQ);

switch testQ
    case 0
        initials = 'IMD'; initials = upper(initials);
        params.subj.gender = 'M';
        params.subj.age = 26;
        sesNum = 0; params.save.sesNum = sesNum; params.ses.sesNum = sesNum;
        sesTypequest = input('Test(0) or Training(1)? \n', 's'); sesType = str2double(sesTypequest); params.save.sesType = sesType;
    case 1
        initials = input('Please enter subject initials: \n', 's'); initials = upper(initials);
        params.subj.gender = input('Please enter subject GENDER: M/F/O \n', 's');
        params.subj.age = input('Please enter subject AGE: \n', 's');
        sesNumquest = input('Please enter the session number:\n', 's'); sesNum = str2double(sesNumquest); params.save.sesNum = sesNum; params.ses.sesNum = sesNum;
        sesTypequest = input('Test(0) or Training(1)? \n', 's'); sesType = str2double(sesTypequest); params.save.sesType = sesType;
        % TRAIN LOCATION is in Plexp_defs file -> Make sure it is the right one!
        if (sesNumquest > 1) && ~strcmp(initials,params.save.SubjectInitials),
            error('Check if settings file used is correct for this participant');
        end
end

%% set additional  variables
if sesType == 0; params.preCue.type = 0; end 

[numBlocks, nTrials] = initBlockVars(sesType);

[wPtr, startclut] = initScreenExp;


%%%% ------------  Start experiment  ----------%%%%%
NanMtxBlock = nan(1, nTrials);
results.Ses = cell(numBlocks,1);
sesStair1 = cell(numBlocks,1); sesStair2 = cell(numBlocks,1);sesStair3 = cell(numBlocks,1);sesStair4 = cell(numBlocks,1);
expData = cell(numBlocks, 1);
stair = cell(numBlocks,1);
%% initialize eyetracker

if params.eye.run
    Eyelink('Initialize');
    el = prepEyelink(wPtr);
    ELfileName = sprintf('%s%d', initials, sesNum); edfFileStatus = Eyelink('OpenFile', ELfileName);
    if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...'); return; end
    cal = EyelinkDoTrackerSetup(el);
end

%halfWay = 0;halfWaySes = 0;

%% main experimental loop
for b = 1:numBlocks
    [trialProc] = calcTrialsVars(b);
    instructions(wPtr);
    
    driftCorr = 1;
    if params.eye.run && (b > 1)
        driftCorr = EyelinkDoDriftCorrect(el, params.screen.centerPix(1), params.screen.centerPix(2), 1, 1);
    end
    if params.eye.run && ~driftCorr, EyelinkDoDriftCorrect(el, 'c'); end
    
    clear results.Block breakFix.Block
    results.Block = struct('rt',{NanMtxBlock},...
                           'key', {NanMtxBlock},...
                           'correct',{NanMtxBlock});

    breakFix.Block = struct('check', {[]}, 'track', {[]}, 'count', {0}, 'recent', {0});
    breakFix.Block.count = 0; breakFix.Block.recent = 0; breakFix.Block.recalCount = 0;

    timestamp = cell(nTrials, 1); halfWay = 0;
    j = 0; nTrialsUPDATE = nTrials;
    
    stair{b} = upDownStaircase(params.stair.upRule,params.stair.downRule, params.stair.startOri,...
                               [params.stair.startStepsize,params.stair.minStepsize],'levitt');
    stair{b}.minThreshold = params.stair.minThresh; stair{b}.maxThreshold = params.stair.maxThresh;
    
%   trial loop
    while j < nTrialsUPDATE
        j = j + 1;
        i = floor(j) - breakFix.Block.count;
        recal = 0;
        
        switch i
%             case floor(nTrials/4), quarterBreak(wPtr,1)
            case floor(nTrials/2), quarterBreak(wPtr,2)
%             case floor(nTrials*(3/4)), quarterBreak(wPtr,3)
        end
         
        trialProc{i}.ori = stair{b}.threshold*trialProc{i}.oriDir;
        
        trialProc{i}.stimStruct = makeStimulusStruct(params.screen, params.stim, params.noise, trialProc{i}.ori, trialProc{i}.presAbs,trialProc{i}.contrast);
        
        [breakFix.Block.check, correctTrial, respTrial, trialProc{i}.timestamp]...
                                         = trial(wPtr, b, i, trialProc{i});
        if breakFix.Block.check == 1
            beep3(237,157,.1,0);
            nTrialsUPDATE = nTrialsUPDATE + 1;
            breakFix.Block.count = breakFix.Block.count + 1;
            [trialProc, recal, breakFix.Block.recent, breakFix.Block.track]...
                           = breakProc(trialProc, nTrials, i, j, breakFix);
                       
            stair{b} = upDownStaircase(stair{b}, (correctTrial==1)); %update staircase
        else    %Note: if there is no fixation break, the trial is not taken into account for stair casing
            results.Block.rt(i)      = respTrial.rt; 
            results.Block.key(i)     = respTrial.key(1);
            results.Block.correct(i) = correctTrial;
%             Screen('Close');
        end
        
        if recal; breakFix.Block.recalCount = breakFix.Block.recalCount + 1; recalProc(el, wPtr); end
    end
    
    if params.eye.run == 1, Eyelink('Message', '~*~*~*~*BLOCK END*~*~*~*~');end
    dircB = sprintf('results/%s/%s/Block%d', params.save.expTypeDirName,initials,b);
    blockFileName = sprintf('%s_%s_BlockData_Ses%d_Block%d.mat', params.save.fileName, initials, sesNum, b);
    
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
    if params.stair.run, save(blockFileName, 'expData', 'results','sesNum', 'params', 'breakFix', 'stair');
    else save(blockFileName, 'expData', 'results','sesNum', 'params', 'breakFix');
    end
    
    if params.eye.run, Eyelink('StopRecording'); Eyelink('Message', sprintf('Block # %d Complete', b)); end
    
%     Screen('Close');
end
expEndDisp(wPtr);

%% ------------- Save all experiment data ---------- %%
c = clock;
homedir = pwd; 
dirc = sprintf('results/%s', params.save.expTypeDirName,initials);
mkdir(dirc); cd(dirc)
if params.eye.run; Eyelink('ReceiveFile', ELfileName, dirc,1); Eyelink('CloseFile'); Eyelink('Shutdown'); end
Screen('Close');
date = sprintf('Date:%02d/%02d/%4d  Time:%02d:%02d:%02i ', c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
saveExpFile = sprintf('%s_results_%s_ses%d_%02d_%02d_%4d_time_%02d_%02d_%02i.mat',...
                      params.save.fileName, initials, sesNum,...
                      c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
if params.stair.run                
    save(saveExpFile ,'expData', 'results','sesNum', 'params', 'date', 'stair', 'breakFix');
else
    save(saveExpFile ,'expData', 'results','sesNum', 'params', 'date', 'breakFix');
end
cd(homedir);
%%%%%--------------------------------------------------%%%%%

%delete('tmpData.mat');
Screen('LoadNormalizedGammaTable',params.screen.num,startclut,[]);
Screen('CloseAll');
disp('Done!');



