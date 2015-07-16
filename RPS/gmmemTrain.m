function mix = gmmemTrain(covartype,numMix,trainDataM,options)

% mix = gmmemTrain(covartype,numMix,trainDataM,options)
%
% Input Variables
%       covartype - covariance structure
%       numMix - number of mixtures
%       trainDataM - embedded data to train on
%       options - options for GMM (see gmmHelp for more info)
%
% Output Variables
%       mix - data structure for GMM
%
% Description:  Trains a GMM.
%
% Requirments:  Netlab Toolbox
%


% Created     
%       Date: 2/19/2003
%       By:  Paul G. Hoffmann
%       Marquette University
%
% Modified:    
%       Version: 2.0
%       Date: 3/18/2003
%       By: Paul G. Hoffmann
%       Why: Sarah J. Schmit found last line didn't
%           contain "mix = ".
%
%       Version: 3.0
%       Date: 4/14/2003
%       By: Paul G. Hoffmann
%       Why: Andrew Lindgren suggested improvements

% the dimension is the number of columns of trainDataM
temp = size(trainDataM);
if (temp(1) <temp(2))
    disp('Warning: May not have passed embedding correctly');
    disp('Embedding should be passed with each row as a time series');
end
temp = size(trainDataM);
mix = gmmem(gmminit(gmm(temp(2), numMix, covartype), trainDataM, options), trainDataM, options);
