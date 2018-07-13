clear 
addpath 'api'

draw_flag = 0;      %是否绘图
data_flag = 'm';    %数据文件类型
test_flag = 1;      %是否为测试
db4_flag = 1;       %是否进行离散小波处理

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

N = size(files,1);  %文件个数
F = cell([N 1]);
pcl = 10;
fs = 2500;
for i = 1:N
    %获取csi数据
    [csi, tm] = loadData(files{i}, data_flag);
    T = size(tm, 1);
    
    %PCA处理
    pca = filter_pca(csi, pcl);

    %绘制PCA结果
    if draw_flag == true
        for j = 1:pcl
            figure(j)
            plot(pca(1:T,j));      
        end
    end   
    
    %db4处理
    if db4_flag == true  
        sum = 0;
        for j = 1:pcl
            temp = interp1(tm,pca(:,j),(tm(1):1/fs:tm(end)),'linear');
            temp = temp(21:end); % remove bad data introduced by PCA filter
            sum = sum + carm_feature(temp); 
        end
        F{i} = sum/pcl;
    end   
end
    
