function expEndDisp(wPtr)
global params;

instruct = 'Experiment ended. Thank you for your participation!';
Screen('TextSize', wPtr, params.text.size);

Screen('DrawText', wPtr, instruct, params.screen.centerPix(1)-270, params.screen.centerPix(2)-150, [0 0 0]);
Screen('Flip', wPtr);

WaitSecs(2);
end