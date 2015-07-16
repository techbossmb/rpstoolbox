function classind=maxclass(scorematrix)

% classind=maxclass(scorematrix)
%
% Input Variables
%	scorematrix - N-by-M matrix, where N is the total number of testing samples 
%                 and M is the number of classes 
%
% Output Variables
%	classind - vector of length N containing class indices 
%
% Description
%	This code finds the class for each testing example from a score matrix
%

% Created
%	Date:  5/16/03
%	By:    Jinjin Ye
%	Marquette University
% 
% Source
%	From a phase space bayes phoneme classifier.
%
% Modifications
%	Version: #.#
%	Date:
%	By:
%	Why:

[maxscore classind]=max(scorematrix');