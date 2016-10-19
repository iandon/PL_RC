function quarterBreak(wPtr,whichQuarter)
global params;

switch whichQuarter
    case {2}
        instruct1= sprintf('Half-way through the block!');
    case {1,3}
        instruct1= sprintf('%d/4 through the block!',whichQuarter);
end

instruct2= ' Take a short break! ';
keyInstr ='Press SPACEBAR to continue.';

Screen('TextSize', wPtr, params.text.size);
Screen('TextColor', wPtr, params.text.color);
Screen('TextBackgroundColor',wPtr, params.text.bkColor );

Screen('DrawText', wPtr, instruct1, params.screen.centerPix(1)-300, params.screen.centerPix(2)-150);
Screen('DrawText', wPtr, instruct2, params.screen.centerPix(1)-250, params.screen.centerPix(2)-100);
Screen('Flip', wPtr);
WaitSecs(5)
    
Screen('DrawText', wPtr, keyInstr, params.screen.centerPix(1)-250, params.screen.centerPix(2)+150);  
Screen('Flip', wPtr);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('Space')),  
        keyIsDown = 1; break; 
    else
        keyIsDown = 0;
    end
end