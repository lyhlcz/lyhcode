function [ y ] = filter_bw( x, order, fc, fs )
    [b, a] = butter(order,fc/(fs/2));  % 获得Butterworth滤波器参数
    y = filter(b, a, x);
end

