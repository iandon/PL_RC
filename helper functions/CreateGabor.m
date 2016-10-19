function gabor = CreateGabor(scr, gaborsiz, gaborstd, gaborf, phase, contrast, ori)
%%
% scr: Screen parameters
% gaborsize: gabor width in visual angle
% gaborstd: std of the Gaussian modulator
% gaborf: gabor frequency: cycle per degree
% phase: phase
% contrast: contrast of the gabor
% There is no orientation parameter here. Rotate the texture when put on the screen.
%%
visiblesize=angle2pix(scr, [gaborsiz gaborsiz]);
%[x,y]=meshgrid(-1*visiblesize/2:visiblesize/2, -1*visiblesize/2:1*visiblesize/2);
[x,y]=meshgrid(1:visiblesize, 1:visiblesize);
x = x-mean(x(:));
y = y-mean(y(:));
x = Scale(x)*gaborsiz-gaborsiz/2;
y = Scale(y)*gaborsiz-gaborsiz/2;

ori = ori/180*pi;
nx = x*cos(ori) + y*sin(ori);
ny = x*cos(ori) - y*sin(ori);

carrier      =cos(nx*gaborf*2*pi+phase*2*pi);
modulator    =exp(-((x/gaborstd).^2)-((y/gaborstd).^2));
gabor        = carrier.*modulator*contrast;