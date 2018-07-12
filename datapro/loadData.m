function [ csi, tm ] = loadData( file, data_flag )
%LOADDATA ��ȡ����
%   csi: csi����
%   tm: ʱ���ǩ
%   data_flag: ָʾ�����ļ����� 
%       d   .dat�ļ�  
%       m   .mat�ļ�
    if data_flag == 'm'
        load(file);
        tm = rssidata(:,1);
        csi = abs(rssidata(:,2:181));
        return
    end
    
    if data_flag == 'd'
        addpath './MATLAB'
        [csi, datainfo] = GetCsiData(file);
        csi = csi';
        tm = datainfo;
    end

end

