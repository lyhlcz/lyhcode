clear all
test_flag = 0;
if test_flag == false
    filename = '..\data\01_24\0101_0124.dat';
else
    filename = 'E:\work\基于wifi的室内身份识别\data\csi_mat\falling\falling_cdj_20140511_011.mat';
end    

pca_l = 3;   
dwt_low = 7;
dwt_up = 3;
[r, pca, h, T] = data_exchange(filename, pca_l, dwt_up, dwt_low, true, test_flag);   %r 离散小波处理结果， T时间长度

%[action_list, a_i] = waveform_slice(pca, T, true);%波形切割

%将片段切分投影到离散小波变换结果
% figure(5)
% for i = dwt_up : dwt_low
%     subplot(dwt_low-dwt_up+1, 1, i-dwt_up+1);
%     s = (i-dwt_up)*T;
%     plot(r(s+1:s+T), 'b')
%     flag = true;
%     for j = 1 : a_i
%         hold on
%         if flag
%             plot([action_list(j), action_list(j)], [-100, 100], 'r')
%         else 
%             plot([action_list(j), action_list(j)], [-100, 100], 'k')
%         end
%         flag = ~flag;
%     end
% end