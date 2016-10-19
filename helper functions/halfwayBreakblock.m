function halfwayBreakblock(wPtr,b)
global params;


halfwayMsg = sprintf('You are halfway through the block!');
getExpter = sprintf('Press space to continue with this block');

Screen('TextSize', wPtr, params.text.size);
Screen('TextColor', wPtr, params.text.color);
Screen('TextBackgroundColor',wPtr, params.text.bkColor );

Screen('DrawText', wPtr, halfwayMsg, params.screen.centerPix(1)-200, params.screen.centerPix(2)-150);
Screen('DrawText', wPtr, getExpter, params.screen.centerPix(1)-210, params.screen.centerPix(2)+150);

Screen('Flip', wPtr);

WaitSecs(2);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  keyIsDown = 7; break; else keyIsDown =0;  end
end

end