% RPS Toolbox
% 08 July 2003
% 
% Note: Requires MATLAB Signal Processing Toolbox, Netlab (GMM Toolbox), and TSTools Toolbox
% 
% Bin
%     bintest - calculates probability score by the phase space bin-bases bayes classifier
%     bintrain - trains a matrix of probability masses using the phase space bin-bases bayes classifier
%     decideintercepts - decides intercepts for bins used in training and testing in phase space bin-based bayes classifier
%     findRegions - finds the intercepts to create regions of a reconstructed phase space
%     probabilityMasses - finds probability masses for each region
% 
% Embedding Tools
%     createLags - creates the lag structure with uniformly spaced lags
%     determineDimension - given a signal and lag, determines the dimension using the false nearest neighbor method
%     determineTimeLag - given a signal, determines the time lag using the first minimum of the automutual information function
%     embed - embeds a time series - options include standard embedding, or embedding with difference or delta
%     gfnn - uses global false nearest neighbor method to determine percentage of fnn
%     normalize - performs phase space normalization for an embedded signal
%     phaseplot - plots an embedded phase space
%     
% Filterbanks
%     filterBankFIR - filters a signal using an FIR filter bank
%     filterBankIIR - filters a signal using an IIR filter bank
%     filterIIR - filters a signal using an IIR filter
% 
% GMM Modeling
%     gmmemTest - evaluates the log probability of a data matrix
%     gmmemTrain - trains a gmm
%     gmmhelp - descriptions of GMM Matlab functions
%     makegmmPlot - Creates a 2-D plot of the GMM given the data and number of mixtures
%     maxclass - finds the class for each testing example from a score matrix
% 
% Signal Enhancement
%     enhanceGlobal - Uses global projection to enhance RPS with optional automatic order selection - Merhav et al. method
%     enhanceGlobalFramed - Uses global projection on each frame to enhance RPS with optional automatic order selection overlap
%     enhancedLocal - Uses local projection to enhance RPS with optional automatic order selection (final projection dim)
%     enhancedLocalFramed - Uses "double-windowing" local projection on each frame to enhance RPS, then uses hanning-weighted OLA to reconstruct signal
%     enhanceLocalPartial - "Double-windowing" method of local projection enhancement with optional automatic order selection
% 
% System Maps
%     henon - computes points using the henon map
%     logistic - computes points using the logistic map
%     lorenzeFun - Evaluates lorenz derivatives at point y with params a,b,c
%     rosslerFun - Evaluates rossler derivatives at point y with params a,b,c
%     tent - computes points using the tent map
% 
% Utilities
%     mode - calculates the mode of a set
%     randomizeArray - uniformly shuffles an array
%     surrogate - creates a surrogate for the given data
%     whiteNoise - generates a random distribution of N points with given mean and variance
% 
% 
% densityEstimation - estimates the discrete density distribution of a feature matrix in its feature space
% toolBoxTestScript - Script that will test all programs and yield sample results