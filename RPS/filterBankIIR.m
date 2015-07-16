function signals = filterBankIIR(signal,Wc,N,dB)

% signals = filterBankIIR(signal,Wc,N,dB)
%
% Input Variables
%	signal - The signal to be filtered.
%	Wc - The frequency cutoff(s) of the filter(s).
%       N - The order of the filters (default is 24)
%       dB - The attenuation of the stopbands in dB (default is 45)
%
% Output Variables
%	signals - A matrix of filtered signals by column.
%
% Description
%	This code filters a signal using an IIR filter bank. It puts the 
%   signal through forward and backward to eliminate phase distortion.
%   It is only intended for one-dimensional signals.
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
%   embedding them in a reconstructed phase space.
%
% Modifications
%	Version: #.#
%	Date:
%	By:
%	Why:

if nargin < 3
    N = 24;
end

if nargin < 4
    dB = 45;
end

signal = signal(:);
M = length(Wc); %# of bands-1

signals = [];

newsig = filterIIR(signal,Wc(1),'low',N,dB);
signals = [signals; newsig'];

for i = 1:M-1
    newsig = filterIIR(signal,[Wc(i) Wc(i+1)],'band',N,dB);
    signals = [signals; newsig'];
end

newsig = filterIIR(signal,Wc(M),'high',N,dB);
signals = [signals; newsig'];

signals = signals';


