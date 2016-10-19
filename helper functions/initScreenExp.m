function [wPtr, startclut] = initScreenExp
global params

AssertOpenGL;
wPtr = Screen('OpenWindow', params.screen.num, params.screen.bgColor, params.screen.rectPix);
params.screen.wPtr = wPtr;
Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
startclut = Screen('ReadNormalizedGammaTable', params.screen.num);
load( params.screen.calib_filename); 
new_gamma_table = repmat(calib.table, 1, 3);
Priority(MaxPriority(wPtr));
Screen('LoadNormalizedGammaTable',params.screen.num,new_gamma_table,[]);
end
