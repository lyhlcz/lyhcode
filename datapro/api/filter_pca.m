function [ y] = filter_pca( x, order )
%FILTER_PCA Summary of this function goes here
%   Detailed explanation goes here
    % input : x - csi matrix (N*180)
    % output: y - filtered csi matrix (N * order)
    
    %plot(x(:,1),'b');  
    for i =1:size(x,2)
        % use a 2-order butterworth filter to denoise roughly
        x(:,i) = filter_bw(x(:,i),2,200,2500); 
    end
    
    %hold on
    %plot(x(:,1)+5,'r');
    %hold off    
    
    % use PCA to denoise
    [v,~] = eig(x.'*x);
    y = x*v(:,end-1:-1:end-order);


end

