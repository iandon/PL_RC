



rev3avT = zeros(6,4);
rev3avU = zeros(2,4);

rev4avT = zeros(6,4);
rev4avU = zeros(2,4);



rev3avT(1,1) = threshCW1{3}.rev3a;
rev3avT(1,2) = threshCW1{4}.rev3b;
rev3avU(1,1) = threshCW1{4}.rev3a;
rev3avU(1,2) = threshCW1{3}.rev3b;
    
rev4avT(1,1) = threshCW1{3}.rev4a;
rev4avT(1,2) = threshCW1{4}.rev4b;
rev4avU(1,1) = threshCW1{4}.rev4a;
rev4avU(1,2) = threshCW1{3}.rev4b;



rev4avT(2,1) = mean(threshCW2{1}.rev4a,...
                    threshCW2{2}.rev4a,...
                    threshCW2{3}.rev4a,...
                    threshCW2{4}.rev4a,...
                    threshCW2{5}.rev4a,...
                    threshCW2{6}.rev4a);
                
rev4avT(2,2) = mean(threshCW2{1}.rev4b,...
                    threshCW2{2}.rev4b,...
                    threshCW2{3}.rev4b,...
                    threshCW2{4}.rev4b,...
                    threshCW2{5}.rev4b,...
                    threshCW2{6}.rev4b);



rev4avT(3,1) = mean(threshCW3{1}.rev4a,...
                    threshCW3{2}.rev4a,...
                    threshCW3{3}.rev4a,...
                    threshCW3{4}.rev4a,...
                    threshCW3{5}.rev4a,...
                    threshCW3{6}.rev4a);
                
rev4avT(3,2) = mean(threshCW3{1}.rev4b,...
                    threshCW3{2}.rev4b,...
                    threshCW3{3}.rev4b,...
                    threshCW3{4}.rev4b,...
                    threshCW3{5}.rev4b,...
                    threshCW3{6}.rev4b);

rev4avT(4,1) = mean(threshCW4{1}.rev4a,...
                    threshCW4{2}.rev4a,...
                    threshCW4{3}.rev4a,...
                    threshCW4{4}.rev4a,...
                    threshCW4{5}.rev4a,...
                    threshCW4{6}.rev4a);
                
rev4avT(4,2) = mean(threshCW4{1}.rev4b,...
                    threshCW4{2}.rev4b,...
                    threshCW4{3}.rev4b,...
                    threshCW4{4}.rev4b,...
                    threshCW4{5}.rev4b,...
                    threshCW4{6}.rev4b);
                
rev3avT(6,1) = threshCW6{3}.rev3a;
rev3avT(6,2) = threshCW6{4}.rev3b;
rev3avU(6,1) = threshCW6{4}.rev3a;
rev3avU(6,2) = threshCW6{3}.rev3b;
    
rev4avT(6,1) = threshCW6{3}.rev4a;
rev4avT(6,2) = threshCW6{4}.rev4b;
rev4avU(6,1) = threshCW6{4}.rev4a;
rev4avU(6,2) = threshCW6{3}.rev4b;

rev3avT(5,3) = threshCW5{3}.rev3a;
rev3avT(5,4) = threshCW5{4}.rev3b;
rev3avU(5,3) = threshCW5{4}.rev3a;
rev3avU(5,4) = threshCW5{3}.rev3b;
    
rev4avT(5,3) = threshCW5{3}.rev4a;
rev4avT(5,4) = threshCW5{4}.rev4b;
rev4avU(5,3) = threshCW5{4}.rev4a;
rev4avU(5,4) = threshCW5{3}.rev4b;





figure, hold on
ttl = sprintf('Last 3 Reversals - Subject CW');
title(ttl);

%PreTest
plot(1,rev3avT(1,1),'bo')
plot(1,rev3avT(1,2),'gd')
plot(1,rev3avU(1,1),'ro')
plot(1,rev3avU(1,2),'md')

%Training
for i = 2:4
plot(i,rev3avT(i,1),'bo')
plot(i,rev3avT(i,2),'gd')
end

%PostTest
plot(5,rev3avT(6,1),'bo')
plot(5,rev3avT(6,2),'gd')
plot(5,rev3avU(6,1),'ro')
plot(5,rev3avU(6,2),'md')

plot(5,rev3avT(5,1),'bp')
plot(5,rev3avT(5,2),'gs')
plot(5,rev3avU(5,1),'rp')
plot(5,rev3avU(5,2),'ms')

axis([0,7,-.2,2)

hold off








