function [h,data_info] = GetCsiData(FILENAME,skip_f,skip_t)
%h bw滤波后的数据 skip_f 前面跳过的百分比 skip_t后续跳过的百分比
     if nargin == 1
         skip_f = 0;
         skip_t = 1;
     end;
     csi_trace = read_bf_file(FILENAME);
     t1 = csi_trace{1}.timestamp_low;  % 单位：微秒
     tn = csi_trace{size(csi_trace,1)}.timestamp_low;
     time = tn - t1;
     fs = size(csi_trace,1) / (time/1e6);
     csi_struct = [csi_trace{:}];
     clear csi_trace;
     maxTx = max([csi_struct(:).Ntx]);
     maxRx = max([csi_struct(:).Nrx]);

     time_length=size(csi_struct,2);

     time_be = int32(skip_f*time_length);
     if time_be == 0
         time_be = 1;
     end
     time_en = int32(skip_t*time_length); 
     bad_data_cnt = 0;
     for i = time_be : time_en
         if(csi_struct(i).Ntx<maxTx || csi_struct(i).Nrx<maxRx)
            bad_data_cnt = bad_data_cnt+1;
         end
     end
     sample_count = time_en-time_be+1 - bad_data_cnt;     
     data = zeros(maxTx,maxRx,sample_count,30);
     bad_data_cnt = 0;
     for i = time_be : time_en
         csi_entry = csi_struct(i).csi;
         %csi = get_scaled_csi(csi_entry);
         if(csi_struct(i).Ntx<maxTx || csi_struct(i).Nrx<maxRx)
            bad_data_cnt = bad_data_cnt+1;
         else
             for j = 1 : maxTx
                 for k = 1 : maxRx  
                      data(j,k,i-time_be+1-bad_data_cnt,:)=abs(csi_entry(j,k,:));
                 end
             end
         end
     end
     %profile viewer
    %% Filter
     % butterworth_lowpass
     data_sample= zeros(sample_count,180);  
     data_BW_tmp= zeros(sample_count,30); 
     for Tx_i = 1:maxTx
         for Rx_i = 1:maxRx
             for i = 1:30                  
                data_BW_tmp(:,:)=data(Tx_i,Rx_i,:,:);
                temp = butterworth_lowpass(data_BW_tmp(:,i),6.05,fs); 
                data_sample(:,((Tx_i-1)*maxRx+Rx_i-1)*30+i)= temp;
             end
         end
     end
     data_info.maxTx=maxTx;
     data_info.maxRx=maxRx;
     data_info.bad_data_cnt = bad_data_cnt;
     data_info.fs = fs;
     data_info.time=time*(skip_t-skip_f);
     h=data_sample';
end