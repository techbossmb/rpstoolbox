function timeLag = determineTimeLag(timeSeries)

% timeLag = determineTimeLag(timeSeries)
%
% Input Variables
%       timeSeries - a set of signals
%
% Output Variables
%       timeLag - time lag to use for the reconstructed phase spaces
%
% Language - MATLAB
%  
% Description:  Uses first minimum of the automutual information function
%               to set time lag
%
% Requirements: TSTools
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

numberOfSignals = length(timeSeries);
timeLags = zeros(numberOfSignals,1);

%calculate the automutual information function for signal
for i = 1:numberOfSignals
  timeLags(i) = firstmin(amutual2(signal(timeSeries{i}'),floor(length(timeSeries{i}) * 0.1)));
end %for

timeLag = mode(timeLags);

return