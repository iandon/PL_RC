
%% set params

%screen params
scr.dist =57;	%viewing distance in cm
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


%target params;
sizeStim = 4;

stiPar = struct('gaborsiz',sizeStim,...
                'apersiz',sizeStim+(.1*sizeStim),...
                'gaborstd',(.4*sizeStim),...
                'gaborf',1.5,...
                'sinsiz',sizeStim/4);

stiPar.aperpsiz  = angle2pix(scr,stiPar.apersiz);
stiPar.gaborpsiz  = angle2pix(scr,stiPar.gaborsiz);
stiPar.sinpsiz  = angle2pix(scr,stiPar.sinsiz);

targetContrast = .8;
targetOri = 0;
phase = rand*(2*pi);
stiPar.gaborPosition = scr.resolution*.5; %centered

gabor  = CreateGabor(scr, stiPar.apersiz, stiPar.gaborstd,stiPar.gaborf,phase,targetContrast,targetOri);

gaborrct = CenterRectOnPoint([0,0,stiPar.gaborpsiz,stiPar.gaborpsiz],stiPar.gaborPosition(1,1), stiPar.gaborPosition(1,2));


sprintf('Finished creating Gabor')

% noise params


noisePar = struct('noisesiz',apersiz,...
                  'fre_low',.75,...
                  'fre_high',3,...
                  'ori_base',0,...
                  'ori_diff',90,...
                  'contrast',0,...
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


sprintf('Finished creating Mask')

%%
% display(['noise rmsContrast= ' num2str(std(noise(:))/.5)]);

temp_target = .5+gabor*.5+filterednoise;
% stimulus(block).outlier(targetloc,Idx) = sum(temp_target(:)>1 | temp_target(:)<0);
target = min(max(temp_target,0),1);
mask  = CreateCircularApertureSin(scr, stiPar.gaborsiz, stiPar.sinsiz, [], stiPar.apersiz);
sprintf('Finished creating Aperture')


targetTex = Screen('MakeTexture',scr.windowPtr,cat(3,target,mask),[],[],1);

sprintf('Finished creating Texture')

Screen('BlendFunction', scr.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('DrawTexture',scr.windowPtr,targetTex,[],gaborrct);
Screen('Flip',scr.windowPtr);


sprintf('Stimulus should be ON')


closeScrQ = input('Close screen? (1) or Present another? (ENTER)', 's');
switch closeScrQ
    case '1'
        Screen('Close',scr.windowPtr)
        clear all
end


