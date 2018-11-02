function [ csi, tm ] = loadData( file, data_flag )
%LOADDATA load data
%   csi: csi data
%   tm: timstamps
%   data_flag:  
%       d   .dat file 
%       m   .mat file
    if data_flag == 'm'
        load(file);
        tm = rssidata(:,1); % get timestamps
        csi = abs(rssidata(:,2:181));   % get amp of csi
        return
    end
    
    if data_flag == 'd'
        % load csi_trace
        addpath './MATLAB'
        csi_trace = read_bf_file(file);
        
        % get Ntx, Nrx and timestamps
        [T,R,tm] = cellfun(@get_info,csi_trace); 

        % normalize timestamps and convert ms to s
        tm = (tm-tm(1))*1e-6;

        % remove bad samples whose Ntx or Nrx is incorrect
        bad = (T~=mode(T)) | (R~=mode(R));
        tm(bad) = []; csi_trace(bad) = [];

        % get csi matrix
        T = csi_trace{1}.Ntx;
        R = csi_trace{1}.Nrx;
        csi = zeros([size(csi_trace,1),T*R*30]); % N*180
        for i = 1:size(csi_trace,1)
            % reshape csi(:,:,:) to a row_vector
            % use permute to 'transpose' csi to make same tx/rx pair together
            csi(i,:) = reshape(permute(csi_trace{i}.csi,[3 2 1]),[1 T*R*30]);
        end

        % get amp of csi
        csi = abs(csi);
    end

end

function [T,R,tm] = get_info(csi_trace)
    T = csi_trace.Ntx;
    R = csi_trace.Nrx;
    tm = csi_trace.timestamp_low;
end
