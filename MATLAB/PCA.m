function pca = PCA(h,m)   %h原始数据 m返回第几层?
     [v,~] = eig(h*h.');
     pca = h.'*v(:,size(v,2)-m+1);
end 