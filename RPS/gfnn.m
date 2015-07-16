function percent = gfnn(signal, dimension, timeLag, gfnnRatio)

% percent = gfnn(signal, dimension, timeLag, gfnnRatio)
%
% Input Variables
%       signal - a set of signals
%       dimension -  the estimated dimension of the RPS for the signal
%       timeLag -    time lag to use for the reconstructed phase spaces
%       gfnnRatio -  ratio to use to determine if a point is a false nearest
%                    neighbor (default is 15)
%
% Output Variables
%
%       percent - % of global false nearest neighbors
%  
% Description:  Uses global false nearest neighbor (fnn) method to determine
%               percentage of fnn. Based on method described in Abarbanel (1996),
%               section 4.2. See eqn. 4.6.
%
% Requirments:  Uses TSTool toolbox.
%

% Created:     
%               Date: 6/5/2003 
%               By:  Jinjin Ye
%               Marquette University
%
% Modified:    
%               Version: 2.0
%               Date: 6/20/2003
%               By: Richard J. Povinelli
%               Why: Clean up and write comments
%
%               Version: 2.1
%               Date: 8/29/2003
%               By: Richard J. Povinelli
%               Why: fix check for distance = 0
%
%               Version: 2.2
%               Date: 6/7/04
%               By: Justin Evert
%               Why: Added code to check if user entered lag
%               vector; if so, changed it to tau.

GFNN_RATIO = 15; %based on Abarbanel's experimental results

if nargin < 4
  gfnnRatio = GFNN_RATIO; 
end
if (length(timeLag) >1)
    timeLag = timeLag(1);
end

%create an rps with timeLag points removed so that the next dimension
%distance can be calculated without running past the end of the array
rps = embed(signal(1:length(signal) - timeLag),createLags(dimension,timeLag));
atria = nn_prepare(rps'); % creates data structure for search
[temp numberOfPoints] = size(rps);
queryIndices = 1:numberOfPoints;
numberOfNearestNeighbors = 1;
indicesToExclude = 0; % means exclude self
[nnIndices distance] = nn_search(rps', atria, queryIndices, numberOfNearestNeighbors, ...
                                 indicesToExclude);

sumFalseNearestNeighbors = 0;
for k = 1:numberOfPoints
  nextDimensionDistance = abs(signal(k + dimension * timeLag) ...
                          - signal(nnIndices(k) + dimension * timeLag));
  if distance(k) + nextDimensionDistance > 0 %if = 0, than its not a false nearest neighbor
    if distance(k) == 0 || ... % identical points getting pulled apart in next dimension
       nextDimensionDistance / distance(k) > gfnnRatio %eq. 4.6 from Abarbanel, 1996
      sumFalseNearestNeighbors = sumFalseNearestNeighbors + 1;
    end %if
  end %if
end %for

percent = sumFalseNearestNeighbors / numberOfPoints;

return
