function pca = PCA(h,m)   %hԭʼ���� m���صڼ���?
     [v,~] = eig(h*h.');
     pca = h.'*v(:,size(v,2)-m+1);
end 