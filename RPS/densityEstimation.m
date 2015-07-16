function P = densityEstimation(temp1, N)

% P = densityEstimation(temp1, N)
%
% Input Variables
%	temp1 - the input feature matrix.
%	N - parameter for N-by-N box dividing of the feature space.
%
% Output Variables
%	P - matrix of Density distribution, N-by-N.
%
% Description
%	This code is to estimate the discrete density distribution of a feature matrix in its 
%   feature space.
%

% Created
%	Date:  5/7/03
%	By:    Xiaolin Liu
%	Marquette University
%
% Source
%	Written by Xiaolin Liu for use in phoneme classification by entropy distance.
%
% Modifications
%	Version: #.#
%	Date:
%	By:
%	Why:


size_temp1 = size(temp1);

x_min = min(temp1(:,1)); 
x_max = max(temp1(:,1));
y_min = min(temp1(:,2)); 
y_max = max(temp1(:,2)); 

x_interval = (x_max-x_min)/N;
y_interval = (y_max-y_min)/N;

[row_num, coloum_num] = size(temp1);

for i = 1:N
    
    if i == N
    [Ix,Jx] = find(temp1(:,1) >= (x_min+(i-1)*x_interval) & temp1(:,1) <= (x_min+i*x_interval));
    else
    [Ix,Jx] = find(temp1(:,1) >= (x_min+(i-1)*x_interval) & temp1(:,1) < (x_min+i*x_interval));
    end
    
    length_Ix = length(Ix);
    temp_y = temp1(:,2);
    clear py;
    
    if length_Ix ~= 0
        
        for k=1:length_Ix
            py(k) =  temp_y(Ix(k));
        end
        
        for j = 1:N
            if j==N
                [Iy,Jy] = find(py >= (y_min+(j-1)*y_interval) & py <= (y_min+j*y_interval));
            else
                [Iy,Jy] = find(py >= (y_min+(j-1)*y_interval) & py < (y_min+j*y_interval));
            end
            P(i,j)=length(Iy);
        end
        
    else
        P(i,:)=0;
    end
    
end

size_temp1;
sum_P = sum(sum(P));
P=P'/sum_P;
