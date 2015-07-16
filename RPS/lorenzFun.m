function yprime = lorenzFun(t,y,a,b,c)

% yprime = lorenzFun(t,y,a,b,c)
%
% Evaluates lorenz derivatives at point y with params a,b,c
% This function can be used with Matlab differential equation
% solver tools such as "ODE45" to generate the lorenz flow
%
% Input Variables
%       t - ignored (Lorenz is time-independent)
%       y - current 3-element state vector
%       a - the value for a / Beta  (default 8/3)
%       b - the value for b / sigma (default 10)
%       c - the value for c / rho   (default 528)
%
% Output Variables
%       yprime - derivative of state-vector at point y
%
% Description:  Lorenz map
%               y1prime = - b*y1 - b*y2)
%               y2prime = c*y1 - y2 - y1*y3
%               y3prime = - a*y1 + y1*y2
% Example:
%               [t y] = ode45(@lorenzFun,[0 100],[0.1 0.1 0.1]);
%               plot3(y(:,1),y(:,2),y(:,3));

% Created
%               MTJ 4/7/04


if (nargin < 2)
    error('Requires time point and current 3-element state vector');
end
if (nargin <3)
    a=8/3;
end
if (nargin < 4)
    b=10;
end
if (nargin < 5)
    c=28;
end

if (length(y)~=3)
    error('Lorenz flow only supports a 3-element state vector');
end

y=y(:);
yprime=zeros(3,1);

yprime(1) = -b*y(1) + b*y(2);
yprime(2) = c*y(1) - y(2) - y(1)*y(3);
yprime(3) = -a*y(3) + y(1)*y(2);