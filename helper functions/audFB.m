function audFB(correctTrial)
global params;


if correctTrial == 1
    %beep2(params.fbVars.high,params.fbVars.dur, 1)
elseif correctTrial == 0
    beep2(params.feedback.low,params.feedback.dur, 0)
elseif correctTrial == 2
    beep2(params.feedback.high,params.feedback.durNoResp, 1)
end