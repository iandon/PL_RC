function postCue(wPtr,oriPossible)
global params;


fixRadiusPix = params.fixation.sizeCrossPix;

x1 = params.screen.centerPix(1) - cosd(oriPossible+90)*fixRadiusPix(1);
x2 = params.screen.centerPix(1) + cosd(oriPossible+90)*fixRadiusPix(1);

y1 = params.screen.centerPix(2) - sind(oriPossible+90)*fixRadiusPix(2);
y2 = params.screen.centerPix(2) + sind(oriPossible+90)*fixRadiusPix(2);


Screen('DrawLine',wPtr, params.postCue.color, x1, y1, x2, y2, params.fixation.penWidthPix);


xHR= params.screen.centerPix(1)+ params.fixation.sizeCrossPix(1);
xHL = params.screen.centerPix(1)- params.fixation.sizeCrossPix(1);

yVU= params.screen.centerPix(2)- params.fixation.sizeCrossPix(2);
yVD = params.screen.centerPix(2)+ params.fixation.sizeCrossPix(2);

Screen('FrameOval', wPtr, params.fixation.color, [xHL, yVU, xHR, yVD], params.fixation.penWidthPix);
