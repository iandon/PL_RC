

lastThreshT = zeros(6,4);
lastThreshU = zeros(2,4);

rev4avT = zeros(6,4);
rev4avU = zeros(2,4);



lastThreshT(1,1) = threshCW1{3}.lastThreshA;
lastThreshT(1,2) = threshCW1{4}.lastThreshB;
lastThreshU(1,1) = threshCW1{4}.lastThreshA;
lastThreshU(1,2) = threshCW1{3}.lastThreshB;




lastThreshT(2,1) = mean([threshCW2{1}.lastThreshA,...
    threshCW2{2}.lastThreshA,...
    threshCW2{3}.lastThreshA,...
    threshCW2{4}.lastThreshA,...
    threshCW2{5}.lastThreshA,...
    threshCW2{6}.lastThreshA]);

lastThreshT(2,2) = mean([threshCW2{1}.lastThreshB,...
    threshCW2{2}.lastThreshB,...
    threshCW2{3}.lastThreshB,...
    threshCW2{4}.lastThreshB,...
    threshCW2{5}.lastThreshB,...
    threshCW2{6}.lastThreshB]);



lastThreshT(3,1) = mean([threshCW3{1}.lastThreshA,...
    threshCW3{2}.lastThreshA,...
    threshCW3{3}.lastThreshA,...
    threshCW3{4}.lastThreshA,...
    threshCW3{5}.lastThreshA,...
    threshCW3{6}.lastThreshA]);

lastThreshT(3,2) = mean([threshCW3{1}.lastThreshB,...
    threshCW3{2}.lastThreshB,...
    threshCW3{3}.lastThreshB,...
    threshCW3{4}.lastThreshB,...
    threshCW3{5}.lastThreshB,...
    threshCW3{6}.lastThreshB]);

lastThreshT(4,1) = mean([threshCW4{1}.lastThreshA,...
    threshCW4{2}.lastThreshA,...
    threshCW4{3}.lastThreshA,...
    threshCW4{4}.lastThreshA,...
    threshCW4{5}.lastThreshA,...
    threshCW4{6}.lastThreshA]);

lastThreshT(4,2) = mean([threshCW4{1}.lastThreshB,...
    threshCW4{2}.lastThreshB,...
    threshCW4{3}.lastThreshB,...
    threshCW4{4}.lastThreshB,...
    threshCW4{5}.lastThreshB,...
    threshCW4{6}.lastThreshB]);



meanLast2 = 0;

if meanLast2 == 1;
lastThreshU(6,1) = mean([threshCW6{1}.lastThreshA,threshCW6{3}.lastThreshA]);
lastThreshU(6,2) = mean([threshCW6{2}.lastThreshB,threshCW6{4}.lastThreshB]);
lastThreshT(6,1) = mean([threshCW6{2}.lastThreshA,threshCW6{4}.lastThreshA]);
lastThreshT(6,2) = mean([threshCW6{1}.lastThreshB,threshCW6{3}.lastThreshB]);


lastThreshT(5,3) = mean([threshCW5{1}.lastThreshA,threshCW5{3}.lastThreshA]);
lastThreshT(5,4) = mean([threshCW5{2}.lastThreshB,threshCW5{4}.lastThreshB]);
lastThreshU(5,3) = mean([threshCW5{2}.lastThreshA,threshCW5{4}.lastThreshA]);
lastThreshU(5,4) = mean([threshCW5{1}.lastThreshB,threshCW5{3}.lastThreshB]);
else
lastThreshU(6,1) = threshCW6{3}.lastThreshA;
lastThreshU(6,2) = threshCW6{4}.lastThreshB;
lastThreshT(6,1) = threshCW6{4}.lastThreshA;
lastThreshT(6,2) = threshCW6{3}.lastThreshB;

lastThreshT(5,3) = threshCW5{3}.lastThreshA;
lastThreshT(5,4) = threshCW5{4}.lastThreshB;
lastThreshU(5,3) = threshCW5{4}.lastThreshA;
lastThreshU(5,4) = threshCW5{3}.lastThreshB;
end

figure, hold on
ttl = sprintf('Last 3 Reversals - Subject CW');
title(ttl);





%PostTest
plot(5,lastThreshT(6,1),'bo')
plot(5,lastThreshT(5,3),'bp')

plot(5,lastThreshT(6,2),'co')
plot(5,lastThreshT(5,4),'cp')

plot(5,lastThreshU(6,1),'rd')
plot(5,lastThreshU(5,3),'r*')

plot(5,lastThreshU(6,2),'kd')
plot(5,lastThreshU(5,4),'k*')

legend('Loc 1, Ori 1','Loc 1, Ori 2', 'Loc 3, Ori 1', 'Loc 3, Ori 2', 'Loc 2, Ori 1', 'Loc 2, Ori 2',...
    'Loc 4, Ori 1','Loc 4, Ori 2');

%PreTest
plot(1,lastThreshT(1,1),'bo')
plot(1,lastThreshT(1,2),'co')
plot(1,lastThreshU(1,1),'r*')
plot(1,lastThreshU(1,2),'k*')

%Training
for i = 2:4
    plot(i,lastThreshT(i,1),'bo')
    plot(i,lastThreshT(i,2),'co')
end

plot(1:5,[lastThreshT(1:4,1);lastThreshT(6,1)],'b--')
plot(1:5,[lastThreshT(1:4,2);lastThreshT(6,2)],'c--')

axis([0,7,-.2,2])

set(gca, 'YTick', [log10(1),log10(2),log10(4),log10(6),log10(8),log10(10),log10(20),log10(30),log10(50),log10(100)]);
set(gca, 'YTickLabel',[1, 2, 4, 6, 8, 10, 20, 30, 50, 100]);

hold off








