function presentStimuli(wPtr, locationPix, targetTexture)
global params; 
% This function will draw all the stimuli rotated by angles in the specific
% location
  

rect =  CenterRectOnPointd(params.stim.rectPix, locationPix(1), locationPix(2));%rect of stimulus, to be centered at location

if params.stim.colorTest == 1
    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('FrameOval', wPtr, params.stim.color(ori,:), rect, 3, 3);
else
    Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    Screen('DrawTexture', wPtr, targetTexture, [], rect, 0);
end


