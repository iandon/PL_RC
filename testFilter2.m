
%% set params

%screen params

% initScreenQ = 1;

close all

if initScreenQ
scr.dist = 57;	%viewing distance in cm
scr.width = 37.59; scr.height = 29.99;
initx = 0;
inity = 0;

AssertOpenGL;
screens=Screen('Screens');
screenNumber=max(screens);
scr.white=WhiteIndex(screenNumber);
scr.black=BlackIndex(screenNumber);
scr.gray=round((scr.white+scr.black)/2);
scr.inc=scr.white-scr.gray;
scr.bgColor=scr.gray;


[scr.windowPtr, scr.windowRect]=Screen(screenNumber,'OpenWindow',scr.bgColor);
scr.resolution=[scr.windowRect(3) scr.windowRect(4)];

end

%target params

sizeStim = 3;

stiPar = struct('gratingsiz',sizeStim,...
                'apersiz',sizeStim,...%+(.1*sizeStim),...
                'gratingf',1.5,...
                'edgeTransition', sizeStim*1.5,...%sizeStim*1.7,...
                'flatSpread', .75,...
                'contrast', .4);
%                 'sinsiz',sizeStim/4,...
%                 'sinpower', 8,... %default = 5

stiPar.aperpsiz  = angle2pix(scr,stiPar.apersiz);
stiPar.gratingpsiz  = angle2pix(scr,stiPar.gratingsiz);
% stiPar.sinpsiz  = angle2pix(scr,stiPar.sinsiz);
% stiPar.flatSpread = stiPar.aperpsiz*.8;


oriPossible = [0, 90, 45];

targetOri = oriPossible(round(rand*(length(oriPossible)-1))+1);
disp(sprintf('Target Ori = %d',targetOri))

phase = rand*(2*pi);
stiPar.gratingPosition = scr.resolution*.5; %centered

% gabor  = CreateGabor(scr, stiPar.apersiz, stiPar.gaborstd,stiPar.gaborf,phase,targetContrast,targetOri);
[grating, gratingCarrier, gratingModulator] =  CreateRaisedGrating(scr, stiPar.gratingsiz, stiPar.gratingf, stiPar.edgeTransition, stiPar.flatSpread, phase, stiPar.contrast, targetOri);


gratingrct = CenterRectOnPoint([0,0,stiPar.gratingpsiz,stiPar.gratingpsiz],stiPar.gratingPosition(1,1), stiPar.gratingPosition(1,2));


disp('Finished creating Grating')

% noise params

freqDiff_factor = 2; 

fre_low = stiPar.gratingf/freqDiff_factor;
fre_high = stiPar.gratingf*freqDiff_factor;


noisePar = struct('noisesiz',stiPar.apersiz,...
                  'fre_low',fre_low,...
                  'fre_high',fre_high,...
                  'ori_base',0,...
                  'ori_diff',90,...
                  'contrast',0.2,...
                  'fixcontrast',1);


noisePar.noisepsiz = angle2pix(scr,noisePar.noisesiz);

noisePar.ori_low = noisePar.ori_base-noisePar.ori_diff;
noisePar.ori_high = noisePar.ori_base+noisePar.ori_diff;

fixcontrast = 1;

[filterednoise, fFilter, oFilter] = CreateFilteredNoise(scr, noisePar.noisesiz, noisePar.fre_low, noisePar.fre_high, noisePar.ori_low, noisePar.ori_high, noisePar.contrast, noisePar.fixcontrast);

% figure, clf,
% plot(fFilter)
% figure, clf,
% plot(oFilter)


disp('Finished creating Noise')

%%
% display(['noise rmsContrast= ' num2str(std(noise(:))/.5)]);

temp_target = .5+grating*.5+filterednoise;
% stimulus(block).outlier(targetloc,Idx) = sum(temp_target(:)>1 | temp_target(:)<0);
target = min(max(temp_target,0),1);
% mask  = CreateCircularApertureSin(scr, stiPar.gratingsiz, stiPar.sinsiz, stiPar.sinpower, stiPar.apersiz);
% mask = CreateCircularAperture(stiPar.aperpsiz, stiPar.flatSpread, stiPar.edgeTransition);
mask = CreateCircularAperture(stiPar.aperpsiz, stiPar.flatSpread);
disp('Finished creating Mask')


targetTex = Screen('MakeTexture',scr.windowPtr,cat(3,target,mask),[],[],1);

disp('Finished creating Texture')

Screen('BlendFunction', scr.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('DrawTexture',scr.windowPtr,targetTex,[],gratingrct);
Screen('Flip',scr.windowPtr);
disp('Stimulus should be ON')

figure('position',[0 100 800 300]),clf, hold on, subplot(1,3,1)
mesh(mask),title('Aperture')
xlabel('X Pixel Loc')
ylabel('Y Pixel Loc')
zlabel('Brightness')

subplot(1,3,2), hold on, 
mesh(target),title('Target')
% title(sprintf('Spread DVA = % d  &  Edge STD = %d ', flatSpreadVisRadius, edgeTransitionSTD))
xlabel('X Pixel Loc')
ylabel('Y Pixel Loc')
zlabel('Brightness')

subplot(1,3,3)
mesh(target.*((mask))),title('Target X Mask')
% title(sprintf('Spread DVA = % d  &  Edge STD = %d ', flatSpreadVisRadius, edgeTransitionSTD))
xlabel('X Pixel Loc')
ylabel('Y Pixel Loc')
zlabel('Brightness')
hold off



closeScrQ = input('Close screen? (1)   Present another? (2)   Do nothing? (ENTER)', 's');
switch closeScrQ
    case '1'
        Screen('Close',scr.windowPtr)
        clear all
        close all
        initScreenQ = 1;
    case '2'
        initScreenQ = 0;
        testFilter2
end


