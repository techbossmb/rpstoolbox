% *******************************************************************
% NOTE: Descriptions are nearly word for word from
% http://www.cs.ucsd.edu/users/mdailey/netlab-help/index.htm
% with minor modifications to organize the documentation.  It contains
% most of the help information obtained from getting help for the name 
% GMM function
% *******************************************************************
% 
%
% *******************************************************************
% mix = gmm(dim, ncenters, covar_type)
% *******************************************************************
% 
% Input Variables
%       dim - the dimension of the space
%       ncenters - the number of centers in the mixture model
%       covar_type - the type of the mixture model, which defines the
%                    covariance structure of each component Gaussian
%                    'spherical' = single variance parameter for 
%                                  each component: stored as a vector
%                    'diag'      = diagonal matrix for each component:
%                                  stored as rows of a matrix
%                    'full'      = full matrix for each component: 
%                                  stored as 3d array
%
% Output Variables
%       mix - the data structure containing information about Gaussian
%             Mixture Model (GMM).  The fields of mix are:
%               type       = 'gmm'
%               nin        = the dimension of the space
%               ncentres   = number of mixture components
%               covar_type = string for type of variance model
%               priors     = mixing coefficients
%               centres    = means of Gaussians: stored as rows 
%                            of a matrix
%               covars     = covariances of Gaussians 
%
% Description:  Creates a Gaussian mixture model with specified 
%               architecture.  The priors are initialized to equal 
%               values summing to one, and the covariances are all 
%               the identity matrix (or equivalent). The centers 
%               are initialised randomly from a zero mean unit variance 
%               Gaussian. This makes use of the MATLAB function randn 
%               and so the seed for the random weight initialization 
%               can be set using randn('state', s) where s is the state
%               value. 
%
%
% *******************************************************************
% mix = gmminit(mix, x, options)
% *******************************************************************
% 
% Input Variables
%       mix - data structure defining the parameters of a 
%             Gaussian mixture model
%       x   - dataset to initialize the Gaussian mixture model
%
% Output Variables
%       mix - data structure defining the parameters of a 
%             Gaussian mixture model.  The fields of mix are:
%               type       = 'gmm'
%               nin        = the dimension of the space
%               ncentres   = number of mixture components
%               covar_type = string for type of variance model
%               priors     = mixing coefficients
%               centres    = means of Gaussians: stored as rows 
%                            of a matrix
%               covars     = covariances of Gaussians 
%
% Description:  The k-means algorithm is used to determine the centers.
%               The priors are computed from the proportion of examples 
%               belonging to each cluster.  The covariance matrices are
%               calculated as the sample covariance of the points 
%               associated with (i.e. closest to) the corresponding 
%               centers. This initialization can be used as the 
%               starting point for training the model using the EM 
%               algorithm.
%
%
% *******************************************************************
% [mix, options, errlog] = gmmem(mix, x, options)
% *******************************************************************
% 
% Input Variables
%       mix     - data structure defining the parameters of a Gaussian 
%                 mixture model
%       x       - the data whose expectation is maximized, with each 
%                 row corresponding to a vector.
%       options - the optional parameters have the following
%                 interpretations: 
%                   options(1)
%                     set to 1 to display error values; also logs error 
%                     values in the return argument errlog.
%                     set to 0, to display only warning messages are 
%                     displayed
%                     set to -1 to display nothing.
%                   options(3) - measure of the absolute precision 
%                     required of the error function at the solution. 
%                     If the change in log likelihood between two steps 
%                     of the EM algorithm is less than this value, then 
%                     the function terminates. 
%                   options(5)
%                     set to 0 (default) to take no action. 
%                     set to 1 if a covariance matrix is reset to its 
%                     original value when any of its singular values 
%                     are too small (less than eps)
%                   options(14) - maximum number of iterations (default 
%                     is 100). 
%
% Output Variables
%       mix    - data structure defining the parameters of a Gaussian 
%                mixture model
%       option - The optional return value options contains the final 
%                error value (i.e. data log likelihood) in options(8)
%
% Description:  Uses the Expectation Maximization algorithm of Dempster 
%               et al. to estimate the parameters of a Gaussian mixture 
%               model.
%
%
% *******************************************************************
% function prob = gmmprob(mix, x)
% *******************************************************************
% 
% Input Variables
%       mix - data structure defining the parameters of a Gaussian 
%             mixture model
%       x   - contains the data vectors. Each row of x represents 
%             a single vector.
%
% Output Variables
%       prob - the unconditional data density p(x) for a Gaussian 
%              mixture model.
%
% Description:  This function computes the unconditional data density 
%               p(x) for a Gaussian mixture model.
