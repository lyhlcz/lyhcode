function [ y ] = filter_bw( x, order, fc, fs )
    [b, a] = butter(order,fc/(fs/2));  % ���Butterworth�˲�������
    y = filter(b, a, x);
end

