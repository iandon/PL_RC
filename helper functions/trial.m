function [fixBreak, correctTrial, resp, timestamp] = trial(wPtr, blockNum, trialNum, trialProc)
global params; 

stimLocNum = trialProc.locNum;
stimLocationPix = params.stim.locationsPix(stimLocNum,:);
targetOri = trialProc.ori;
correctAns = trialProc.ans;
targetTexture = trialProc.stimStruct.targetTex;

if params.preCue.type; preCueTime = params.preCueExg.dur; else preCueTime = params.neutralCue.dur; end
cumulativeDur = struct('fixation', (params.fixation.dur),...
                       'preCue', (params.fixation.dur + preCueTime),...
                       'ISIpre', (params.fixation.dur + preCueTime + params.ISI.preDur),...
    'stim', (params.fixation.dur + preCueTime + params.ISI.preDur + params.stim.dur),...
    'ISIpost', (params.fixation.dur + preCueTime + params.ISI.preDur + params.stim.dur + params.ISI.postDur),...
    'total', (params.fixation.dur + preCueTime + params.ISI.preDur + params.stim.dur + params.ISI.postDur + params.postCue.dur));


if params.eye.run
    Eyelink('StartRecording');
    Eyelink('Message', sprintf('StartTrial_Ses_%d_Block_%d_Trial_%d_angle_%d_loc_%d_val_%d',...
        params.ses.sesNum,blockNum, trialNum,targetAngle, stimLocNum, validity));
end

pressQ = 0;
[keyIsDown, secs, keyCode] = KbCheck;
fixation(wPtr); Screen('Flip', wPtr); WaitSecs(.300);

%Trial will not start until observer fixates. Additionally, after 20ms,
%they will be instructed to fixate

%fixBreakObsvMSG = sprintf('Please fixate on the cross');
if params.eye.run
    fixBreakPRE = 1; FirstFixClock = tic;
    keyIsDown = 0;
    while fixBreakPRE && ~pressQ
        tsFirstFix = toc(FirstFixClock); [fixBreakPRE] = fixCheck; fixation(wPtr);
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown == 1; pressQ = keyCode(KbName('Q')); end
        if tsFirstFix > .02
            fixation(wPtr, 0)
            %Screen('TextSize', wPtr, (params.textVars.size*(2/3)));
            %Screen('DrawText', wPtr, fixBreakObsvMSG, params.screenVar.centerPix(1)-90, params.screenVar.centerPix(2)-50,[0 0 0]);
        end
        Screen('Flip', wPtr);
        if tsFirstFix > 2
            fixBreak = 1; correctTrial = []; resp = []; timestamp = [];
            Eyelink('Message', sprintf('DID NOT FIXATE BEFORE TRIAL'));
            clear FirstFixClock tsFirstFix;
            return;
        end
        [fixBreakPRE] = fixCheck;
    end
end

if  pressQ == 1
    Screen('CloseAll'); clear FirstFixClock tsFirstFix; Eyelink('StopRecording');
    error('Experiment stopped by user!');
end

clear FirstFixClock tsFirstFix;


fixBreak = 0;
ts = 0;
trialStart = tic;

if params.eye.run, chk = 1; else chk = 3; end
trlStart = chk; preCueON = chk; preCueOFF = chk; stimON = chk; stimOFF = chk; postCueON = chk;
if params.eye.run, [fixBreak] = fixCheck; end
while ~fixBreak && (ts < cumulativeDur.total) && ~pressQ
    ts = toc(trialStart);
    [keyIsDown, secs, keyCode] = KbCheck; pressQ = keyCode(KbName('Q'));
    if ts < cumulativeDur.fixation
        if trlStart == 1, Eyelink('Message', sprintf('Trial Start')); end
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.fixation = ts;
        if trlStart < 2, trlStart = trlStart + 1; end
    elseif ts < cumulativeDur.preCue
        if preCueON == 1, Eyelink('Message', sprintf('PreCue ON')); end
        fixation(wPtr); preCue(wPtr, stimLocNum); Screen('Flip', wPtr);
        timestamp.preCue = ts;
        if preCueON < 2, preCueON = preCueON + 1; end
    elseif ts < cumulativeDur.ISIpre
        if preCueOFF == 1, Eyelink('Message', sprintf('PreCue OFF')); end
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.ISIpre = ts;
        if preCueOFF < 2 , preCueOFF = preCueOFF + 1; end
    elseif ts < cumulativeDur.stim
        if stimON == 1, Eyelink('Message', sprintf('Stimulus ON')); end
        presentStimuli(wPtr, stimLocationPix, targetTexture);
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.stim = ts;
        if stimON < 2, stimON = stimON + 1; end
    elseif ts < cumulativeDur.ISIpost
        if stimOFF == 1, Eyelink('Message', sprintf('Stimulus OFF')); end
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.ISIpost = ts;
        if stimOFF < 2, stimOFF = stimOFF + 1; end
    elseif ts < cumulativeDur.total %postCue -> last phase on which we care about fixation
        if postCueON == 1, Eyelink('Message', sprintf('PostCue ON')); end
        postCue(wPtr, targetOri); 
        fixation(wPtr); Screen('Flip', wPtr);
        timestamp.postCue = ts;
        if postCueON < 2, postCueON = postCueON + 1; end
    end
    if params.eye.run, [fixBreak] = fixCheck; end
end
if params.eye.run && ~fixBreak, Eyelink('Message', sprintf('Fixation Check Window Closed')); end

if params.eye.run
    Eyelink('StopRecording');
end

if pressQ
    Screen('CloseAll'); error('Experiment stopped by user!');
end

if fixBreak
    Eyelink('Message', sprintf('TRIAL INCOMPLETE'));
    timestamp = []; resp = []; correctTrial = []; fixation(wPtr); tsBrkMsg = 0; BrkTime = tic; rng = -5:0.2:5;
    while tsBrkMsg < params.eye.breakWaitDur;
        tsBrkMsg = toc(BrkTime); %shadeX = rng(ceil(tsBrkMsg*100));
        %txtShade = params.screenVar.bkColor - ((params.screenVar.bkColor*(10/4))*normpdf(shadeX,0,1));
        %Screen('TextSize', wPtr, (params.textVars.size*(2/3)));
        %Screen('DrawText', wPtr, fixBreakObsvMSG, params.screenVar.centerPix(1)-90, params.screenVar.centerPix(2)-50,[txtShade txtShade txtShade]);
        fixation(wPtr, 0); Screen('Flip', wPtr);
    end
    clear BrkTime
else
    
    if params.eye.run, Eyelink('Message', sprintf('Post Cue OFF')); end
    fixation(wPtr); Screen('Flip', wPtr); resp = response;
    correctTrial = checkResp(resp, correctAns); audFB(correctTrial);
    timestamp.resp = ts;
end



if params.eye.run
    Eyelink('Message', sprintf('Trial End'));
    Eyelink('Message', sprintf('EndTrial_Ses_%d_Block_%d_Trial_%d_direction_%d_loc_%d',...
        params.ses.sesNum, blockNum, trialNum, targetAngle, stimLocNum));
end

clear trialStart
end
