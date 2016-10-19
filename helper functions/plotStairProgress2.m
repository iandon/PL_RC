function [threshGuessSTRUCT] = plotStairProgress2(stair, sesNum)
%Plots the progression of the staircase for each block
%  Plots are titled with Block # and Stimulus Location #
%      Session # can also be a 2nd input, but it is not required.
%
%Structure 'stair' must have the parameter stair.StimNumOnBlock
%    this is used to determine the number of blocks

threshGuessMTX = cell(length(stair.StimNumOnBlock),1);


for i = 1:size(stair.StimNumOnBlock,1)
    clear xRange1 xRange2 xRangeMAX rev3 rev4 lastThresh
    xRange1 = 1:length(stair.Stair1{i}.strength);
    xRange2 = 1:length(stair.Stair2{i}.strength);
    xRange3 = 1:length(stair.Stair3{i}.strength);
    xRange4 = 1:length(stair.Stair4{i}.strength);
    
    %xRangeMIN = min([min(xRange1), min(xRange2)]);
    xRangeMAX = max([max(xRange1), max(xRange2)]);
    
    lastThreshA = log10(mean([10^stair.Stair1{i}.strength(length(stair.Stair1{i}.strength)),...
                       10^stair.Stair2{i}.strength(length(stair.Stair2{i}.strength))]));
    lastThreshB = log10(mean([10^stair.Stair3{i}.strength(length(stair.Stair3{i}.strength)),...
                       10^stair.Stair4{i}.strength(length(stair.Stair4{i}.strength))]));
    
    if nargin == 2; threshGuessMTX{i}.sesNum = sesNum; end
    threshGuessMTX{i}.stim = stair.StimNumOnBlock(i,:);
    threshGuessMTX{i}.block = i;
    threshGuessMTX{i}.numRev1 = length(stair.Stair1{i}.reversals);
    threshGuessMTX{i}.numRev2 = length(stair.Stair2{i}.reversals);
    threshGuessMTX{i}.numRev3 = length(stair.Stair3{i}.reversals);
    threshGuessMTX{i}.numRev4 = length(stair.Stair4{i}.reversals);
    threshGuessMTX{i}.lastThreshA = lastThreshA;
    threshGuessMTX{i}.lastThreshB = lastThreshB;
    
    
    if (length(stair.Stair1{i}.reversals) >= 3) && (length(stair.Stair2{i}.reversals) >= 3)
    rev3a = log10(mean([10.^mean(stair.Stair1{i}.strength(stair.Stair1{i}.reversals((length(stair.Stair1{i}.reversals)-2):end))),...
                  mean(10.^stair.Stair2{i}.strength(stair.Stair2{i}.reversals((length(stair.Stair2{i}.reversals)-2):end)))]));
    threshGuessMTX{i}.rev3a = rev3a;
    lateReva = log10(mean([mean(10.^stair.Stair1{i}.strength(stair.Stair1{i}.reversals(3:end))),...
                     mean(10.^stair.Stair2{i}.strength(stair.Stair2{i}.reversals(3:end)))]));
    threshGuessMTX{i}.lateReva = lateReva;
    end
    if (length(stair.Stair1{i}.reversals) >= 4) && (length(stair.Stair2{i}.reversals) >= 4)
    rev4a = log10(mean([mean(10.^stair.Stair1{i}.strength(stair.Stair1{i}.reversals((length(stair.Stair1{i}.reversals)-3):end))),...
                  mean(10.^stair.Stair2{i}.strength(stair.Stair2{i}.reversals(length(stair.Stair2{i}.reversals)-3):end))]));
    threshGuessMTX{i}.rev4a = rev4a;
    end
    
    
    if (length(stair.Stair3{i}.reversals) >= 3) && (length(stair.Stair4{i}.reversals) >= 3)
    rev3b = log10(mean([mean(10.^stair.Stair3{i}.strength(stair.Stair3{i}.reversals((length(stair.Stair3{i}.reversals)-2):end))),...
                  mean(10.^stair.Stair4{i}.strength(stair.Stair4{i}.reversals((length(stair.Stair4{i}.reversals)-2):end)))]));
    threshGuessMTX{i}.rev3b = rev3b;
    
    lateRevb = log10(mean([mean(10.^stair.Stair3{i}.strength(stair.Stair3{i}.reversals(3:end))),...
                     mean(10.^stair.Stair4{i}.strength(stair.Stair4{i}.reversals(3:end)))]));
    threshGuessMTX{i}.lateRevb = lateRevb;
    end
    if (length(stair.Stair3{i}.reversals) >= 4) && (length(stair.Stair4{i}.reversals) >= 4)
    rev4b = log10(mean([mean(10.^stair.Stair3{i}.strength(stair.Stair3{i}.reversals((length(stair.Stair3{i}.reversals)-3):end))),...
                  mean(10.^stair.Stair4{i}.strength(stair.Stair4{i}.reversals(length(stair.Stair4{i}.reversals)-3):end))]));
    threshGuessMTX{i}.rev4b = rev4b;
    end
    
    
    
    if nargin == 2; ttl = sprintf('Session %d - Block %d - Location %d', sesNum, i, stair.StimNumOnBlock(i,1)); 
    else ttl = (sprintf('Block %d - Location %d', i, stair.StimNumOnBlock(i,1)));  end
    figure
    hold on
    title(ttl)
    plot(xRange1, stair.Stair1{i}.strength, 'b')
    plot(stair.Stair1{i}.reversals, stair.Stair1{i}.strength(stair.Stair1{i}.reversals), 'bo')
    plot(xRange2, stair.Stair2{i}.strength, 'r')
    plot(stair.Stair2{i}.reversals, stair.Stair2{i}.strength(stair.Stair2{i}.reversals), 'rd')
    plot([0, xRangeMAX], [lastThreshA, lastThreshA], 'k:')
    if (length(stair.Stair1{i}.reversals) >= 3) && (length(stair.Stair2{i}.reversals) >= 3)
        plot([0, xRangeMAX], [rev3a, rev3a], 'm-.')
    end
    if (length(stair.Stair2{i}.reversals) >= 4) && (length(stair.Stair2{i}.reversals) >= 4)
        plot([0, xRangeMAX], [rev4a, rev4a], 'g--')
        plot([0, xRangeMAX], [lateReva, lateReva], 'c-.')
    end
    legend('Stair1','Reversal', 'Stair2','Reversal', 'LastThreshold MEAN', 'Last 3 Rev MEAN', 'Last 4 Rev MEAN', 'All but 1st 2 Revs MEAN')
    axis([0, xRangeMAX, log10(1), 2])
    set(gca, 'YTick', [log10(1),log10(2),log10(4),log10(6),log10(8),log10(10),log10(20),log10(30),log10(50),log10(100)]);
    set(gca, 'YTickLabel',[1, 2, 4, 6, 8, 10, 20, 30, 50, 100]);
    hold off
    
    if nargin == 2; ttl = sprintf('Session %d - Block %d - Location %d', sesNum, i, stair.StimNumOnBlock(i,2)); 
    else ttl = (sprintf('Block %d - Location %d', i, stair.StimNumOnBlock(i,2)));  end
    figure
    hold on
    title(ttl)
    plot(xRange3, stair.Stair3{i}.strength, 'b')
    plot(stair.Stair3{i}.reversals, stair.Stair3{i}.strength(stair.Stair3{i}.reversals), 'bo')
    plot(xRange4, stair.Stair4{i}.strength, 'r')
    plot(stair.Stair4{i}.reversals, stair.Stair4{i}.strength(stair.Stair4{i}.reversals), 'rd')
    plot([0, xRangeMAX], [lastThreshB,lastThreshB], 'k:')
    if (length(stair.Stair3{i}.reversals) >= 3) && (length(stair.Stair4{i}.reversals) >= 3)
        plot([0, xRangeMAX], [rev3b, rev3b], 'm-.')
    end
    if (length(stair.Stair3{i}.reversals) >= 4) && (length(stair.Stair4{i}.reversals) >= 4)
        plot([0, xRangeMAX], [rev4b,rev4b], 'g--')
        plot([0, xRangeMAX], [lateRevb,lateRevb], 'c-.')
    end
    legend('Stair3','Reversal', 'Stair4','Reversal', 'LastThreshold MEAN', 'Last 3 Rev MEAN', 'Last 4 Rev MEAN', 'All but 1st 2 Revs MEAN')
    axis([0, xRangeMAX, log10(1), 2])
    set(gca, 'YTick', [log10(1),log10(2),log10(4),log10(6),log10(8),log10(10),log10(20),log10(30),log10(50),log10(100)]);
    set(gca, 'YTickLabel',[1, 2, 4, 6, 8, 10, 20, 30, 50, 100]);
    hold off

end


threshGuessSTRUCT = threshGuessMTX;


end