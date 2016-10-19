function [stimStruct] = makeStimulusStruct(scr, stimPar, noisePar, targetOri, targetPresent,contrast)
% Create a data structure for filtered noise, with or without an embedded
% grating
%
% scr: screen parameters
% stimPar: parameters corresponding to grating
% noisePar: parameters corresponding to grating
% targetOri: orientation of the grating
% targetPresent: presence or absesnce of grating (1=present, 2=absent)
%
%
%
% Ian Donovan 10/07/16

%% grating 

if ieNotDefined('contrast'),contrast = stimPar.contrast;end


stimStruct.phase = rand*2*pi;

switch targetPresent
    case 1
        [stimStruct.grating, stimStruct.gratingCarrier, stimStruct.gratingModulator] =  CreateRaisedGrating(scr, stimPar.gratingsize, stimPar.gratingf, stimPar.flatSpread, stimStruct.phase, contrast, targetOri, 0);
    case 0
        [stimStruct.grating, stimStruct.gratingCarrier, stimStruct.gratingModulator] =  CreateRaisedGrating(scr, stimPar.gratingsize, stimPar.gratingf, stimPar.flatSpread, stimStruct.phase, 0, targetOri, 0);
end

%% filtered noise

[stimStruct.filterednoise, stimStruct.fFilter, stimStruct.oFilter] = CreateFilteredNoise(scr, noisePar.size, noisePar.fre_low, noisePar.fre_high, noisePar.ori_low, noisePar.ori_high, noisePar.contrast, noisePar.fixcontrast);

%% combine into texture
temp_target = .5 + stimStruct.grating*.5 + stimStruct.filterednoise;
target = min(max(temp_target,0),1);
mask = CreateCircularAperture(stimPar.aperpsize, stimPar.flatSpread);


stimStruct.targetTex = Screen('MakeTexture',scr.wPtr,cat(3,target,mask),[],[],1);


end