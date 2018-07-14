clear 
addpath 'api'

draw_flag = 1;      %�Ƿ��ͼ
data_flag = 'm';    %�����ļ�����
test_flag = 1;      %�Ƿ�Ϊ����
db4_flag = 0;       %�Ƿ������ɢС������

if test_flag == true
    if data_flag == 'm'
        filename = '..\..\data\csi_mat\falling\falling_cdj_20140511_011.mat';
    end
    if data_flag == 'd'
        filename = '..\..\data\01_24\0101_0124.dat';
    end
    files = {filename};
else
    datapath = '..\..\data\csi_mat\falling\';
    files = getallfiles(datapath);
end 

N = size(files,1);  %   number of files
F = cell([N 1]);
for i = 1:N
    %   get csi and tm
    [csi, tm] = loadData(files{i}, data_flag);
    
    %   get feature
    F{i} = getFeature(csi, tm, draw_flag, db4_flag);
end
    
