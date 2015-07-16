function [intercepts] = findRegions(EmbeddedArray,strips)

% [intercepts] = findRegions(EmbeddedArray,strips)
%
% Input Variables
%	EmbeddedArray - the embedding
%   strips - number of strips per dimension
%
% Output Variables
%	intercepts - intercepts for dividing up the regions
%
% Description
%	finds the intercepts to create n regions
%

% Created
%	Date:  01/09/2002
%	By:    Richard Povinelli
%	Marquette University
%
% Modifications
%	Version: #.#
%	Date:
%	By:
%	Why:

[Q N] = size(EmbeddedArray); %find out the dimension of the reconstructed phase space

intercepts = zeros(Q,strips-1); %need only n-1 intercepts for n strips
pointsPerStrip = N/strips;

for i = 1:Q %find intercepts for each dimension
  sortedValues = sort(EmbeddedArray(i,:));
  for j = 1:strips-1 %calculate the intercepts
    intercepts(i,j) = sortedValues(round(j*pointsPerStrip));
  end %for
end %for
