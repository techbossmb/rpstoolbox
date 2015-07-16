function EmbeddedNorm=normalize(Embedded)

% EmbeddedNorm=normalize(Embedded)
%
% Input Variables
%	Embedded - input embedded signal
%
% Output Variables
%	EmbeddedNorm - normalized embedded signal using radius of gyration
%
% Description
%	This code performs phase space normalization for embedded signal
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

[dim len]=size(Embedded);
sum=0;
for i=1:dim
    Embedded(i,:)=Embedded(i,:)-mean(Embedded(i,:));
    sum=sum+mean(Embedded(i,:).^2);
end

EmbeddedNorm=Embedded/sqrt(sum);
