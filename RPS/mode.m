function m = mode(distribution)

% m = mode(distribution)
%
% Input Variables
%       distribution - a set of integers
%
% Output Variables
%       m - the mode
%  
% Description:  calculates the mode of a set
%

% Created:     
%               Date: 6/20/2003  
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modifications:    
%               Version: 2.0
%               Date: 7/23/2003
%               By: Richard J. Povinelli
%               Why: Using builtin hist command is much faster

minDist = min(distribution);
maxDist = max(distribution);

histogram = hist(distribution,minDist:maxDist);
[value index] = max(histogram);
m = index+minDist-1;

return