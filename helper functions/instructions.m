function instructions(wPtr)
global params;

instruct = 'Is the stimulus tilted more counter-clockwise or more clockwise, relative to VERTICAL?';
keys = sprintf('Press ''%s'' for counter-clockwise tilt or ''%s'' for clockwise tilt. ', params.response.allowedRespKeys{1}(1), params.response.allowedRespKeys{2}(1));
start = 'Press space to start!';

Screen('TextSize', wPtr, params.text.size);
Screen('TextColor', wPtr, params.text.color);
Screen('TextBackgroundColor',wPtr, params.text.bgColor );
%DrawFormattedText(wPtr, instruct, 'center', 'center', 1, []);

Screen('DrawText', wPtr, instruct, params.screen.centerPix(1)-500, params.screen.centerPix(2)-150);
Screen('DrawText', wPtr, keys, params.screen.centerPix(1)-350, params.screen.centerPix(2));
Screen('DrawText', wPtr, start, params.screen.centerPix(1)-150, params.screen.centerPix(2)+150);

Screen('Flip', wPtr);

[keyIsDown,secs,keyCode] = KbCheck;  WaitSecs(3);
clear keyIsDown secs keyCode


keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
end

