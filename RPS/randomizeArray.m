function randomizedArray = randomizeArray(array)

% randomizedArray = randomizeArray(array)
%
% Input Variables
%       array - An array
%
% Output Variable
%       randomizedArray - A shuffled array
%
% Language - MATLAB
%  
% Description:  Uniformly shuffles an array
%
% Created:     
%               Date: 6/19/2003  
%               By:  Richard J. Povinelli
%               Marquette University
%
% Modified:    
%               Version:
%               Date: 
%               By: 
%               Why: 

array = array(:); %turn into a column vector
arrayLength = length(array);
p = randperm(arrayLength);
I = eye(arrayLength,arrayLength);
P = I(p,:); %permutation matrix
randomizedArray = (array' * P)'; %randomizes the array
  
return