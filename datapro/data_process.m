clear 
addpath 'api'

draw_flag = 1;      %是否绘图
data_flag = 'm';    %数据文件类型
test_flag = 1;      %是否为测试
db4_flag = 0;       %是否进行离散小波处理

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

N = size(files,1);  %文件个数
for i = 1:N
    %获取csi数据
    [csi, tm] = loadData(files{i}, data_flag);
    
    %PCA处理
    pcl = 10; 
    pca = filter_pca(csi, pcl);
       
    %db4处理
    if db4_flag == true  
        for j = 1:pcl
        
        end
    end
    
    %绘制波形
    T = size(tm, 1);
    if draw_flag == true
        %绘制PCA结果
        for j = 1:pcl
            figure(j)
            plot(pca(1:T,j));
            %绘制db4结果
            
        end
    end
end
    
