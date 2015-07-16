function signals = filterBankFIR(signal,Wn,window)

% signals = filterBankFIR(signal,Wn,window)
%
% Input Variables
%	signal - The signal to be filtered.
%	Wn - The frequency cutoff(s) of the filter(s).
%       window - The window used for filtering (default is kaiser(255,8)).
%
% Output Variables
%	signals - A matrix of filtered signals by row.
%
% Description
%	This code filters a signal using an FIR filter bank. The signals are
%	returned as a matrix; each row is a signal. It is only intended for 
%   	one-dimensional signals.
%
%
% Requirments:  Signal Processing Toolbox
%

% Created
%	Date:  5/7/03
%	By:    Kevin Indrebo
%	Marquette University
% 
% Source
%	Written by Kevin Indrebo for use in filtering speech signals before
%   	 embedding them in a reconstructed phase space.
%
% Modifications
%	Version: 1.0.1
%	Date: 5/8/03
%	By: Kevin Indrebo
%	Why: Removed call to impulse function and replaced with (n == 0)
%        to make more efficient. Based on Jinjin Ye's suggestion.

if nargin < 3
    window = kaiser(255,8);
end

signal = signal(:);

len = length(Wn); %# of bands-1
index = ceil(len / 2);
Wc = Wn(index);

halflen = floor(length(window)/2);

n = -halflen:halflen;

hlow = Wc * sinc(Wc * n); %impulse response of lowpass FIR
hhigh = (n == 0) - hlow; %impulse response of highpass FIR

hlow = hlow .* window';
hhigh = hhigh .* window';

lowband = filter(hlow,1,signal);
highband = filter(hhigh,1,signal);


%-------------recursive call-------------------
if index ~= 1 %performed if low sub-band needs to be decomposed further
    lowcutoffs = Wn(1:index-1);
    lowband = filterBankFIR(lowband,lowcutoffs,window);
end

if index ~= len %performed if high sub-band needs to be decomposed further
    highcutoffs = Wn(index+1:len);
    highband = filterBankFIR(highband,highcutoffs,window);
end

signals = [lowband, highband]; %puts filtered signals into output matrix






