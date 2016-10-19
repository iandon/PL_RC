function fixation(wPtr, fix)
global params;

if nargin == 2
    if ~fix
        xHR= params.screen.centerPix(1)+ params.fixation.sizeCrossPix(1);
        xHL = params.screen.centerPix(1)- params.fixation.sizeCrossPix(1);
        yH = params.screen.centerPix(2);
%         Screen('DrawLine',wPtr,[255, 0, 0],xHL,yH,xHR, yH,params.fixation.penWidthPix);
        
        yVU= params.screen.centerPix(2) - params.fixation.sizeCrossPix(2);
        yVD = params.screen.centerPix(2) + params.fixation.sizeCrossPix(2);
        xV = params.screen.centerPix(1);
%         Screen('DrawLine',wPtr,[255, 0, 0],xV,yVU,xV, yVD,params.fixation.penWidthPix);
        
        Screen('FrameOval', wPtr, [255, 0, 0], xHL, yVU, xHR, yVD, params.fixation.penWidthPix);
    end

else
xHR= params.screen.centerPix(1)+ params.fixation.sizeCrossPix(1);
xHL = params.screen.centerPix(1)- params.fixation.sizeCrossPix(1);
yH = params.screen.centerPix(2);
% Screen('DrawLine',wPtr,params.fixation.color, xHL,yH,xHR,yH,params.fixation.penWidthPix);

yVU= params.screen.centerPix(2)- params.fixation.sizeCrossPix(2);
yVD = params.screen.centerPix(2)+ params.fixation.sizeCrossPix(2);
xV = params.screen.centerPix(1);
% Screen('DrawLine',wPtr,params.fixation.color, xV,yVU,xV,yVD, params.fixation.penWidthPix);


Screen('FrameOval', wPtr, params.fixation.color, [xHL, yVU, xHR, yVD], params.fixation.penWidthPix);


end



