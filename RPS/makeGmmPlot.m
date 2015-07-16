function makegmmPlot(dataM,kmix,markerColor,markerSize,lineColor,lineWidth)

% makegmmPlot(dataM,kmix,markerColor,markerSize,lineColor,lineWidth)
%
% Input Variables
%	      dataM - the points in the space, note each row contains one point
%	      kmix - number of GMM mixtures to learn
%	      markerColor - color of the points (optional)
%	      markerSize - size of the points (optional)
%	      lineColor - color of the lines used to show 1 std of mixtures (optional)
%	      lineWidth - width of the line used to show 1 std of mixtures (optional)
%
% Output Variables
%	      none
%
% Description
%	      Learns a GMM over the space defined by dataM. Plots the points and
%	      the 1std radius of the mixtues.
%
% Requirments:  Netlab Toolbox
%

% Created
%	      Date:  ?/?/?
%	      By:    ?
%	      Marquette University
% 
%
% Modifications
%	      Version: 2.0
%	      Date: 7/16/2003
%	      By: Richard J. Povinelli
%	      Why: Added more parameters to control the plotting, making the code
%	           more flexible


if nargin < 6, lineWidth = 2; end
if nargin < 5, lineColor = [0 0 0]; end
if nargin < 4, markerSize = 0.5; end
if nargin < 3, markerColor = [.5 .5 .5]; end

%kmix = 1;

mix = gmm(2, kmix, 'full');

% options(1) = -1;  % no error display
% options(14) = 25; % number of EM iterations
options(1) = -1;  % no error display
options(5) = 1;   % avoid covariance collapse
options(14) = 25; % number of EM iterations
options(19) = 1;  % floor on covariance matrix

mix = gmminit(mix, dataM, options);
mix = gmmem(mix, dataM, options);

%plot the phase space points
plot(dataM(:,1),dataM(:,2), '.', 'MarkerEdgeColor', markerColor,...
  'MarkerFaceColor', markerColor, 'MarkerSize', markerSize), hold on


for i = 1:kmix
  [v,d] = eig(mix.covars(:,:,i));
  for j = 1:2
    % Ensure that eigenvector has unit length
    v(:,j) = v(:,j)/norm(v(:,j));
    start=mix.centres(i,:)-sqrt(d(j,j))*(v(:,j)');
    endpt=mix.centres(i,:)+sqrt(d(j,j))*(v(:,j)');
    linex = [start(1) endpt(1)];
    liney = [start(2) endpt(2)];
    line(linex, liney, 'Color', lineColor, 'LineWidth', lineWidth)
  end
  % Plot ellipses of one standard deviation
  theta = 0:0.02:2*pi;
  x = sqrt(d(1,1))*cos(theta);
  y = sqrt(d(2,2))*sin(theta);
  % Rotate ellipse axes
  ellipse = (v*([x; y]))';
  % Adjust centre
  ellipse = ellipse + ones(length(theta), 1)*mix.centres(i,:);
  plot(ellipse(:,1), ellipse(:,2), 'k-', 'LineWidth', lineWidth);
end


%figure
%hold off
% Plot the result
%minX = min(dataM(:,1));
%minY = min(dataM(:,2));
%maxX = max(dataM(:,1));
%maxY = max(dataM(:,2));
%x = minX:(maxX-minX)/100:maxX;
%y = minY:(maxY-minY)/100:maxY;
%[X, Y] = meshgrid(x,y);
%X = X(:);
%Y = Y(:);
%grid = [X Y];
%Z = gmmprob(mix, grid);
%Z = reshape(Z, length(x), length(y));
%c = mesh(x, y, Z);
%figure
%colormap(gray);
%c = pcolor(x, y, abs(Z - 1));
%set(c,'LineStyle','none');

drawnow

