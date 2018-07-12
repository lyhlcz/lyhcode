clear 
addpath 'api'

draw_flag = 1;      %�Ƿ��ͼ
data_flag = 'm';    %�����ļ�����
test_flag = 1;      %�Ƿ�Ϊ����
db4_flag = 0;       %�Ƿ������ɢС������

if test_flag == true
    if data_flag == 'm'
        filename = '..\..\data\csi_mat\falling\\falling_cdj_20140511_011.mat';
    end
    if data_flag == 'd'
        filename = '..\..\data\01_24\0101_0124.dat';
    end
    files = {filename};
else
    datapath = '..\..\data\csi_mat\falling\';
    files = getallfiles(datapath);
end 

N = size(files,1);  %�ļ�����
for i = 1:N
    %��ȡcsi����
    [csi, tm] = loadData(files{i}, data_flag);
    
    %PCA����
    pcl = 10; 
    pca = filter_pca(csi, pcl);
       
    %db4����
    if db4_flag == true  
        for j = 1:pcl
        
        end
    end
    
    %���Ʋ���
    T = size(tm, 1);
    if draw_flag == true
        %����PCA���
        for j = 1:pcl
            figure(j)
            plot(pca(1:T,j));
            %����db4���
            
        end
    end
end
    
