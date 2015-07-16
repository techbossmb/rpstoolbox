function prob = gmmprob(mix, x, options)
%GMMPROB Computes the data probability for a Gaussian mixture model.
%
%	Description
%	 This function computes the unconditional data density P(X) for a
%	Gaussian mixture model.  The data structure MIX defines the mixture
%	model, while the matrix X contains the data vectors.  Each row of X
%	represents a single vector.
%
%	See also
%	GMM, GMMPOST, GMMACTIV
%

%	Copyright (c) Ian T Nabney (1996-2001)

% Modified
%	Version: 1.0
%	Date: 07/15/03
%	By: Sarah Schmit
%		Line numbers: 25-29
%		 add options(5) as optional input
%		set options(5) = 1 to use v1.0 fix of gmmactiv to avoid chol error


%sjs: add options as an optional input
if nargin < 3
  options(5) = 0;
end
%end sjs

% Check that inputs are consistent
errstring = consist(mix, 'gmm', x);
if ~isempty(errstring)
  error(errstring);
end

% Compute activations
a = gmmactiv(mix, x, options);

% Form dot product with priors
prob = a * (mix.priors)';