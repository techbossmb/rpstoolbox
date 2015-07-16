function [lags] = createLags(dimension, timeLag)

% [lags] = createLags(dimension, timeLag)
%
% Input Variables
%       dimension - dimension to use for the reconstructed phase spaces
%       timeLag - time lag to use for the reconstructed phase spaces
%
% Output Variables
%       lags - vector of indices to use for forming RPS.
%
% Language - MATLAB
%  
% Description:  Creates the lag structure with uniformly spaced lags for
%               the embed function.
%
% Created:     
%               Date: 6/30/2003  
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modified:    
%               Version:
%               Date: 
%               By: 
%               Why: 

lags = [timeLag:timeLag:timeLag*(dimension-1)];
return