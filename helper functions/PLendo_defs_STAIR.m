function params = PLendo_defs_STAIR

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      screen params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screen = struct('num', {1}, 'rectPix',{[0 0  1280 960]}, 'dist', {58},...
                   'size', {[28.4,18]}, 'res', {[1280 960]},...
                   'calib_filename', {'0001_titchener_130226.mat'}); 
screen.centerPix = [(screen.rectPix(3)/2), (screen.rectPix(4)/2)];
    % In a new screen, run:
     %test = Screen('OpenWindow', screenVar.num, [], [0 0 1 1]); 
     %white = WhiteIndex(test);
     %black = BlackIndex(test);
     %Screen('Resolutions')
     %Screen('CloseAll');
white = 255; black = 0;
gray = (white+black)/2;
screen.bkColor = gray; screen.black = black; screen.white = white;

%Compute deg to pixels ratio:
ratio = degs2Pixels(screen.res, screen.size, screen.dist, [1 1]);
ratioX = ratio(1); screen.ratioX = ratio(1); 
ratioY = ratio(2); screen.ratioY = ratio(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      stimuli params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stim = struct('sizeDeg', {[2 2]}, 'cyclesPerImage', {8}, 'dur', {.06},...
              'possibleAngles', {[176, 184]}, 'num', {1},...
              'XdistDeg',{0}, 'YdistDeg', {0},'radiusDeg', {5},...
              'polarAng', {45},'bkColor', {screen.bkColor},'pilot', {0},...
              'trainLoc', {1},'orderType',{1});

stim.contLevels = [.02, .04, .08, .12, .16, .24, .32, .64]; 

stim.XdistDeg = stim.radiusDeg*cosd(stim.polarAng);
stim.YdistDeg = stim.radiusDeg*sind(stim.polarAng);

stim.XdistPix = deg2pix1Dim(stim.XdistDeg, ratioX); 
stim.YdistPix = deg2pix1Dim(stim.YdistDeg, ratioY);

stim.radiusPix = deg2pix1Dim(stim.radiusDeg, ratioX);

stim.sizePix = floor(degs2Pixels(screen.res, screen.size, screen.dist, stim.sizeDeg)); %{[100 100]}

rc1 = degs2Pixels(screen.res, screen.size, screen.dist, stim.sizeDeg); 
stim.rectPix =[0, 0, rc1]; 

% Define locations of stimuli in pixels
stimlocation.TL = nan(1,2); stimlocation.TR = nan(1,2); stimlocation.BL = nan(1,2); stimlocation.BR = nan(1,2); 
stimlocation.TL(1) = (screen.centerPix(1) - stim.XdistPix); stimlocation.TL(2) = (screen.centerPix(2) - stim.YdistPix);
stimlocation.TR(1) = (screen.centerPix(1) + stim.XdistPix); stimlocation.TR(2) = (screen.centerPix(2) - stim.YdistPix);
stimlocation.BL(1) = (screen.centerPix(1) - stim.XdistPix); stimlocation.BL(2) = (screen.centerPix(2) + stim.YdistPix);
stimlocation.BR(1) = (screen.centerPix(1) + stim.XdistPix); stimlocation.BR(2) = (screen.centerPix(2) + stim.YdistPix);

stim.locationsPix = [stimlocation.TL; stimlocation.TR; stimlocation.BL; stimlocation.BR]; %define all locations of stimuli in an array


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            fixation params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw fixation cross, sizeCross is the cross size,
% and sizeRect is the size of the rect surronding the cross
fixation = struct( 'color',{white},'dur', {.3}, 'penWidthPix', {2}, 'bkColor', screen.bkColor,...
                      'sizeCrossDeg', {[0.4 0.4]}, 'respColorVect', [0, 255, 0]);
                  
fixation.sizeCrossPix = degs2Pixels(screen.res, screen.size, screen.dist, fixation.sizeCrossDeg); % {15}
fixation.rectPix = [0 0 fixation.sizeCrossPix(1) fixation.sizeCrossPix(2)];
fixation.rectPix = CenterRectOnPoint(fixation.rectPix, screen.centerPix(1), screen.centerPix(2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Pre Cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The experiment is set to either be valid (type 1) or neutral (type 0)
preCue = struct('type', {0}); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Exogenous precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preCueExg = struct('rectDeg', {[0.4 0.1]}, 'color',{black}, 'bkColor', {screen.bkColor}, ...
                   'dur', {.2}, 'penWidthPix', {1}, 'dist2stimDeg',{2.55}, 'validity', {1.0}); 
sp1 = deg2pix1Dim(preCueExg.rectDeg(1), ratioX); sp2 = deg2pix1Dim(preCueExg.rectDeg(2), ratioY); 
preCueExg.rectPix = [0 0 sp1 sp2];

preCueExg.dist2stimPix = deg2pix1Dim(preCueExg.dist2stimDeg, ratioY);


preCueExg.YdistPix = preCueExg.dist2stimPix + stim.YdistPix;

preCueExglocation.TL = nan(1,2); preCueExglocation.TR = nan(1,2); preCueExglocation.BL = nan(1,2); preCueExglocation.BR = nan(1,2);
preCueExglocation.TL(1) = screen.centerPix(1) - stim.XdistPix; preCueExglocation.TL(2) = (screen.centerPix(2) - preCueExg.YdistPix);
preCueExglocation.TR(1) = screen.centerPix(1) + stim.XdistPix; preCueExglocation.TR(2) = (screen.centerPix(2) - preCueExg.YdistPix);
preCueExglocation.BL(1) = screen.centerPix(1) - stim.XdistPix; preCueExglocation.BL(2) = (screen.centerPix(2) + preCueExg.YdistPix);
preCueExglocation.BR(1) = screen.centerPix(1) + stim.XdistPix; preCueExglocation.BR(2) = (screen.centerPix(2) + preCueExg.YdistPix);

preCueExg.locationsPix = nan(4,2);
preCueExg.locationsPix = [preCueExglocation.TL(1), preCueExglocation.TL(2); 
                          preCueExglocation.TR(1), preCueExglocation.TR(2);
                          preCueExglocation.BL(1), preCueExglocation.BL(2);
                          preCueExglocation.BR(1), preCueExglocation.BR(2)];



%preCueExg.radiusPix = deg2pix1Dim(preCueExg.radiusDeg, ratioX); %ignore y ratio resolution TD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Neutral precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neutralCue = struct('rectDeg', {[0.2, 0.1]}, 'color',{black}, 'bkColor', {screen.bkColor}, ...
                   'dur', {0.2}, 'penWidthPix', {1}, 'dist2centerDeg', {0.9}); 
sp1 = deg2pix1Dim(neutralCue.rectDeg(1), ratioX); sp2 = deg2pix1Dim(neutralCue.rectDeg(2), ratioY); 


neutralCue.dist2centerPix = deg2pix1Dim(neutralCue.dist2centerDeg, ratioY);

neutralCue.locationsPix1 = [screen.centerPix(1), (screen.centerPix(2) - neutralCue.dist2centerPix)];
neutralCue.locationsPix2 = [screen.centerPix(1), (screen.centerPix(2) + neutralCue.dist2centerPix)];

neutralCue.rectPix = [0 0 sp1 sp2];
% 
% neutralCue.rectPix1 = CenterRectOnPoint([0 0 sp1 sp2], neutralCue.locationsPix1(1),neutralCue.locationsPix1(2));
% neutralCue.rectPix2 = CenterRectOnPoint([0 0 sp1 sp2], neutralCue.locationsPix2(1),neutralCue.locationsPix2(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ISI params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISI  = struct('preDur',{0.4}, 'postDur', {0.3}); 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %     box params
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% box = struct('sizePixels', {30}, 'color',{white}, 'slopeVpix', {300}, 'slopeHpix',{150},...
%              'bkColor', {screenVar.bkColor}, 'dur', {2}, 'penWidthPix', {5}); 
% box.locationsPix = stim.locationsPix;
% box.rectPix = CenterRectOnPoint([0 0 box.slopeHpix box.slopeVpix], stim.locationsPix(1,1), stim.locationsPix(1,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     post cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
postCue = struct('color',{black},'bkColor', {screen.bkColor}, 'dur', {.3}, 'penWidthPix', {1.5},...
                    'lengthDeg', {.75}, 'radiusDeg', {.65}); %, 'centerPix', {screenVar.centerPix});
%NOTE: length is proportional to distance of the stimulus (1.0)


postCue.centerXdistDeg = postCue.radiusDeg*cosd(stim.polarAng);
postCue.centerYdistDeg = postCue.radiusDeg*sind(stim.polarAng);

postCue.centerXdistPix = deg2pix1Dim(postCue.centerXdistDeg, ratioX);
postCue.centerYdistPix = deg2pix1Dim(postCue.centerYdistDeg, ratioY);

postCuelocCenter.TL = nan(1,2); postCuelocCenter.TR = nan(1,2); postCuelocCenter.BL = nan(1,2); postCuelocCenter.BR = nan(1,2);
postCuelocCenter.TL(1) = (screen.centerPix(1) - postCue.centerXdistPix); postCuelocCenter.TL(2) = (screen.centerPix(2) - postCue.centerYdistPix);
postCuelocCenter.TR(1) = (screen.centerPix(1) + postCue.centerXdistPix); postCuelocCenter.TR(2) = (screen.centerPix(2) - postCue.centerYdistPix);
postCuelocCenter.BL(1) = (screen.centerPix(1) - postCue.centerXdistPix); postCuelocCenter.BL(2) = (screen.centerPix(2) + postCue.centerYdistPix);
postCuelocCenter.BR(1) = (screen.centerPix(1) + postCue.centerXdistPix); postCuelocCenter.BR(2) = (screen.centerPix(2) + postCue.centerYdistPix);

postCue.centerPix = [postCuelocCenter.TL; 
                        postCuelocCenter.TR; 
                        postCuelocCenter.BL; 
                        postCuelocCenter.BR];
                    
                    
                    
postCue.endXDeg = postCue.lengthDeg*cosd(stim.polarAng);
postCue.endYDeg = postCue.lengthDeg*sind(stim.polarAng);

postCue.endXPix = deg2pix1Dim(postCue.endXDeg,ratioX);
postCue.endYPix = deg2pix1Dim(postCue.endYDeg,ratioY);

postCuelocEnd.TL = nan(1,2); postCuelocEnd.TR = nan(1,2); postCuelocEnd.BL = nan(1,2); postCuelocEnd.BR = nan(1,2);
postCuelocEnd.TL(1) = (postCue.centerPix(1,1) - postCue.endXPix); postCuelocEnd.TL(2) = (postCue.centerPix(1,2) - postCue.endYPix);
postCuelocEnd.TR(1) = (postCue.centerPix(2,1) + postCue.endXPix); postCuelocEnd.TR(2) = (postCue.centerPix(2,2) - postCue.endYPix);
postCuelocEnd.BL(1) = (postCue.centerPix(3,1) - postCue.endXPix); postCuelocEnd.BL(2) = (postCue.centerPix(3,2) + postCue.endYPix);
postCuelocEnd.BR(1) = (postCue.centerPix(4,1) + postCue.endXPix); postCuelocEnd.BR(2) = (postCue.centerPix(4,2) + postCue.endYPix);

postCue.endPix = nan(4,2);
postCue.endPix = [postCuelocEnd.TL; 
                     postCuelocEnd.TR; 
                     postCuelocEnd.BL; 
                     postCuelocEnd.BR];
                
                    
                    
% postCueVar.sizePix = deg2pix(postCueVar.sizeDeg, ratioX); % considers degrees only in x axis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     response params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbName('UnifyKeyNames');
responseVar = struct( 'allowedRespKeys', {['1', '2']},'allowedRespKeysCodes',{[0 0]}, 'dur',{.9}, 'cueTone', {500}); 
for i = 1:length(responseVar.allowedRespKeys)
    responseVar.allowedRespKeysCodes(i) = KbName(responseVar.allowedRespKeys(i));
end
% Note that the correctness of the resp will be computed according to the
% index in the array of resp so that allowedRespKeys(i) is the correct
% response of stim.possibleAngles(i)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Trial params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trial = struct('numTrialsInBlock', {100}, 'numTrialsPerLevel', {25});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Feedback params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feedback = struct('dur', {0.1}, 'durNoResp', {.4}, 'high', {300}, 'low', {150}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Block params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
block = struct('numBlocks', 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Stair params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startOri = 20;

stair = struct('run', {1}, 'numTrialsPerStaircase', {100}, 'numStaircases', {1},...
               'startOri', {startOri}, 'maxThresh', {30}, 'minThresh', {.05},...
               'startStepsize', {10},'minStepsize', {10^-3},'upDownRule',[1, 2]);
               
% if (trialVars.numTrialsInBlock/stairVars.numTrialsPerStaircase) ~= 4
%     error('# of Trials per Stair case should be FOUR TIMES the # of trials per block')
% end

%NOTE: # trials per staircase should be Half of # trials in block
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Eye Tracking params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eye = struct('run', {1}, 'fixRangeDeg', {2}, 'eyeTracked', {2}, 'recalHoldDur', {1},...
             'breakWaitDur', {.5});
         
eye.dots.color = (.25*white);

eye.fixRangePix = degs2Pixels(screen.res, screen.size, screen.dist, eye.fixRangeDeg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Text params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text = struct('color', black, 'bkColor', gray, 'size', 24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Save Data params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save = struct('fileName', {'PLendo_STAIR'}, 'expTypeDirName', {'results'}, 'SubjectInitials', {'DB'});


%-------------------------------------------------------------------------%
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%                        TOTAL ALL params                                 %
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%-------------------------------------------------------------------------%
global params;
params = struct('screen', screen, 'stim', stim, 'fixation', fixation, 'preCueExg', preCueExg, ...
                'postCue', postCue, 'response', responseVar, 'trial', trial,...
                'block', block, 'feedback', feedback, 'ISI', ISI, 'neutralCue', neutralCue,...
                'text', text,'preCue', preCue, 'save', save, 'stair', stair, 'eye', eye); 

end
