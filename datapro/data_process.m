clear all
test_flag = 0;
if test_flag == false
    filename = '..\data\01_24\0101_0124.dat';
else
    filename = 'E:\work\����wifi���������ʶ��\data\csi_mat\falling\falling_cdj_20140511_011.mat';
end    

pca_l = 3;   
dwt_low = 7;
dwt_up = 3;
[r, pca, h, T] = data_exchange(filename, pca_l, dwt_up, dwt_low, true, test_flag);   %r ��ɢС���������� Tʱ�䳤��

%[action_list, a_i] = waveform_slice(pca, T, true);%�����и�

%��Ƭ���з�ͶӰ����ɢС���任���
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