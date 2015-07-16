function masses = probabilityMasses(EmbeddedArray,intercepts)

% masses = probabilityMasses(EmbeddedArray,intercepts)
%
% Input Variables
%	EmbeddedArray - the embedding
%       intercepts - the intercepts for the regions along each dimension
%
% Output Variables
%	masses - the matrix of the masses
%
% Description
%	finds probability masses for each region
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

[Q N] = size(EmbeddedArray);
[dummy interceptCount] = size(intercepts);
strips = interceptCount + 1;
counts = zeros(ones(1,Q)*strips);


for i = 1:N
  strip = zeros(Q,1); %the strip to increment for this point
  for j = 1:Q %determine strip number for each dimension
    for k = 1:strips-1
      if EmbeddedArray(j,i) <= intercepts(j,k) %less than this intercept
        strip(j) = k; %so increment the kth strip for this dimension
        break; %found a strip, so no need to look further
      end %if
    end%for
    if strip(j) == 0 %couldn't find a strip, so it is in the last one
      strip(j) = strips;
    end %if
  end %for

  if Q == 2
    counts(strip(1),strip(2)) = counts(strip(1),strip(2)) + 1;
  elseif Q == 3
    counts(strip(1),strip(2),strip(3)) = counts(strip(1),strip(2),strip(3)) + 1;
  else % need to dynamically index counts, find the linear index
    stripString = '';
    for j = 1:Q
      stripString = strcat(stripString, ', ', int2str(strip(j)));
    end %for

    evalString = strcat('sub2ind(size(counts)', stripString, ')');
  
    linIndex = eval(evalString);

    counts(linIndex) = counts(linIndex) + 1;
  end %if
end %for

masses = counts/N; %convert counts to frequencies