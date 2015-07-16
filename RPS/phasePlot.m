function phaseplot(timeSeries, lags, dimension, type, marker)

% function phaseplot(timeSeries,lags, dimension,type, marker)
%
% Input Variables
%       timeSeries - time series to be embedded and plotted
%       lags - either a vector of lags, not including the implied zero, or
%           a single value for tau when also entering a dimension value
%           (default [1 2])
%       dimension - number of dimensions in the phase space (default 3)
%       type - type of embedding to be performed:
%           1 = standard embedding (Default)
%           2 = embed with delta
%           3 = embed with difference
%       marker - 0 for unconnected points, 1 for connected lines (default 0)
%
%       Note: User may enter an embedding in place of a time series by not
%       supplying other input arguments
%
% Output Variables
%       none
%
% Description:  Plot an embedded phase space (for example, from embed.m)
% 		If the dimension is 2, will do 2-d plot
% 		If the dimension is 3, will do 3-d plot
% 		If the dimension is 4 or greater, will do a 3-d plot with color
% 		    variation
%       
%       Note: Marker type will be reset to '.' if dimension 4 or greater

% Created:     
%               Date: 02/20/2003
%               By:  Michael T. Johnson
%               Marquette University
%
% Modifications
%	Version: 2.0
%	Date: 6.2.04
%	By: Tim Stolldorf, Lily Brown
%	Why: Added 6 dimension functionality
%
%   Version: 3.0
%   Date: 6/7/04
%   By: Lily Brown, Justin Evert
%   Why: Added ability to enter embedding in place of time series
%        Fixed error that placed color value out of range

if (nargin<5)
    marker =0;
end
if (nargin<4)
    type=1;
end
if (nargin<3)
    dimension = 3;
end
if (nargin<2)
    lags= [1 2];
end
if (marker==0)
    markerstr='.';
else
    markerstr='-';
end
if (nargin ==1)
    y = size(timeSeries);
    if (y(1)>1)
        phasespace = timeSeries;
    else
        phasespace = embed(timeSeries, lags, dimension, type);        
    end
else
    phasespace = embed(timeSeries, lags, dimension, type);
end


d=size(phasespace,1);
if(d>3)
    markerstr = '.';
end

if (d==2)
    plot(phasespace(1,:),phasespace(2,:),markerstr);
    
elseif (d==3)
    plot3(phasespace(1,:),phasespace(2,:),phasespace(3,:),markerstr);
    
elseif (d==4)
    N = size(phasespace); % Determine total number of points in original time series
    pointsInPhaseSpace = N(2);
    maxFourPhasePoints = max(abs(phasespace(4,:))); % Find the maximum value in the phase space at dimension 4
    for i = 1:pointsInPhaseSpace
        plot3(phasespace(1,i),phasespace(2,i),phasespace(3,i),markerstr,'MarkerEdgeColor',[abs(phasespace(4,i))/maxFourPhasePoints,0,0]);
        hold on;
    end
    hold off;
elseif (d==5)
    N = size(phasespace); % Determine total number of points in original time series
    pointsInPhaseSpace = N(2);
    maxFourPhasePoints = max(abs(phasespace(4,:))); % Find the maximum value in the phase space at dimension 4
    maxFivePhasePoints = max(abs(phasespace(5,:))); % Find the maximum value in the phase space at dimension 5
    for i = 1:pointsInPhaseSpace
        plot3(phasespace(1,i),phasespace(2,i),phasespace(3,i),markerstr,'MarkerEdgeColor',[abs(phasespace(4,i))/maxFourPhasePoints,abs(phasespace(5,i))/maxFivePhasePoints,0]);
        hold on;
    end
    hold off;
elseif (d==6)
    N = size(phasespace); % Determine total number of points in original time series
    pointsInPhaseSpace = N(2);
    maxFourPhasePoints = max(abs(phasespace(4,:))); % Find the maximum value in the phase space at dimension 4
    maxFivePhasePoints = max(abs(phasespace(5,:))); % Find the maximum value in the phase space at dimension 5
    maxSixPhasePoints = max(abs(phasespace(6,:))); % Find the maximum value in the phase space at dimension 6
    for i = 1:pointsInPhaseSpace
        plot3(phasespace(1,i),phasespace(2,i),phasespace(3,i),markerstr,'MarkerEdgeColor',[abs(phasespace(4,i))/maxFourPhasePoints,abs(phasespace(5,i))/maxFivePhasePoints,abs(phasespace(6,i))/maxSixPhasePoints]);
        hold on;
    end
    hold off;
else
    error('Dimensions above 6 not supported.');
end