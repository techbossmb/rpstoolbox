function newsig = filterIIR(signal,Wc,hilo,N,dB)

% newsig = filterIIR(signal,Wc,hilo,N,dB)
%
% Input Variables
%	signal - The signal to be filtered.
%	Wc - The frequency cutoff(s) of the filter(s).
%       hilo - A string specifying the type of filter [low,high,band] (default is low)
%       N - The order of the filter (default is 24)
%       dB - The attenuation of the stopband in dB (default is 45)
%
% Output Variables
%	newsig - The filtered signal
%
% Description
%	This code filters a signal using an IIR filter. It puts the signal through
%   forward and backward to eliminate phase distortion. It is only intended
%   for one-dimensional signals.
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

if nargin < 5
    dB = 45;
end

if nargin < 4
    N = 24;
end

if nargin < 3
    hilo = 'low'; %lowpass by default
end

len = length(Wc); %if cutoff is array, bandpass

if len > 1
    type = 'band';
end

signal = signal(:);

%------------lowpass filter---------------
if strcmp(hilo,'low') 
    
    [z1,p1,k1] = cheby2(N,dB,Wc); %zero/poles from Chebychev type II filter
    [S1,G1] = zp2sos(z1,p1,k1); %convert z/p to SOS sections, gain
    
    temp1 = G1 *(sosfilt(S1,signal)); %pass signal through filter once
	N1 = length(temp1);
	temp1 = temp1(N1:-1:1); %reverse filtered signal
	lowband = G1 * (sosfilt(S1,temp1)); %pass reversed signal through filter
	newsig = lowband(N1:-1:1); %reverse signal again
	
%------------bandpass filter---------------
elseif strcmp(hilo,'band')
    
    [z1,p1,k1] = cheby2(N,dB,Wc); %zero/poles from Chebychev type II filter
    [S1,G1] = zp2sos(z1,p1,k1); %convert z/p to SOS sections, gain
        
    temp1 = G1 *(sosfilt(S1,signal)); %pass signal through filter once
	N1 = length(temp1);
	temp1 = temp1(N1:-1:1); %reverse filtered signal
	midband = G1 * (sosfilt(S1,temp1)); %pass reversed signal through filter
	newsig = midband(N1:-1:1); %reverse signal again
    
%------------highpass filter---------------
elseif strcmp(hilo,'high')
    
    [z1,p1,k1] = cheby2(N,dB,Wc,'high'); %zero/poles from Chebychev type II filter
    [S1,G1] = zp2sos(z1,p1,k1); %convert z/p to SOS sections, gain
    
    temp1 = G1 *(sosfilt(S1,signal)); %pass signal through filter once
	N1 = length(temp1);
	temp1 = temp1(N1:-1:1); %reverse filtered signal
	highband = G1 * (sosfilt(S1,temp1)); %pass reversed signal through filter
	newsig = highband(N1:-1:1); %reverse signal again
    
else
    disp('error');
    return;
end






