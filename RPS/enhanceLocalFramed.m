function [sigout, err, dis, res] = enhanceLocalFramed(sigin, cleansig, halfwin, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
% function [sigout, err, dis, res] = enhanceLocalFramed(sigin, cleansig, halfwin, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag)
%
% Input Variables
%       sigin  - input signal
%       cleansig - clean input signal for computing errors: dis, res, sqerr
%                  if empty [] then those outputs will be returned as NaN
%       halfwin- halfwin length of frame window to use (default = 128)
%                OLA window will be hann(2*(halfwin)+1) w/ stepsize=halfwin
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
% Description:  Uses "double-windowing" local projection on each frame to enhance RPS
%               with optional automatic order selection (final projection dim)
%               Then uses hanning-weighted OLA to reconstruct entire signal
%               See "EnhanceLocal.m" & "EnhanceLocalPartial" for more details on method
%
% Requirments:  Signal Processing Toolbox
%

% Created:     
%               Date: 9/30/2003
%               By:  Mike Johnson
%               Marquette University
%
% Modified:     5/20/04 MTJ  Added
%                    -dis, res, sqerr outputs (from enhanceglobal)
%                    -lagvector option (from enhanceglobal)
%                    -single column option (from enhanceglobal)
%                    -Eliminated call to EnhanceLocalPartial
%                    (tired of maintaining nearly duplicate code)
%                    Note that sqerr, dis, and res are now not exact, since
%                    only part of the frame they are computed over is
%                    actually used. (negligible difference)
%               5/24/04 MTJ Changed order 1st two elements (& in subcalls)
%               6/2/04 MTJ Changed error outputs to signals

if nargin < 1
    error('Neet at least an input signal');
end
if nargin < 2
    cleansig=[];
end
if nargin < 3
    halfwin=128;
end
if nargin < 4
    neighbors = 15;
end
if nargin < 5
    exclude=3;
end
if nargin < 6
    lag=1;
end
if nargin < 7
    orgdim=15;
end
if nargin < 8
    dimflag=0;
end
if ((nargin <9) & ~dimflag)
    dimvar=5;
end
if ((nargin < 9) & dimflag)
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
if nargin < 10
    method=1;
end
if (method==3)
    if (nargin < 11)
        constraints=0.5;
    end
elseif (method==4)
    if (nargin < 11)
        constraints=0.5;
    end
else
    constraints=[];
end
if (nargin < 10)
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

if ((length(cleansig) ~= length(sigin)) & (length(cleansig)>0))
    error('Signal and reference must be same length');
end

sigin=sigin(:)';

oflag=1;
if (length(cleansig)<1)
    oflag=0;
    cframe=[];
end

% Window selection hard-coded; could be changed here
% (much more work if not 1/2 overlap & odd hanning windows)
win=hann(2*halfwin+1)';
framesize=2*halfwin+1;
stepsize=halfwin;
overlap=framesize-stepsize;

% Split into frames, enhance each, mult. by window
sigsize=length(sigin);
numframes=ceil((sigsize-overlap)/stepsize);
sigout=zeros(1,sigsize); err=zeros(1,sigsize); dis=zeros(1,sigsize); res=zeros(1,sigsize);

if (sigsize<3*framesize)
    error('Need at least 3 full frames to use this routine. Try "enhanceLocal.m" instead.');
end

% First frame special case
i=1;
lrgframe=sigin(1:ceil(1.5*framesize));
if (oflag) cframe=cleansig(1:ceil(1.5*framesize)); end
[enhsig ferr fdis fres]=enhanceLocal(lrgframe,cframe,neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints,wtflag);
sigout(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=sigout(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) ...
   +[ones(1,stepsize) win((stepsize+1):end)].*enhsig(1:framesize);
err(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=err(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) ...
   +[ones(1,stepsize) win((stepsize+1):end)].*ferr(1:framesize);
dis(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=dis(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) ...
   +[ones(1,stepsize) win((stepsize+1):end)].*fdis(1:framesize);
res(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=res(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) ...
   +[ones(1,stepsize) win((stepsize+1):end)].*fres(1:framesize);

% Normal middle frames
for i=2:(numframes-2)
    dblframe=sigin(((i-2)*stepsize+1):(i*stepsize+framesize));
    if (oflag) cframe=cleansig(((i-2)*stepsize+1):(i*stepsize+framesize)); end
    % OBSOLETE [enhsig ferr fdis fres]=enhanceLocalPartial(dblframe, cframe, stepsize+1,stepsize+framesize, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag);
    % Note: this prev. method is 10-20% faster and returns more precise error values, but was replaced to simplify code maintenance (enhancement is the same)
    [enhsig ferr fdis fres]=enhanceLocal(dblframe, cframe, neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints, wtflag);
    enhsig=enhsig((stepsize+1):(stepsize+framesize));  % segment out desired center portion
    ferr=ferr((stepsize+1):(stepsize+framesize));
    fdis=fdis((stepsize+1):(stepsize+framesize));
    fres=fres((stepsize+1):(stepsize+framesize));
    sigout(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=sigout(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) + win.*enhsig;
    err(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=err(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) + win.*ferr;
    dis(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=dis(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) + win.*fdis;
    res(((i-1)*stepsize+1):((i-1)*stepsize+framesize))=res(((i-1)*stepsize+1):((i-1)*stepsize+framesize)) + win.*fres;
end

% Last two frames (one full, one cut) special case
i=numframes;
lrgframe=sigin(((i-3)*stepsize+1):end);
if (oflag) cframe=cleansig(((i-3)*stepsize+1):end); end
[enhsig ferr fdis fres]=enhanceLocal(lrgframe,cframe,neighbors, exclude, lag, orgdim, dimflag, dimvar, method, constraints,wtflag);
% 2nd to last frame
sigout(((i-2)*stepsize+1):((i-2)*stepsize+framesize))=sigout(((i-2)*stepsize+1):((i-2)*stepsize+framesize)) + win.*enhsig(stepsize+1:stepsize+framesize);
err(((i-2)*stepsize+1):((i-2)*stepsize+framesize))=err(((i-2)*stepsize+1):((i-2)*stepsize+framesize)) + win.*ferr(stepsize+1:stepsize+framesize);
dis(((i-2)*stepsize+1):((i-2)*stepsize+framesize))=dis(((i-2)*stepsize+1):((i-2)*stepsize+framesize)) + win.*fdis(stepsize+1:stepsize+framesize);
res(((i-2)*stepsize+1):((i-2)*stepsize+framesize))=res(((i-2)*stepsize+1):((i-2)*stepsize+framesize)) + win.*fres(stepsize+1:stepsize+framesize);
% last frame
frlen=sigsize-(i-1)*stepsize;
if (frlen>stepsize)
    sigout(((i-1)*stepsize+1):end)=sigout(((i-1)*stepsize+1):end)+[win(1:stepsize) ones(1,frlen-stepsize)].*enhsig(end-frlen+1:end);
    err(((i-1)*stepsize+1):end)=err(((i-1)*stepsize+1):end)+[win(1:stepsize) ones(1,frlen-stepsize)].*ferr(end-frlen+1:end);
    dis(((i-1)*stepsize+1):end)=dis(((i-1)*stepsize+1):end)+[win(1:stepsize) ones(1,frlen-stepsize)].*fdis(end-frlen+1:end);
    res(((i-1)*stepsize+1):end)=res(((i-1)*stepsize+1):end)+[win(1:stepsize) ones(1,frlen-stepsize)].*fres(end-frlen+1:end);
else % Technically not possible the way we assigned frames
    sigout(((i-1)*stepsize+1):end)=sigout(((i-1)*stepsize+1):end)+win(1:frlen).*enhsig(end-frlen+1:end);
    err(((i-1)*stepsize+1):end)=err(((i-1)*stepsize+1):end)+win(1:frlen).*ferr(end-frlen+1:end);
    dis(((i-1)*stepsize+1):end)=dis(((i-1)*stepsize+1):end)+win(1:frlen).*fdis(end-frlen+1:end);
    res(((i-1)*stepsize+1):end)=res(((i-1)*stepsize+1):end)+win(1:frlen).*fres(end-frlen+1:end);
end