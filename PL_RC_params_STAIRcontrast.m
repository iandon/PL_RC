function params = PL_RC_params_STAIRcontrast


%%
%change for each subj
trainLoc = 1;                 % 1 = left, 2 = right
orderType = 1;                % 1 = tLoc first, 2 = uLoc first
tOri = 0;                     % 0 or 90 deg
preCueType = 0;               % 1 = attention, 0 = neutral


contThresh = .6;

initials = 'IMD';

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      screen params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screen = struct('rectPix',{[0 0  1280 960]}, 'dist', {57},...
                'size', {[40,  30]}, 'resolution', {[1280 960]},...
                'calib_filename', {'Carrasco_L1_SonyGDM5402_sRGB_calibration_02292016.mat'}); 
screen.centerPix = [(screen.rectPix(3)/2), (screen.rectPix(4)/2)];
    % In a new screen, run:
     %test = Screen('OpenWindow', screenVar.num, [], [0 0 1 1]); 
     %white = WhiteIndex(test);
     %black = BlackIndex(test);
     %Screen('Resolutions')
%      %Screen('CloseAll');
% white = 255; black = 0;
% gray = (white+black)/2;
% screen.bgColor = gray; screen.black = black; screen.white = white;

%Compute deg to pixels ratio:
ratio = degs2Pixels(screen.resolution, screen.size, screen.dist, [1 1]);
ratioX = ratio(1); screen.ratioX = ratio(1); 
ratioY = ratio(2); screen.ratioY = ratio(2);


screen.width = screen.size(1); screen.height = screen.size(2);

screens=Screen('Screens');
screen.num=max(screens);
screen.white=WhiteIndex(screen.num);
screen.black=BlackIndex(screen.num);
screen.gray=round((screen.white+screen.black)/2);
screen.inc=screen.white-screen.gray;
screen.bgColor=screen.gray;

% screen.resolution=[screen.windowRect(3) screen.windowRect(4)];


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      stimuli params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

uOri_InterCardinal = [45,135];

stim = struct('sizeDeg', {[3 3]}, 'dur', {.06},...
              'possibleOri', {[tOri, tOri, uOri_InterCardinal]}, 'num', {1},...
              'XdistDeg',{0}, 'YdistDeg', {0},'radiusDeg', {5},...
              'polarAng', {0},'bgColor', {screen.bgColor},'pilot', {0},...
              'trainLoc', {trainLoc},'orderType',{orderType},'contrast',{contThresh},...
              'gratingf',1.5,...
              'flatSpread', .75);

stim.gratingsize = stim.sizeDeg(1);
stim.apersize = stim.gratingsize;
stim.aperpsize  = angle2pix(screen,stim.apersize);
stim.gratingpsize  = angle2pix(screen,stim.gratingsize);

stim.XdistDeg = stim.radiusDeg*cosd(stim.polarAng);
stim.YdistDeg = stim.radiusDeg*sind(stim.polarAng);

stim.XdistPix = deg2pix1Dim(stim.XdistDeg, ratioX); 
stim.YdistPix = deg2pix1Dim(stim.YdistDeg, ratioY);

stim.radiusPix = deg2pix1Dim(stim.radiusDeg, ratioX);

stim.sizePix = floor(degs2Pixels(screen.resolution, screen.size, screen.dist, stim.sizeDeg)); %{[100 100]}

rc1 = degs2Pixels(screen.resolution, screen.size, screen.dist, stim.sizeDeg); 
stim.rectPix =[0, 0, rc1]; 

% Define locations of stimuli in pixels
stimlocation.L = nan(1,2); stimlocation.R = nan(1,2);
stimlocation.L(1) = (screen.centerPix(1) - stim.XdistPix); stimlocation.L(2) = (screen.centerPix(2) - stim.YdistPix);
stimlocation.R(1) = (screen.centerPix(1) + stim.XdistPix); stimlocation.R(2) = (screen.centerPix(2) - stim.YdistPix);

stim.locationsPix = [stimlocation.L; stimlocation.R]; %define all locations of stimuli in an array



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            noise params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noise.freqDiff_factor = 2; 

noise.fre_low = stim.gratingf/noise.freqDiff_factor;
noise.fre_high = stim.gratingf*noise.freqDiff_factor;


noise.size = stim.apersize;
noise.fre_low = noise.fre_low;
noise.fre_high = noise.fre_high;
noise.ori_base = 0;
noise.ori_diff = 180;
noise.contrast = 0.2;
noise.fixcontrast = 1;

noise.psize = angle2pix(screen,noise.size);

noise.ori_low = noise.ori_base-(noise.ori_diff/2);
noise.ori_high = noise.ori_base+(noise.ori_diff/2);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            fixation params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw fixation cross, sizeCross is the cross size,
% and sizeRect is the size of the rect surronding the cross
fixation = struct('color',{screen.black},'dur', {.3}, 'penWidthPix', {3.5}, 'bgColor', screen.bgColor,...
                  'sizeCrossDeg', {[0.5 0.5]}, 'respColorVect', [0, 255, 0]);
                  
fixation.sizeCrossPix = degs2Pixels(screen.resolution, screen.size, screen.dist, fixation.sizeCrossDeg); % {15}
fixation.rectPix = [0 0 fixation.sizeCrossPix(1) fixation.sizeCrossPix(2)];
fixation.rectPix = CenterRectOnPoint(fixation.rectPix, screen.centerPix(1), screen.centerPix(2));


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Pre Cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The experiment is set to either be valid (type 1) or neutral (type 0)
preCue = struct('type', {preCueType}); 


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Exogenous precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
preCueExg = struct('rectDeg', {[0.4 0.1]}, 'color',{screen.black}, 'bgColor', {screen.bgColor}, ...
                   'dur', {.06}, 'penWidthPix', {1}, 'dist2stimDeg',{3.5}, 'validity', {1.0}); 
sp1 = deg2pix1Dim(preCueExg.rectDeg(1), ratioX); sp2 = deg2pix1Dim(preCueExg.rectDeg(2), ratioY); 
preCueExg.rectPix = [0 0 sp1 sp2]; 

preCueExg.dist2stimPix = deg2pix1Dim(preCueExg.dist2stimDeg, ratioY);


preCueExg.YdistPix = preCueExg.dist2stimPix + stim.YdistPix;

preCueExglocation.L = nan(1,2); preCueExglocation.R = nan(1,2);
preCueExglocation.L(1) = screen.centerPix(1) - stim.XdistPix; preCueExglocation.L(2) = (screen.centerPix(2) - preCueExg.YdistPix);
preCueExglocation.R(1) = screen.centerPix(1) + stim.XdistPix; preCueExglocation.R(2) = (screen.centerPix(2) - preCueExg.YdistPix);

preCueExg.locationsPix = nan(4,2);
preCueExg.locationsPix = [preCueExglocation.L(1), preCueExglocation.L(2); 
                          preCueExglocation.R(1), preCueExglocation.R(2)];



%preCueExg.radiusPix = deg2pix1Dim(preCueExg.radiusDeg, ratioX); %ignore y ratio resolution TD

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Neutral precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neutralCue = struct('rectDeg', {[0.2, 0.1]}, 'color',{screen.black}, 'bgColor', {screen.bgColor}, ...
                   'dur', {0.06}, 'penWidthPix', {1}, 'dist2centerDeg', {0.9}); 
sp1 = deg2pix1Dim(neutralCue.rectDeg(1), ratioX); sp2 = deg2pix1Dim(neutralCue.rectDeg(2), ratioY); 


neutralCue.dist2centerPix = deg2pix1Dim(neutralCue.dist2centerDeg, ratioY);

neutralCue.locationsPix1 = [screen.centerPix(1), (screen.centerPix(2) - neutralCue.dist2centerPix)];
neutralCue.locationsPix2 = [screen.centerPix(1), (screen.centerPix(2) + neutralCue.dist2centerPix)];

neutralCue.rectPix = [0 0 sp1 sp2];

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ISI params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISI  = struct('preDur',{0.04}, 'postDur', {0.3}); 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     post cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
postCue = struct('color',{screen.white},'bgColor', {screen.bgColor}, 'dur', {.6}, 'penWidthPix', {fixation.penWidthPix},...
                 'radiusDeg', {.65}); %, 'centerPix', {screenVar.centerPix});


%%             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     response params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbName('UnifyKeyNames');
response = struct('dur',{.9}, 'cueTone', {500});
response.allowedRespKeys = {'1!','2@'};
for i = 1:length(response.allowedRespKeys)
    response.allowedRespKeysCodes(1,i) = KbName(response.allowedRespKeys{i});
end
% Note that the correctness of the resp will be computed according to the
% index in the array of resp so that allowedRespKeys(i) is the correct
% response of stim.possibleAngles(i)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Trial params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trial = struct('numTrialsInBlock', {120}, 'numTrialsPerLevel', {15});

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Feedback params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
feedback = struct('dur', {0.1}, 'durNoResp', {.4}, 'high', {300}, 'low', {150});

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Block params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
block = struct('numBlocks', 10);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Stair params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startCont = .9;

stair = struct('run', {1}, 'numTrialsPerStaircase', {trial.numTrialsInBlock}, 'numStaircases', {1},...
               'startContrast', {startCont}, 'maxThresh', {1}, 'minThresh', {.005},...
               'startStepsize', {.4},'minStepsize', {10^-3},'upRule',1,'downRule',3);
               
% if (trialVars.numTrialsInBlock/stairVars.numTrialsPerStaircase) ~= 4
%     error('# of Trials per Stair case should be FOUR TIMES the # of trials per block')
% end

%NOTE: # trials per staircase should be Half of # trials in block
 
%%      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Eye Tracking params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eye = struct('run', {1}, 'fixRangeDeg', {2}, 'eyeTracked', {2}, 'recalHoldDur', {1},...
             'breakWaitDur', {.5});
         
eye.dots.color = (.25*white);

eye.fixRangePix = degs2Pixels(screen.resolution, screen.size, screen.dist, eye.fixRangeDeg);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Text params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text = struct('color', screen.black, 'bgColor', screen.gray, 'size', 24);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Save Data params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save = struct('fileName', {'PL_RC_contStair'}, 'expTypeDirName', {'results'}, 'SubjectInitials', {initials});


%%
%-------------------------------------------------------------------------%
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%                        TOTAL ALL params                                 %
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%-------------------------------------------------------------------------%
global params;
params = struct('screen', screen, 'stim', stim, 'fixation', fixation, 'preCueExg', preCueExg, ...
                'postCue', postCue, 'response', response, 'trial', trial,...
                'block', block, 'feedback', feedback, 'ISI', ISI, 'neutralCue', neutralCue,...
                'text', text,'preCue', preCue, 'save', save, 'stair', stair, 'eye', eye,'noise',noise); 

end
