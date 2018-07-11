function  my_mad(csi_trace)
csi = zeros(size(csi_trace));
csi2 = zeros(size(csi_trace));
for i = 1:size(csi_trace,1)
    csi(i)=abs(csi_trace{i}.csi(1,1,2));
end

L=200;
for i = L+1:size(csi)-L
    csi2(i)=mean(csi(i-L:i+L));
end
sub1=0;
for i =1:L
    sub1=sub1+i;
end
for i = L+1:size(csi)
    sub2=0;
    for j=1:L
        sub2=sub2+j*csi(i-L+j);
    end
    csi2(i)=sub2/sub1;
end
csi4=csi2(L+1:size(csi));
% plot(csi4);

s=csi4;
[ca1,cd1]=dwt(s,'db3');
[ca2,cd2]=dwt(ca1,'db3');
[ca3,cd3]=dwt(ca2,'db3');
[ca4,cd4]=dwt(ca3,'db3');
[ca5,cd5]=dwt(ca4,'db3');
 [ca6,cd6]=dwt(ca5,'db3');
% [ca7,cd7]=dwt(ca6,'db3');
plot(ca6);

drawnow;
%res=my_dtw(ca6(850:950),ca6(1150:1300));
end
