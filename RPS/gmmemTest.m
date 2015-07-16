function logProb = gmmemTest(mix,d,options)

% logProb = gmmemTest(mix,d,options)
%
% Input Variables
%       mix - mixture model structure
%       d   - embedded data
%       options - see Modifications section (default is 0)
%
% Output Variables
%       logProb - total log probability
%
% Description
%       Evaluates the log probability of a data matrix.
%
%
% Requirements:  Netlab Toolbox
%

% Created     
%       Date: 5/14/2003
%       By:  Andrew Lindgren
%       Marquette University
%
% Modified
%	Version: 1.0
%	Date: 07/15/03
%	By: Sarah Schmit
%		Line numbers: 32-36
%		 add options(5) as optional input
%		set options(5) = 1 to use v1.0 fix of gmmactiv to avoid chol error


%sjs: add options as an optional input
if (nargin < 3)
  options(5) = 0;
end
%end sjs

z = size(d);
if (z(1)<z(2))
    disp('Warning: May not have passed embedding correctly');
    disp('Embedding should be passed with each row as a time series');
end

x = gmmprob(mix,d,options);         % get probability from the NETLAB toolbox
x(find(x == 0)) = realmin;  % floor the zero values to prevent an error
logProb = sum(log10(x));          % sum the log probabilities
   