function [patch, full_objsiz] = CreateCircularApertureSin(scr, objsiz, sinsiz, sinpower, imgsiz)

if nargin < 2 || isempty(objsiz)
    error('Not enough input arguments.');
end
if nargin < 3 || isempty(sinsiz)
    sinsiz = .5;
end
if nargin < 4 || isempty(sinpower)
    sinpower = 5;
end
if nargin < 5 || isempty(imgsiz)
    imgsiz = objsiz;
end
if objsiz > imgsiz
    error('Object size should be smaller than image size')
end

pimgsiz = angle2pix(scr, imgsiz);
psinsiz  = angle2pix(scr, sinsiz);
% if rem(4,2) == 0
%     psinsiz = psinsiz+1;
% end

[x,y]=meshgrid(1:pimgsiz, 1:pimgsiz);
x = x-mean(x(:));
y = y-mean(y(:));
x = Scale(x)*imgsiz-imgsiz/2;
y = Scale(y)*imgsiz-imgsiz/2;

[~,r] = cart2pol(x,y);
patch = double(r <= objsiz/2);

sinFilter = sin(linspace(0,pi,psinsiz)).^sinpower;
sinFilter = sinFilter'*sinFilter;
sinFilter = sinFilter/sum(sinFilter(:));

patch = conv2(patch, sinFilter,'same');

Idx_1 = abs(patch-1) <= 10^-2;
Idx_r = r(Idx_1);
full_objsiz = 2*max(Idx_r(:));

end