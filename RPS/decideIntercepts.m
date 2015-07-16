function intercepts = decideIntercepts(EmbeddedArray,strips)

% intercepts = decideIntercepts(EmbeddedArray,strips)
%
% Input Variables
%	EmbeddedArray - a cell array consisting of embedded signals of one class	                                                                                                                                        
%	strips - number of strips per dimension
%
% Output Variables
%	intercepts - intercepts for dividing up the bins
%
% Description
%	This code outputs decides intercepts of bins used for training and testing the 
%   phase space bin-based bayes classifier.
%

% Created
%	Date:  5/16/03
%	By:    Jinjin Ye
%	Marquette University
% 
% Source
%	From a phase space bin-based bayes phoneme classifier.
%
% Modifications
%	Version: #.#
%	Date:
%	By:
%	Why:

xembed=[];
for j=1:length(EmbeddedArray)
    xembed=[xembed EmbeddedArray{j}]; 
end

intercepts=findregions(xembed,strips);
