function surr = surrogate(timeSeries)

% [surr] = surrogate(timeSeries)
%
% Input Variables
%       timeSeries - collection of time series points for creating
%           the surrogate
%
% Output Variables
%       surr - collection of points making up the surrogate
%
% Description:  Creates a surrogate for the given data
%

% Created:     
%               Date: 1/07/2001
%               By:  Xiaolin Liu
%               Marquette University
%
% Modified:    
%               Version: 2.0
%               Date: 1/31/2003
%               By: Paul G. Hoffmann
%               Why: code given to Paul Hoffmann in email.
%
%               Version: 2.1
%               Date: 7/8/2003
%               By: Justin Evert
%               Why: Verify input is a column vector (suggested by Dr.
%               Povinelli)

timeSeries = timeSeries(:); % Make sure this is a column vector %fje2.1
z = fft(timeSeries);
% randomize the phases
ph = 2*pi*rand(ceil(length(z)/2) - 1, 1);
if rem(length(z),2) == 0
    ph = [ 0; ph; 0; -flipud(ph) ];
else
    ph = [ 0; ph; -flipud(ph) ];
end
z = z .* exp(j*ph);
surr = real(ifft(z));
