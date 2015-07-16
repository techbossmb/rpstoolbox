function y = tent(numOfPoints,mu,x_0,throwAway)

% [y] = tent(numOfPoints,mu,x_0,throwAway)
%
% Input Variables
%       numOfPoints - number of points wanted in signal returned
%       mu - the value of mu
%       x_0 - value of x(0), the initial value (default is a value selected
%       from the uniform distribution(0,1))
%       throwAway - number of initial points to throw away
%
% Output Variables
%       y - a set of points from the tent map
%
% Description
%        Computes points using the tent map:
%        x(t+1) = mu * [1 - 2 * abs(x(t) - 1/2)]
%        t is a parameter where 0 <= t <= 1.
%        x_0 is restricted so 0 <= x_0 <= 1.
%        The equation is chaotic when mu > 0.5
%

% Created     
%       Date: 1/26/01
%       By:  Richard J. Povinelli
%       Marquette University
%
% Source
%        http://newton.swarthmore.edu/courses/phys111_2001/Bruce-Tent-Map.pdf
%
% Modifications
%       Version: 2.0
%       Date: 1/31/03
%       By: Paul G. Hoffmann
%       Why: modified henon.m to work for a tent map.
%
%       Version: 3.0
%       Date: 2/26/03
%       By: Paul G. Hoffmann
%       Why: added default values for input parameters
%
%       Version: 4.0
%       Date: 4/16/03
%       By: Paul G. Hoffmann
%       Why: made changes to increase efficiency
%
%       Version 5.0
%       Date: 06/05/03
%       By: Justin Evert
%       Why: Variable corrections: changed iterations to numOfPoints

if (nargin < 4)
  throwAway = 500;
end
if (nargin == 2)
  x_0 = rand;
end

x = zeros(1,numOfPoints+throwAway); % pre-allocation to increase efficiency

x(1) = x_0; % intialize x
for t = (1:numOfPoints-1+throwAway)
  x(t+1) = mu * [1 - 2 * abs(x(t) - 1/2)]; % calculate the next point
end % for

y = x(throwAway+1:numOfPoints+throwAway);
