function probabilitymatrix = binTrain(EmbeddedArray,intercepts)

% probabilitymatrix = binTrain(EmbeddedArray,intercepts)
%
% Input Variables
%	EmbeddedArray - a cell array consisting of embedded signals of one class	                                                                                                                                        
%	intercepts - intercepts for dividing up the bins
%
% Output Variables
%	probabilitymatrix - the matrix of the probability masses for this class
%
% Description
%	This code outputs the trained matrix of probability masses of one class for using with the 
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
for m= 1 : length(EmbeddedArray)
    xembed=[xembed EmbeddedArray{m}];      
end

[dim1 none]= size(xembed);
[dim2 none]= size(intercepts);
if dim1==dim2
    probabilitymatrix=probabilityMasses(xembed,intercepts);
else
    error('dimension of parameters not match');
end
