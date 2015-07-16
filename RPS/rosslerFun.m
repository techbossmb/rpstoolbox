function yprime = rosslerFun(t,y,a,b,c)

% yprime = rosslerFun(t,y,a,b,c)
%
% Evaluates rossler derivatives at point y with params a,b,c
% This function can be used with Matlab differential equation
% solver tools such as "ODE45" to generate the rossler flow
%
% Input Variables
%       t - ignored (Rossler is time-independent)
%       y - current 3-element state vector
%       a - the value for a (default 0.2)
%       b - the value for b (default 0.2)
%       c - the value for c (default 5.7)
%
% Output Variables
%       yprime - derivative of state-vector at point y
%
% Description:  Rossler flow
%               y1prime = -(y2 + y3)
%               y2prime = y1 + a*y2
%               y3prime = b + y1*y3 - c*y3
% Example:
%               [t y] = ode45(@rosslerFun,[0 100],[0.1 0.1 0.1]);
%               plot3(y(:,1),y(:,2),y(:,3));

% Created
%               MTJ 4/7/04


if (nargin < 2)
    error('Requires time point and current 3-element state vector');
end
if (nargin <3)
    a=0.2;
end
if (nargin < 4)
    b=0.2;
end
if (nargin < 5)
    c=5.7;
end

if (length(y)~=3)
    error('Rossler flow only supports a 3-element state vector');
end

y=y(:);
yprime=zeros(3,1);

yprime(1) = -(y(2)+y(3));
yprime(2) = y(1) + a*y(2);
yprime(3) = b + y(1)*y(3) - c*y(3);