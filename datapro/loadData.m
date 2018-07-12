function [ csi, tm ] = loadData( file, data_flag )
%LOADDATA 读取数据
%   csi: csi数据
%   tm: 时间标签
%   data_flag: 指示数据文件类型 
%       d   .dat文件  
%       m   .mat文件
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

