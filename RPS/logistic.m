function y = logistic(numOfPoints,k,x_0,throwAway)

% [y] = logistic(numOfPoints,k,x_0,throwAway)
%
% Input Variables
%       numOfPoints - number of points wanted in signal returned
%       k - parameter for logistic function
%       x_0 - value of x(0), the initial value (default is a value selected
%       from the uniform distribution(0,1))
%       throwAway - number of initial points to throw away (default is 500)
%
% Output Variables
%       y - a set of points from the logistic map
%  
% Description:  Computes points using the logistic map:
%               x(t+1) = k*x(t)*(1-x(t))
%               k is a parameter where 0 <= k <= 4.
%               x_0 is restricted so 0 <= x_0 <= 1.
%

% Created:     
%               Date: 1/26/2001
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modified:    
%               Version: 2.0
%               Date: 1/31/2003
%               By: Paul G. Hoffmann
%               Why: removing bifurcation plot, just have a 
%               logistic function.
%
%               Version: 3.0
%               Date: 2/26/2003
%               By: Paul G. Hoffmann
%               Why: added default values for input parameters
%
%               Version: 4.0
%               Date: 05/20/03
%               By: Paul G. Hoffmann
%               Why: improve efficiency
%
%               Version 5.0
%               Date: 06/05/03
%               By: Justin Evert
%               Why: Made necessary corrections in variable names:
%                   iterations change to numOfPoints, r changed to k

if (nargin < 4)
  throwAway = 500;
end
if (nargin == 2)
  x_0 = rand;
end

x = zeros(1,numOfPoints+throwAway); % pre-allocation to increase efficiency

x(1) = x_0; % intialize x

for t = (1:numOfPoints+throwAway-1)
  x(t+1) = k*x(t)*(1-x(t)); % calculate x
end %for
y = x(throwAway+1:numOfPoints+throwAway);

