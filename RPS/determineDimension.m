function dimension = determineDimension(timeSeries, timeLag)

% dimension = determineDimension(timeSeries, timeLag)
%
% Input Variables
%       timeSeries - a set of signals in a cell array
%       timeLag - time lag to use for the reconstructed phase spaces
%
% Output Variables
%       dimension - the estimated dimension of the RPS for the signal
%
% Language - MATLAB
%  
% Description:  Uses false nearest neighbor method to determine RPS
%               dimension
%
% Created:     
%               Date: 6/20/2003  
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modified:    
%               Version:
%               Date: 
%               By: 
%               Why: 

MAX_DIM = 30;
MIN_PERCENT_FNN = 0.001;

numberOfSignals = length(timeSeries);
dimensions = zeros(numberOfSignals,1);


%calculate the false nearest neighbor dimension for signal
for i = 1:numberOfSignals
  percentFNN = ones(MAX_DIM,1);
  
  %this is a do until, but matlab doesn't have this construct
  dim = 1;  
  percentFNN(dim) = gfnn(timeSeries{i}, dim, timeLag);
  while dim < MAX_DIM && percentFNN(dim) > MIN_PERCENT_FNN
    dim = dim + 1;
    percentFNN(dim) = gfnn(timeSeries{i}, dim, timeLag);
  end %while
  
  if percentFNN(dim) <= MIN_PERCENT_FNN %check if loop search ended early
    dimensions(i) = dim;
  else
    [dummy dimensions(i)] = min(percentFNN);
  end %if
end %for

dimension = ceil(mean(dimensions) + 2 * std(dimensions));

return