function [sigout, err, dis, res] = enhanceLocalPartial(sigin, cleansig, first, last, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
% function [sigout, err, dis, res] = enhanceLocalPartial(sigin, cleansig, first, last, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
%
% Input Variables
%       sigin - input signal
%       cleansig - clean input signal for computing errors: dis, res, sqerr
%                  if empty [] then those outputs will be returned as NaN
%       first - start index of region to be enhanced (default=floor(0.33*length(sigin)))
%       last  - end index of region to be enhanced (default=floor(0.67*length(sigin)))
%       neighbors - number of pts in a local neighborhood (default=15)
%       exclude - half window size of signal points to exclude as neighbors (default=3)
%                 e.g. exclude=0 excludes only self, exclude=3 excludes a window of 7 points
%       lag -    base lag value OR full lag vector for RPS (default=1)
%                if using vector, must be size orgdim-1 (lag 0 is implied 1st dim)
%       orgdim - starting RPS dimension (default=15)
%       dimflag- 0 = fixed final dim, 1 = auto dim selection (default=0)
%       dimvar - if (dimflag=0): projected RPS dimension, must be < orgdim (default=5)
%       dimvar - if (dimflag=1): threshold for order/finaldim selection (default=0.5)
%                Typical range [0.1-1]: Results ARE sensitive to this value 
%       method - type of projection:
%                1: Least squares (default)
%                2: LMMSE
%                3: Time domain constraints (TDC)
%                4: Spectral domain constraints (SDC)
%       constraints - constraint parameters for methods 4 & 5
%                Method=3, TDC: scalar parameter mu (default=0.5)
%                Method=4, SDC: scalar param Wiener gain eta (default=0.5)
%       wtflag - 1 = (default) reconstruction with time-aligned Hanning weighted averaging
%                0 = reconstruction with individual points from columns
%
% Output Variables
%       sigout - output signal
%       err - signal error
%       dis - signal distortion
%       res - noise residual
%
% Description:  "Double-windowing" method of local projection enhancement
%               with optional automatic order selection (final projection dim)
%               Routine builds a single nearest-neighbor search database
%               and uses it to enhance a (center) portion of the original signal.
%               Specifically designed to be called by "EnhanceLocalFramed"
%               Hanning window weights used for RPS signal reconstruction
%               Noise power is average of noise subspace eigenvalues
%
% Requirments:  Signal Processing Toolbox
%

% Created:     
%               Date: 9/30/2003
%               By:  Mike Johnson
%               Marquette University
%
% Modified:     5/20/04 MTJ  Added
%                    dis, res, sqerr outputs (from enhanceglobal)
%                    lagvector option (from enhanceglobal)
%                    single column option (from enhanceglobal)
%               5/24/04 MTJ Changed order 1st two elements
%               6/2/04 MTJ Changed error outputs to signals

if nargin < 1
    error('Neet at least an input signal');
end
if nargin < 2
    cleansig=[];
end
if nargin < 3
    first=floor(0.3333*length(sigin));
end
if nargin < 4
    last=floor(0.6667*length(sigin));
end
if nargin < 5
    neighbors = 15;
end
if nargin < 6
    exclude=3;
end
if nargin < 7
    lag=1;
end
if nargin < 8
    orgdim=15;
end
if nargin < 9
    dimflag=0;
end
if ((nargin <10) & ~dimflag)
    dimvar=5;
end
if ((nargin < 10) & dimflag)
    dimvar=0.5;
end
if (dimflag)
    thresh=dimvar;
else
    findim=dimvar;
end
if (~dimflag & ~(orgdim>findim))
    error('Original dimension must be > final dimension');
end
if nargin < 11
    method=1;
end
if (method==3)
    if (nargin < 12)
        constraints=0.5;
    end
    mu=constraints;
end
if (method==4)
    if (nargin < 12)
        constraints=0.5;
    end
    eta=constraints;
end
if (nargin < 13)
    wtflag=1;
end


if (length(sigin) < (1+lag*(orgdim-1)))
    error('Not enough points to embed in RPS');
end
if (length(lag)==1)
    lagvec=createlags(orgdim,lag);
else
    lagvec=lag;
end

if (length(lagvec)~=(orgdim-1))
    error('Size of lagvector must be orgdim-1 (0 is 1st lag)');
end

if (length(cleansig)<1)
    orgflag=0;
elseif (length(cleansig) ~= length(sigin))
    error('Signal and reference must be same length');
else
    orgflag=1;
    cleansig=cleansig(:)';
    sigin=sigin(:)';
    sigpts=length(sigin);    
    noisesig=sigin-cleansig;
    noisesig=noisesig(:)';
    rpsn=embed(noisesig,lagvec);   % Note rps=rpsc+rpsn
    rpsc=embed(cleansig,lagvec);
end


% Embed
rps=embed(sigin,lagvec);  %rps is d x N

% NN search: From TStools toolbox
atria = nn_prepare(rps');
rpslen=size(rps,2);
[indices distances] = nn_search(rps', atria, 1:rpslen, neighbors, exclude);

maxlag=max(lagvec);
%newrpslen=last-first+maxlag+1;
newrps=zeros(orgdim,rpslen);
rps_dist=zeros(orgdim,rpslen);
rps_res=zeros(orgdim,rpslen);
for i=(first-maxlag):last    %All rps points s.t. sig(first..last) are elements
    localrps=rps(:,indices(i));
    
    scat=localrps*localrps';
    [u s v]=svd(scat);  % Columns of V (=U) are eigenvectors of covariance of localrps
    singvals=diag(s);
    
    % Determine projection dimension based on eigenvalues
    % Max dimension is (orgdim-1) - better noise power estimate
    if (dimflag)
        mindim=1; maxdim=orgdim-1;   % optional: hard-coded limits on automatic order selection
        if orgdim<2  % just in case - don't bother doing anything
            findim=orgdim;
            noisepow=0;
        else
            for j=1:orgdim   % average of i lowest eigenvalues
                sigmasq(j)=sum(singvals(j:orgdim))/(orgdim-j+1);
            end
            sigmasq=sigmasq+eps*(sigmasq==0);
            eigratio=sigmasq(1:orgdim)./sigmasq(orgdim-1);
            findim=sum(eigratio > (1+thresh));
            findim=max(findim,mindim); findim=min(findim,maxdim);
            noisepow=mean(singvals(findim+1:orgdim));         % average of noise subspace eigs
        end
    end
    if (~dimflag)
        noisepow=mean(singvals(findim+1:orgdim));             % average of noise subspace eigs
    end
    
    % Build projection matrix
    switch method
    case 1
        H=u(:,1:findim)*u(:,1:findim)';
    case 2
        H=u(:,1:findim)*diag((singvals(1:findim)-noisepow)./singvals(1:findim))*u(:,1:findim)';
    case 3
        H=u(:,1:findim)*diag((singvals(1:findim)-noisepow)./(singvals(1:findim)-(1-mu)*noisepow))*u(:,1:findim)';
    case 4
        alpha=exp((-eta*noisepow)./singvals(1:findim));
        H=u(:,1:findim)*diag(sqrt(alpha(1:findim)))*u(:,1:findim)';
    otherwise
        error('Unsupported method specified');
    end
    
    % Project just the one point (Entire rps would be: "localrps = (localrps*H);" )
    newrps(:,i)=(rps(:,i)'*H)';
    rps_dist(:,i)=(rpsc(:,i)'*(H-eye(orgdim)))';
    rps_res(:,i)=(rpsn(:,i)'*H)';
    
end    

% Reconstruction process - either Hanning weighted or straight RPS columns

% Note: end points/weights are wrong, but center part is returned correctly

lagvec=[0; lagvec(:)];
if (wtflag)
    wtmat=repmat(hanning(orgdim),1,sigpts);     % Create weighting matrix
else
    midpt=floor((orgdim+1)/2);
    wtmat=zereos(orgdim,sigpts);
    wtmat(midpt,:)=ones(1,sigpts);
end
normvec=sum(wtmat);

sigmat=zeros(orgdim,sigpts);                % Create time-aligned rps matrix
for i=1:orgdim
    sigmat(i,:)=[zeros(1,(maxlag-lagvec(orgdim+1-i))) newrps(i,:) zeros(1,lagvec(orgdim+1-i))];
end

sigout=sum(sigmat.*wtmat)./normvec;         % Weighted average of rows gives final output
sigout=sigout(first:last);                  % Extract target segment from middle


if (orgflag)
    distmat=zeros(orgdim,sigpts);
    resmat=zeros(orgdim,sigpts);
    
    for i=1:orgdim                              % Time-align distortion rps rows
        distmat(i,:)=[zeros(1,(maxlag-lagvec(orgdim+1-i))) rps_dist(i,:) zeros(1,lagvec(orgdim+1-i))];
    end
    
    for i=1:orgdim                              % Time-align residual rps rows
        resmat(i,:)=[zeros(1,(maxlag-lagvec(orgdim+1-i))) rps_res(i,:) zeros(1,lagvec(orgdim+1-i))];
    end
    
    distsig=sum(distmat.*wtmat)./normvec;
    distsig=distsig(first:last);                  % Extract target segment from middle
    ressig=sum(resmat.*wtmat)./normvec;
    ressig=ressig(first:last);                    % Extract target segment from middle
    cleansig=cleansig(first:last);                % Extract corresponding clean signal
    dis=distsig;
    res=ressig;
    err=(cleansig-sigout);
else
    dis=nan; res=nan; sqerr=nan;
end