function [ F ] = getFeature( csi, tm, draw_flag, db4_flag )
%GETFEATURE 
%   input:  csi, timestamps
%   output: feature
    pcl = 10;
    fs = 2500;
    T = size(tm, 1);
    
    %   PCA
    pca = filter_pca(csi, pcl);

    %   draw PCA
    if draw_flag == true
        for j = 1:pcl
            figure(j)
            plot(pca(1:T,j));      
        end
    end   
    
    %   db4
    if db4_flag == true  
        sum = 0;
        for j = 1:pcl
            temp = interp1(tm,pca(:,j),(tm(1):1/fs:tm(end)),'linear');
            temp = temp(21:end); % remove bad data introduced by PCA filter
            sum = sum + carm_feature(temp); 
        end
        F = sum/pcl;
        return;
    end   
    F = pca;
end

