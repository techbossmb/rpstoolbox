function phaseSpace = embed(timeSeries,lags, dimension, type)

% phaseSpace = embed(timeSeries,lags, dimension, type)
%
% Input Variables
%       timeSeries - one dimensional time series to be embedded into multiple dimensions
%       lags - vector of lags to use for the embedding, or single value for
%       tau when entered with a dimension value
%       dimension - the number of dimensions in the RPS
%       type - 1 is regular embedding (default is 1)
%              2 is embed with delta
%              3 is embed with difference information
%
% Output Variables
%       phaseSpace - matrix containing the embedded values (reconstructed phase space)
%  
% Description:  Embeds the inputted time series according to the lags. It assumes that
%               the 1st dimension will be the original time series with no
%               lag. May perform one of three sets of embedding - standard
%               (type=1), with Delta (type=2), and with Difference
%               (type=3). Default is standard embed. May accept lags in one
%               of two fashions: either as a tau value with a dimension
%               value, or as a vector of lags.
%

% Created:     
%               Date: 7/14/99  
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modifications:    
%               Version: 2.0
%               Date: 1/9/2002
%               By: Richard J. Povinelli
%               Why: Made for single time series, cut out zero points
%
%               Version 3.0
%               Date: 4/3/2002
%               By: Felice M. Roberts
%               Why: Rewrote code to make efficient use of MATLAB's matrix manipulations.
%                    Added new header
%
%               Version 4.0
%               Date: 5/7/2002
%               By: Richard J. Povinelli
%               Why: fix - lags are subtracted not added
%
%               Version 5.0
%               Date: 6/30/2003
%               By: Richard J. Povinelli
%               Why: make sure timeSeries is row vector, so creating phase
%               space doesn't cause an error
%
%               Version 6.0
%               Date: 6/4/2004
%               By: Justin Evert
%               Why: Combine embed, embedWithDelta, and embedWithDiff into one file

if (nargin<4)
    type = 1;
end
if (nargin<3)
    dimension = length(lags)+1;
end
if (length(lags)==1)
    lags = createLags(dimension,lags);
end

timeSeries = timeSeries(:)'; %make sure it is a row vector
N = length(timeSeries); % Determine total number of points in original time series
lags = [0 lags];        % Put the zero delay for the first element (1st dimension, no lag)
Q = length(lags);       % Determine total number of dimensions
maxLag = max(lags);     % Determine the maximum lag
pointsInPhaseSpace = N - maxLag; %number of points in reconstructed phase space

% Create the reconstructed phase space
for i = 1:Q,
  lag = maxLag - lags(Q-i+1); %lag's are subtracted from current time index
  phaseSpace(i,(1:pointsInPhaseSpace)) = timeSeries(1+lag:pointsInPhaseSpace+lag);
end

switch type
    case 2
        x = (phaseSpace)';     % turn into column vector
        m = length(lags);    % number of dimensions in the orginal phase space
        s = size(x);            % size of array   
        y = x;                  % copy to new matrix

        % lines of code replicate to create full window on the top and bottom
        x = [x(1,:); x(1,:); x; x(s(2),:); x(s(2),:)];

        %does the linear regression to get the deltas
        for i = 1:s(1)  
             y(i, m+1:2*m) = ((x(i+3,:) - x(i+1,:)) + 2*(x(i+4,:)-x(i,:)))/10; %computes the deltas over each window
        end
        phaseSpace = (y)';
    case 3
%         x = embed((timeSeries)',lags,Q,1)';     % turn into column vector
        x = (phaseSpace)';
        m = length(lags);    % number of dimensions in the orginal phase space
        y = x(1:length(x)-1,:); % chops off last row of the matrix because we need a the rectanglur matrix
        y(:,m+1:2*m) = diff(x); % computes the difference information
        phaseSpace = (y)';
end