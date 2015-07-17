% ToolboxTestScript
% 
% ToolboxTestScript will call all elements of the toolbox and test them appropriately.
% Figures and expected results will be shown and explained.
% All elements will be tested to ensure proper functionality.
% 
% The testScript is divided into 7 sections, determined by the functions of each element.
% Each section can be run independently by commenting out all sections but the one to be tested.
% 
% Created: June 7, 2004
% Authors: Lily Brown, Justin Evert, Tim Stolldorf
% Marquette University

format compact;



% fprintf('\n');
% disp('Section 1: Filterbank');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Tests of filterIIR, filterBankFIR, and FilterBankIIR:');
% 
% fprintf('\n');
% disp('A logistic signal is created and plotted.');
% disp('Press any key to continue.');
% y1 = logistic(500,4);
% phaseplot(y1,[1 2]);
% pause;
% fprintf('\n');
% disp('The same signal is passed through filterIIR, filterBankIIR and filterBankFIR independently and plotted');
% disp('Press any key to advance to the next plot.');
% signal1 = filterIIR(y1,[0.25 0.75], 'low', 1);
% phaseplot(signal1,[1 2]);
% hold off;
% pause;
% signal1 = filterBankFIR(y1,[1 2]);
% phaseplot(signal1(1),[1 2]);
% hold off;
% pause;
% signal1 = filterBankIIR(y1,[0.25 0.75]);
% phaseplot(signal1(1),[1 2]);
% hold off;
% pause;
% 
% 
% fprintf('\n');
% disp('Section 2: Bins');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Test of decideIntercepts, binTrain and binTest:');
% 
% fprintf('\n');
% disp('A cell array of logistic signals is created and embedded.');
% disp('The embedded signal is passed to decideIntercepts.');
% y2 = {};
% for i = 1:500
%     newSig2 = logistic(500,4);
%     y2{i} = newSig2;
% end
% embedded2 = {};
% for i = 1:500
%     embedded2{i} = embed(y2{i},[1 2]);
% end
% 
% disp('The resulting intercepts should have three rows, indicating 3 dimensions in the RPS');
% disp('and nine columns, indicating 10 strips');
% intercepts = decideIntercepts(embedded2,10) % strips = 10, # of intercepts = strips-1
% disp('The embedded signal and the determined intercepts are passed to binTrain resulting');
% disp('in the following probability matrix:');
% probabilityMatrix = binTrain(embedded2,intercepts)
% 
% log2 = {};
% for i = 1:500
%     newLogSig2 = logistic(500,4);
%     log2{i} = newLogSig2;
% end
% embeddedLog2 = {};
% for i = 1:500
%     embeddedLog2{i} = embed(log2{i},[1 2]);
% end
% fprintf('\n');
% disp('A new logistic signal is created and passed to binTest with the above determined probability matrix');
% disp('and a probability score is calulated:');
% probScore = binTest(embeddedLog2{1},intercepts,probabilityMatrix)
% tent2 = {};
% for i = 1:500
%     newTentSig2 = tent(500,0.5);
%     tent2{i} = newTentSig2;
% end
% embeddedTent2 = {};
% for i = 1:500
%     embeddedTent2{i} = embed(tent2{i},[1 2]);
% end
% disp('A new tent signal is created and also passed to binTest with the same probability matrix.');
% probScore = binTest(embeddedTent2{1},intercepts,probabilityMatrix)
% disp('First probability score should be significantly greater than second due to the fact that they are similar signals.');
% 
% 
% fprintf('\n');
% disp('Section 3: Embedding tools');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Test of phaseplot and embed:');
% 
% y3 = logistic(500,4);
% fprintf('\n');
% disp('Three different types of embedding are tested: standard, embedWithDelta and embedWithDifference.');
% disp('The plots of the phasespace will show higher dimensions using graduated color.');
% disp('Press any key to advance to the next type of embedding.');
% phaseplot(y3,[1 2],3,1,1)
% hold off;
% pause
% phaseplot(y3,[1 2],3,2,0)
% hold off;
% pause
% phaseplot(y3,[1 2],3,3,0)
% hold off;
% pause
% phaseplot(y3,[1 2 3 4 ],5,1,0)
% hold off;
% pause
% 
% fprintf('\n');
% disp('Test of normalize:');
% disp('The first plot shown is the standard logistic signal.');
% disp('Press any key to advance to the normalized signal.');
% disp('This signal should be normalized to be between -1 and 1.');
% phaseplot(embed(y3,[1 2]));
% pause
% normalizedSig3 = normalize(embed(y3,[1 2]));
% phaseplot(normalizedSig3);
% pause
% 
% fprintf('\n');
% disp('Test of determineTimeLag and determineDimension:');
% fprintf('\n');
% disp('An array of logistic signals is created and passed to determineTimeLag.');
z3 ={};
for i = 1:500
    newSig3 = logistic(500,4);
    z3 = [z3 {newSig3}];
end
timeLag = determineTimeLag(z3)
% disp('The array and the newly calculated timeLag are passed to determineDimension.');
dimension = determineDimension(z3,timeLag)
% 
% fprintf('\n');
% disp('Test of createLags:');
% fprintf('\n');
% disp('Function called for (1) input 3-d, lag 1 and (2) input 3-d, lag 2');
% disp('Zero is implied and will be added in the embedding process');
% lags = createLags(3,1)
% lags = createLags(3,2)
% 
% fprintf('\n');
% disp('Test of gfnn');
% fprintf('\n');
% disp('Percent of global false nearest neighbors is found for dimensions 3, 2, and 1.');
% disp('% False nearest neighbors should increase as dimension decreases.');
% z3 =[];
% for i = 1:500
%     newSig3 = logistic(500,4);
%     z3 = [z3 newSig3];
% end
% fnn=gfnn(z3,3,[10])
% fnn=gfnn(z3,2,[10])
% fnn=gfnn(z3,1,[10])
% 
% 
% fprintf('\n');
% disp('Section 4: System maps');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Test of logistic, tent, henon, lorenzFun and rosslerFun:');
% fprintf('\n');
% disp('Each type of map is created and plotted in the above order.');
% disp('Press any key to advance to the next type of map.');
% l = logistic(500,4);
% e = tent(500,0.9);
% h = henon(500,1.4,0.3);
% [t z] = ode45(@lorenzFun,[0 100],[0.1 0.1 0.1]);
% [t r] = ode45(@rosslerFun,[0 100],[0.1 0.1 0.1]);
% nameVec = ['l' 'e' 'h' 'z' 'r'];
% for i = 1:3
%     cmd = ['phaseplot(' nameVec(i) ',[1 2])'];
%     eval(cmd);
%     pause
% end
% plot3(z(:,1),z(:,2),z(:,3));
% pause;
% plot3(r(:,1),r(:,2),r(:,3));
% 
% 
% fprintf('\n');
% disp('Section 5: Util');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Test of surrogate and whiteNoise:');
% fprintf('\n');
% disp('A logistic signal is created and plotted.  Press any key to advance.');
% x5 = logistic(10000,4);
% y5 = surrogate(x5);
% phaseplot(x5);
% pause;
% disp('A surrogate of the logistic signal is created and plotted.');
% phaseplot((y5'));
% pause
% fprintf('\n');
% disp('White noise is added to both of the above signals.');
% disp('Press any key to advance to the next plot.');
% pause;
% x5 = x5 + whitenoise(length(x5));
% y5 = y5 + (whitenoise(length(y5)))';
% phaseplot(x5);
% pause
% phaseplot(y5');
% pause
% 
% 
fprintf('\n');
disp('Section 6: GMM');
fprintf('\n');


fprintf('\n');
disp('Test of gmmemTrain, gmmemTest and makegmmPlot:');
fprintf('\n');
disp('Given two clusters of whitenoise, gmmemTrain will train a mixture on each.');
disp('The graph shows both mixtures, along with the variances of each mixture.');
load reconstructedSpace;
options = zeros(1,14);
options(1) = -1;  % no error display
options(5) = 1;   % avoid covariance collapse
% options(14) = 25; % number of EM iterations
options(19) = 1;  % floor on covariance matrix
y6(1:100) = whiteNoise(100,1,1);
y6(101:200) =whiteNoise(100,20,1);
sig6 = embed(y6,1,1);
size(sig6);
x6 = gmmemTrain('full',2,sig6', options);
logProbability = gmmemTest(x6,sig6',options);
makeGmmPlot(sig6',2);
hold off;
pause


%% trial

for i=1:3649
    rs(i,1) = norm(reconstructedSpace(i,1:5));
    rs(i,2) = norm(reconstructedSpace(i,6:10));
end
%% testing 10D projection on 1D
for i=1:3649
    nrs(i) = norm(reconstructedSpace(i,1:10));
end
nrs = nrs';

mixtureModel = gmmemTrain('full',16,nrs, options);
gmmemTest(x6,rs,options);
figure,makeGmmPlot(rs,16);
%% testing 10D unto 3D
for i=1:3649
rs3D(i,1) = norm(reconstructedSpace(i,1:4));
rs3D(i,2) = norm(reconstructedSpace(i,5:7));
rs3D(i,3) = norm(reconstructedSpace(i,8:10));
end
figure, plot3(rs3D(:,1), rs3D(:,2), rs3D(:,3));

hold on,
i=[1128 385 20 3307 1840 1839 380 1127 379 1129];
plot3(rs3D(i,1), rs3D(i,2), rs3D(i,3),'ro');

% plot specific dimensions
d1=3;
d2=8;
d3=7;
figure, plot3(reconstructedSpace(:,d1), reconstructedSpace(:,d2), reconstructedSpace(:,d3));
hold on,
i=[1128 385 20 3307 1840];
plot3(reconstructedSpace(i,d1), reconstructedSpace(i,d2), reconstructedSpace(i,d3),'ro');
%%%
for i=1:32
    xc(i,1) = norm(x6.centres(i,1:10));
%     rs(i,2) = norm(reconstructedSpace(i,6:10));
end

x6 = gmmemTrain('full',16,rs, options);
gmmemTest(x6,rs,options);
figure,makeGmmPlot(rs,16);

load reconstructedSpace;
options = zeros(1,14);
options(1) = -1;  % no error display
options(5) = 1;   % avoid covariance collapse
% options(14) = 25; % number of EM iterations
options(19) = 1;  % floor on covariance matrix
x6 = gmmemTrain('full',32,reconstructedSpace, options);
logProbability = gmmemTest(x6,reconstructedSpace,options);
figure,makeGmmPlot(reconstructedSpace,2);


%% end trial

% fprintf('\n');
% disp('Test of maxClass:');
% fprintf('\n');
% disp('A matrix of N rows (samples) and M columns (classes of signals) is created.');
% disp('This test has N=100 and M=3.');
% disp('maxClass should return the index (class) of the sample, i.e. the sample would be designated');
% disp('as probably belonging to one of three classes.');
% z6 = zeros(100,3);
% for i = 1:100
%     for j = 1:3
%         z6(i,j) = rand(1);
%     end
% end
% [classInd] = maxClass(z6)
% pause
% 
% 
% fprintf('\n');
% disp('Section 7: Enhance');
% fprintf('\n');
% 
% 
% fprintf('\n');
% disp('Test of enhanceGlobal:');
% fprintf('\n');
% 
% disp('Two logistic signals are sent to enhanceGlobaland enhanceGlobalFramed, and plotted.');
% disp('The first signal is noisy, the second is clean');
% disp('The enhancement tools emphasize the features of the clean signal in the noisy signal');
% disp('Press any key to advance to the next plot.');
% hold off;
% logvar = mean(logistic(10000,4).^2);
% snract=10^((30+(0*(rand-0.5)))/10); % snr = 30, 0 = spread around snr
% y7 = logistic(500,4)+sqrt(logvar/snract)*randn(1,500);
% sig7 = embed(y7,1,2);
% log7 = logistic(500,4);
% cleansig7 = embed(log7,1,2);
% eglobal = enhanceGlobal(sig7,cleansig7);
% phaseplot(eglobal);
% pause;
% eglobal = enhanceGlobalFramed(sig7,cleansig7);
% phaseplot(eglobal);
% pause;
% 
% disp('Two logistic signals are sent to enhanceLocal, enhanceLocalFramed and');
% disp('enhanceLocalPartial, and plotted.');
% disp('The first signal is noisy, the second is clean');
% disp('The enhancement tools emphasize the features of the clean signal in the noisy signal');
% disp('Press any key to advance to the next plot.');
% logvar = mean(logistic(10000,4).^2);
% snract=10^((20+(0*(rand-0.5)))/10); % snr = 20, 0 = spread around snr
% y7 = logistic(500,4)+sqrt(logvar/snract)*randn(1,500);
% sig7 = embed(y7,1,2);
% log7 = logistic(500,4);
% cleansig7 = embed(log7,1,2);
% elocal = enhanceLocal(sig7,cleansig7);
% phaseplot(elocal);
% pause;
% elocal = enhanceLocalFramed(sig7,cleansig7);
% phaseplot(elocal);
% pause;
% elocal = enhanceLocalPartial(sig7,cleansig7);
% phaseplot(elocal);