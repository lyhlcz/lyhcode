                                               % order_fc��ʽ������.��ֹƵ��  ��ֹƵ��ȡֵ[0,1000)
function [ y ] = butterworth_lowpass( x, order_fc, fs )
    order = floor(order_fc);  % ����
    fc = mod(order_fc,1)*1000;  % ��ֹƵ�ʣ�ת��ΪHz
    [b, a] = butter(order,fc/(fs/2));  % ���Butterworth�˲�������
    y = filter(b, a, x);
end

