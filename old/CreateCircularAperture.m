function [mask] = CreateCircularAperture(imgsize,aperturePeakProportion,edgeTransitionSTD)
% all inputs in pixels
% 
% imgsize: size of image
% aperturePeakProportion: proportion of image at peak of aperture
% edgeTransitionSTD: std of normpdf that smooths edge of aperture
%
% ian donovan 09/13/16

aperturePeakSpread = (imgsize*aperturePeakProportion)/2;

mask = ones(imgsize);
centerCoord = imgsize/2;
for iX = 1:imgsize%(1)
    coordX = iX-centerCoord;
    for iY = 1:imgsize%(2)
        coordY = iY-centerCoord;
        distFromCenterCurrent = sqrt(coordX^2+coordY^2);
        if distFromCenterCurrent > aperturePeakSpread
            mask(iX,iY) = normpdf(distFromCenterCurrent,aperturePeakSpread,edgeTransitionSTD)...
                          ./normpdf(aperturePeakSpread,aperturePeakSpread,edgeTransitionSTD);
        end
    end
end
