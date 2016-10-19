function [stimStruct] = makeStimulusStruct(scr, stiPar, noisePar, targetOri, targetPresent)
% Create a data structure for filtered noise, with or without an embedded
% grating
%
% scr: screen parameters
% stiPar: parameters corresponding to grating
% noisePar: parameters corresponding to noise
% targetOri: orientation of the grating
% targetPresent: presence or absesnce of grating (1=present, 2=absent)
%
%
% Ian Donovan 10/07/16

%% grating 

stimStruct.phase = rand*2*pi; %randomize phase 

switch targetPresent
    case 1
        [stimStruct.grating, stimStruct.gratingCarrier, stimStruct.gratingModulator] =  CreateRaisedGrating(scr, stiPar.gratingsiz, stiPar.gratingf, stiPar.edgeTransition, stiPar.flatSpread, stimStruct.phase, stiPar.contrast, targetOri);
    case 0
        [stimStruct.grating, stimStruct.gratingCarrier, stimStruct.gratingModulator] =  CreateRaisedGrating(scr, stiPar.gratingsiz, stiPar.gratingf, stiPar.edgeTransition, stiPar.flatSpread, stimStruct.phase, 0, targetOri);
end

%% filtered noise

[stimStruct.filterednoise, stimStruct.fFilter, stimStruct.oFilter] = CreateFilteredNoise(scr, noisePar.noisesiz, noisePar.fre_low, noisePar.fre_high, noisePar.ori_low, noisePar.ori_high, noisePar.contrast, noisePar.fixcontrast);

end