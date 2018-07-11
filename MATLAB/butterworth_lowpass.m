                                               % order_fc格式：阶数.截止频率  截止频率取值[0,1000)
function [ y ] = butterworth_lowpass( x, order_fc, fs )
    order = floor(order_fc);  % 阶数
    fc = mod(order_fc,1)*1000;  % 截止频率，转化为Hz
    [b, a] = butter(order,fc/(fs/2));  % 获得Butterworth滤波器参数
    y = filter(b, a, x);
end

