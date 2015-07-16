function probscore = binTest(Embedded, intercepts, probabilitymatrix)

% probscore = binTest(Embedded, intercepts, probabilitymatrix)
%
% Input Variables
%	Embedded - the embedded test signal 
%	intercepts - intercepts for dividing up the bins
%   probabilitymatrix - the matrix of the probability masses of assumed class
%
% Output Variables
%	probscore - the log probability score for the testing instance
%
% Description
%	This code outputs the probability score by the phase space bin-based bayes classifier
%   for an embedded testing signal.
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

[dim len]=size(Embedded);

p0=eps; 
probscore=0;
for j=1:len
    r1=1+sum(Embedded(1,j)>intercepts(1,:));
    reg='';
    for d=2:dim
        r=1+sum(Embedded(d,j)>intercepts(d,:));
        reg=[reg ',' int2str(r)];
    end
    evalstr=['probabilitymatrix(' int2str(r1) reg ')'];
    temp=eval(evalstr);
    probscore=probscore+log10(max(temp,p0));        
end

