%function

%[h,data_info] = GetCsiData(FILENAME,skip_f,skip_t)
%h bw滤波后的数据 skip_f 前面跳过的百分比 skip_t后续跳过的百分比

%pca = PCA(h,m)   
%h原始数据 m返回第几层?

%[cA,cD] = GetDWT(data,limit,type)  
%data 原始数据 limit 最大层数（不填默认10） type 变换类型（不填默认db4）

%r = GetDWT2(data,limit,up,low,type)
%data 原始数据 limit 最大层数（不填默认10）up low 返回的层数范围（不填默认3~6层） type 变换类型（不填默认db4）

function [r, pca, h, T] = data_exchange(filename, pca_l, dwt_up, dwt_low, draw_flag, test_flag)
    addpath .\MATLAB

    %bw滤波处理
    if test_flag == false
        h = GetCsiData(filename);
    else
        load(filename);
        rssidata = rssidata(:,2:181);
        h = real(csi');
    end
    T = size(h, 2);
    
%     figure(1)
%     n = 3;
%     for i = 1 : n
%         subplot(n, 1, i);
%         plot(h(i, 1:T))
%     end
    
    %pca降噪
    pca = PCA(h, pca_l);

    %离散小波变换处理
    r = GetDWT2(pca, 10, dwt_up, dwt_low);
    
    if draw_flag == true
        %绘制bw处理结果
        figure(1)
        n = 3;
        for i = 1 : n
            subplot(n, 1, i);
            plot(h(i, 1:T))
        end
        %绘制pca处理结果
        figure(2)
        plot(pca(1:6000));
        xlabel('Time');
        ylabel('Amplitude');
%         %绘制离散小波处理结果
%         figure(3)
%         for i = dwt_up : dwt_low
%             subplot(dwt_low-dwt_up+1, 1, i-dwt_up+1);
%             s = (i-dwt_up)*T;
%             plot(r(s+1:s+T))
%         end
    end
end

