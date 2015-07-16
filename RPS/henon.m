function y = henon(numOfPoints,a,b,x1_0,x2_0,throwAway)

% [y] = henon(numOfPoints,a,b,x1_0, x2_0,throwAway)
%
% Input Variables
%       numOfPoints - number of points wanted in signal returned
%       a - the value for a
%       b - the value for b
%       x1_0 - the value of x1(0) (default is a value selected
%       from the uniform distribution(0,1))
%       x2_0 - the value of x2(0)(default is a value selected
%       from the uniform distribution(0,1))
%       throwAway - number of initial points to throw away (default is 500)
%
% Output Variables
%       y - a set of points from the henon map
%
% Description:  Computes points using the henon map:
%               x1(t+1) = a - x1^2(t) + b * x1(t-1)
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
%               Why: removed plotting code, use different equation.
%
%               Version: 3.0
%               Date: 2/26/2003
%               By: Paul G. Hoffmann
%               Why: added default values for input parameters
%
%               Version: 4.0
%               Date: 05/19/03
%               By: Paul G. Hoffmann
%               Why: improve efficiency
%
%               Version 5.0
%               Date: 06/05/03
%               By: Justin Evert
%               Why: Variable correction: change iterations numOfPoints
%
%               Version 6.0
%               Date: 06/18/03
%               By: Paul Hoffmann
%               Why: Equation found on website appears to be an incorrect
%               equation.  The equation found in Dr. Povinelli's code is
%               now used.

if (nargin < 6)
  throwAway = 500;
end
if (nargin < 5)
  x2_0 = rand;
end
if (nargin == 3)
  x1_0 = rand;
end

x = zeros(1,numOfPoints+throwAway); % pre-allocation to increase efficiency

x(1) = x1_0; % intialize x1 and x2
x(2) = x2_0;
for t = (2:numOfPoints-1+throwAway)
  x(t+1) = a - x(t)^2 + b * x(t-1); % calculate next value
end %for
y = x(throwAway+1:numOfPoints+throwAway);

