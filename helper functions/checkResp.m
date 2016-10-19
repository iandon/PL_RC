function correctTrial = checkResp(resp, correctAns)
global params;
% Outputs the correctness (1 vs 0) of a response, or the absensce of a
% resopnse (2), according to the answer, the allowed keys and their 
% relationship to the correct and incorrect answer, and the key pressed.
%
% Inputs
% resp: the key the observer pressed
% correctAns: correct answer, one scalar with a value from 1:numPossibleResponses
% 
%


ansIdx = params.response.allowedRespKeysCodes(correctAns);
% respIdx = find(resp.key(1) == params.response.allowedRespKeysCodes);


if resp.check == 0
    correctTrial = 2;
elseif resp.check == 1
    if ansIdx == resp.key(1)
        correctTrial = 1;
    else
        correctTrial = 0;
    end
end

% correctTrial %uncomment if you want correctness printed in the command line after each trial

end