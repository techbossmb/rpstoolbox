function Y = whiteNoise(signalLength, mu, var)

% [y] = whiteNoise(signalLength, mu, var)
%
% Input Variables
%       signalLength - number of iterations
%       mu - the mean for the white noise (default is 0)
%       var - the variance for the white noise(default is 1)
%
% Output Variables
%       y - a set of points making up the white noise
%
% Description
%       generate a sample random distribution of N points
%       with mean mu and variance var
%

% Created
%       Date: 2/5/03
%       By:  Paul G. Hoffmann
%       Marquette University
%
% Source
%       http://www.mathworks.com/access/helpdesk/help/techdoc/ref/randn.shtml
%       http://www.siglab.ece.umr.edu/ee268/fs2002/lab3.html
%       http://www.mathworks.com/access/helpdesk/help/techdoc/ref/fft.shtml
%
% Modifications
%       Version: 2.0
%       Date: 2/7/03
%       By: Paul G. Hoffmann
%       Why: Changed variable to be signalLength.
%            Fixed error by replacing rand with randn, throwaway with throwAway
%
%       Version: 3.0
%       Date: 2/26/03
%       By: Paul G. Hoffmann
%       Why: Removed throwAway as input variable
%            added default values for input parameters

if (nargin < 3)
  var = 1;
end
if (nargin == 1)
  mu = 0;
end

Y = mu + sqrt(var)*randn(1,signalLength);
