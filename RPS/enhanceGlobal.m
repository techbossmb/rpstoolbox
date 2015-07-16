function [sigout, err, dis, res] = enhanceGlobal(sigin, cleansig, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
% function [sigout, err, dis, res] = enhanceGlobal(sigin, cleansig, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
%
% Input Variables
%       sigin -  input signal (same length)
%       cleansig - clean input signal for computing errors: dis, res, sqerr
%                  if empty [] then those outputs will be returned as NaN
%       lag -    base lag value OR full lag vector for RPS (default=1)
%                if using vector, must be size orgdim-1 (lag 0 is implied 1st dim)
%       orgdim - starting RPS dimension (default=15)
%       dimflag- 0 = fixed final dim, 1 = auto dim selection (default=0)
%       dimvar - if (dimflag=0): projected RPS dimension, must be < orgdim (default=5)
%                if (dimflag=1): threshold for order/finaldim selection (default=0.5)
%                Typical range [0.1-1]: Results ARE sensitive to this value 
%       method - type of projection: (default=1)
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
% Description:  Uses global projection to enhance RPS
%               with optional automatic order selection - Merhav et al. method
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
%                    dis, res, sqerr outputs (from enhanceglobal_alt)
%                    lagvector option (from enhanceglobal_alt3)
%                    single column option (from enhanceglobal_alt2)
%               5/24/04 MTJ Changed order 1st two elements
%               6/2/04 MTJ Changed error outputs to signals

if nargin < 1
    error('Neet at least an input signal');
end
if nargin < 2
    cleansig=[];
end
if nargin < 3
    lag=1;
end
if nargin < 4
    orgdim=15;
end
if nargin < 5
    dimflag=0;
end
if ((nargin <6) & ~dimflag)
    dimvar=5;
end
if ((nargin < 6) & dimflag)
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
if nargin < 7
    method=1;
end
if (method==3)
    if (nargin < 8)
        constraints=0.5;
    end
    mu=constraints;
end
if (method==4)
    if (nargin < 8)
        constraints=0.5;
    end
    eta=constraints;
end
if (nargin < 9)
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
    cleansigLength = length(cleansig)
    siginLength = length(sigin)
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

% Embed, create scatter matrix, take SVD

rps=embed(sigin,lagvec); % rps is d x N
scat=rps*rps';
[u s v]=svd(scat);  % Columns of V (=U) are eigenvectors of covariance matrix of rps
singvals=diag(s);   % Eigenvalues of covariance matrix

% Determine projection dimension based on eigenvalues
% Max dimension is (orgdim-1) - better noise power estimate
if (dimflag)
    mindim=1; maxdim=orgdim-1;   % optional: hard-coded limits on automatic order selection
    if orgdim<2  % just in case - don't bother doing anything
        findim=orgdim;
        noisepow=0;
    else
        for i=1:orgdim   % average of i lowest eigenvalues
            sigmasq(i)=sum(singvals(i:orgdim))/(orgdim-i+1);
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

% Projection
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

newrps=(rps'*H)';                % <=== Projected rps
if (orgflag)
    rps_dist=(rpsc'*(H-eye(orgdim)))';
    rps_res=(rpsn'*H)';
end

% Reconstruction process - either Hanning weighted or straight RPS columns

if (wtflag)
    wtmat=repmat(hanning(orgdim),1,sigpts);     % Create hanning weighting matrix
    maxlag=max(lagvec);
    lagvec=[0; lagvec(:)];
    for i=1:(orgdim-1)
        st=maxlag-lagvec(orgdim-i+1)+1;
        en=maxlag-lagvec(orgdim-i);
        tot=en-st+1;
        wtmat(:,st:en)=repmat([hanning(i); zeros(orgdim-i,1)],1,tot);
    end
    wtmat(:,(end-maxlag+1):end)=flipud(fliplr(wtmat(:,1:maxlag)));
else                                             % Create binary weighting matrix
    midpt=floor((orgdim+1)/2);
    wtmat=zeros(orgdim,sigpts);
    maxlag=max(lagvec);
    lagvec=[0; lagvec(:)];
    for i=1:(orgdim-1)
        numcols=lagvec(orgdim+1-i)-lagvec(orgdim-i);
        if (i<midpt)
            st(i)=maxlag-lagvec(orgdim-i+1)+1;
            en(i)=maxlag-lagvec(orgdim-i);
            wtmat(i,st(i):en(i))=ones(1,numcols);
        else
            st(i)=sigpts-lagvec(orgdim-i+1)+1;
            en(i)=sigpts-lagvec(orgdim-i);
            wtmat(i+1,st(i):en(i))=ones(1,numcols);
        end
    end    
    wtmat(midpt,(en(midpt-1)+1):(st(midpt)-1))=ones(1,st(midpt)-en(midpt-1)-1);
end

normvec=sum(wtmat);

sigmat=zeros(orgdim,sigpts);                % Create time-aligned rps matrix
for i=1:orgdim
    sigmat(i,:)=[zeros(1,(maxlag-lagvec(orgdim+1-i))) newrps(i,:) zeros(1,lagvec(orgdim+1-i))];
end

sigout=sum(sigmat.*wtmat)./normvec;         % Weighted average of rows gives final output

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
    ressig=sum(resmat.*wtmat)./normvec;    
    dis=distsig;
    res=ressig;
    err=(cleansig-sigout);
else
    dis=nan; res=nan; sqerr=nan;
end