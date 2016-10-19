function [mask] = CreateCircularAperture3(imgsize,aperturePeakProportion)
% all inputs in pixels
% 
% imgsize: size of image
% aperturePeakProportion: proportion of image at peak of aperture
%
% ian donovan 09/13/16

aperturePeakSpread = (imgsize*aperturePeakProportion)/2;

mask = ones(imgsize);
centerCoord = imgsize/2;

cosWaveLength = (imgsize/2-aperturePeakSpread)*2;

for iX = 1:imgsize%(1)
    coordX = iX-centerCoord;
    for iY = 1:imgsize%(2)
        coordY = iY-centerCoord;
        distFromCenterCurrent = sqrt(coordX^2+coordY^2);
        if distFromCenterCurrent > aperturePeakSpread
            distFromAperture = distFromCenterCurrent-aperturePeakSpread;
            %             mask(iX,iY) = normpdf(distFromCenterCurrent,aperturePeakSpread,edgeTransitionSTD)...
            %                           ./normpdf(aperturePeakSpread,aperturePeakSpread,edgeTransitionSTD);
            if distFromAperture <= (cosWaveLength/2)
                mask(iX,iY) = (cos((distFromAperture)*((2*pi)/(cosWaveLength)))+1)/2;
            else
                mask(iX,iY) = 0;
            end
        end
    end
end



