c='rgyb';

csi = zeros(size(csi_trace));
csi2 = zeros(size(csi_trace));
for i = 1:size(csi_trace,1)
    csi(i)=abs(csi_trace{i}.csi(1,1,10));
end

L=100;
for i = L+1:size(csi)-L
    csi2(i)=mean(csi(i-L:i+L));
end


plot(csi2,c(idx));
idx=idx+1;
if(idx>4)
    idx=1;
end