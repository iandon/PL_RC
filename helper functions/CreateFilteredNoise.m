function [filterednoise, fFilter, oFilter] = CreateFilteredNoise(scr, noisesiz, fre_low, fre_high, ori_low, ori_high, contrast, fixcontrast)

%%
% Create the noise pattern filtered in frequency and orientation domain.
% If fixcontrast is at 1, The noise is centered at 0 and scaled to have the assigned contrast (RMS
% contrast (The std of the noise; to compute final contrast: devided by the bg luminance) 
% If it is 0, there will be random fluctuation.
% Let ori_low be empty [] if you dont need filter at orientation domain.
%% Parameter for Test
% noisesiz=4;
% fre_low=.1;
% fre_high=5;
% ori_low=[];
% ori_high=[];
% contrast=.1;
%%
noisepsiz = angle2pix(scr, noisesiz);
fNyquist = angle2pix(scr,1)*.5;

%Draw orientation and spatial frequency filter


% Draw filter for frequency domain
cutoff = 0.5*fre_high/fNyquist;
cutin  = 0.5*fre_low/fNyquist;
n = 10;
fFilter = fftshift(bandpassfilter(noisepsiz, cutin, cutoff, n));
fFilter= max(fFilter,eps);

% This is the alternative code for filter in frequency domain
% fre_low = fre_low/fNyquist;
% fre_high = fre_high/fNyquist;
% fFilter = Bandpass2(noisepsiz, fre_low, fre_high);
% smoothfilter = smoothfilter'*smoothfilter;
% smoothfilter = smoothfilter / sum(smoothfilter(:));
% fFilter = filter2(smoothfilter, fFilter);


% Draw filter in orientation domain
smoothfilter = normpdf(1:fNyquist,mean(1:fNyquist),fNyquist/10);
if isempty(ori_low)
    oFilter = ones(noisepsiz);
else
    oFilter = OrientationBandpass(noisepsiz, ori_low, ori_high);
    oFilter = filter2(smoothfilter, oFilter);
end
%save noiseFilter fFilter oFilter

noise = randn(noisepsiz, noisepsiz);
fn = fftshift(fft2(noise));
filterednoise = real(ifft2(ifftshift(oFilter.*fFilter.*fn)));

if fixcontrast ==0
%Use this line if allowing more energy fluctuation across trials
filterednoise = filterednoise*contrast - mean(filterednoise(:));
elseif fixcontrast == 1
%Use this if wanting the rmsContrast of the noise to be fixed across trials
filterednoise = filterednoise/std(filterednoise(:))*contrast - mean(filterednoise(:)); 
end
% disp(std(filterednoise(:)));