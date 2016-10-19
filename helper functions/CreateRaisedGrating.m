function [grating, carrier, modulator]  = CreateRaisedGrating(scr, gratingSize, gratingSF, flatSpread, phase, contrast, ori, plotQ)
%%
% scr: Screen parameters
% gratingSize: gabor width in visual angle
% gratingSF: grating frequency: cycle per degree
% edgeTransitionSTD: is the order of the filter, the lower edgeTransition is the sharper the transition is. (must be > 0).
% flatSpread: proportion of visiblesize that is at max contrast
% phase: phase
% contrast: contrast of the gabor
%%
visiblesize=angle2pix(scr, [gratingSize gratingSize]);
flatSpreadVisRadius = (visiblesize(1).*flatSpread)/2;

[x,y]=meshgrid(1:visiblesize, 1:visiblesize);
x = x-mean(x(:));
y = y-mean(y(:));
x = Scale(x)*gratingSize-gratingSize/2;
y = Scale(y)*gratingSize-gratingSize/2;

ori = ori/180*pi;
nx = x*cos(ori) + y*sin(ori);
ny = x*cos(ori) - y*sin(ori);

modulator = ones(visiblesize);

carrier      = cos(nx*gratingSF*2*pi+phase*2*pi);
grating        = carrier.*modulator*contrast;


%% plots
if plotQ ==1
    figure('position',[0 600 800 300]), clf, hold on, subplot(1,3,1)
    mesh(modulator)
    title(sprintf('Spread DVA = % d', flatSpreadVisRadius))
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Contrast')
    
    subplot(1,3,2)
    mesh(carrier)
    title(sprintf('Spread DVA = % d', flatSpreadVisRadius))
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Contrast')
    
    
    subplot(1,3,3)
    mesh(grating)
    title(sprintf('Spread DVA = % d  &  Edge STD = %d ', flatSpreadVisRadius, edgeTransitionSTD))
    xlabel('X Pixel Loc')
    ylabel('Y Pixel Loc')
    zlabel('Brightness - ? Gray')
    hold off
end