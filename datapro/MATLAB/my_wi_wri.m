function my_wi_wri(file_path)
RES_LEN=100000;
%% 打开文件
f = fopen(file_path, 'rb');
if (f < 0)
    error('Couldn''t open file %s', filename);
    return;
end
%% 初始化
ret = cell(ceil(RES_LEN),1);
broken_perm = 0;                % Flag marking whether we've encountered a broken CSI yet
triangle = [1 3 6];             % What perm should sum to for 1,2,3 antennas
count=0;
while count<RES_LEN-100

%% 读取大小
 read_pos=0;
 read_pos=ftell(f);
 while (1)
  status = fseek(f, read_pos, 'bof');
    if status ~= 0
        [msg, errno] = ferror(f);
        error('Error %d seeking: %s', errno, msg);
        fclose(f);
        return;
    end  
  [field_len,r_len] = fread(f, 1, 'uint16', 0, 'ieee-be');
  if r_len==1
      break;
  end
 end

 %% 读取code
  read_pos=ftell(f);
 while 1
  status = fseek(f, read_pos, 'bof');
    if status ~= 0
        [msg, errno] = ferror(f);
        error('Error %d seeking: %s', errno, msg);
        fclose(f);
        return;
    end  
  [code,r_len] = fread(f, 1);
  if r_len==1
      break;
  end
 end
 
 %% 读取数据内容
  if (code == 187) % get beamforming or phy data
        read_pos=ftell(f);
         while 1
          status = fseek(f, read_pos, 'bof');
            if status ~= 0
                [msg, errno] = ferror(f);
                error('Error %d seeking: %s', errno, msg);
                fclose(f);
                return;
            end  
         [bytes,r_len] = fread(f, field_len-1, 'uint8=>uint8');
          if r_len==field_len-1
              break;
          end
         end
      
    else % skip all other info
        read_pos=ftell(f);
         while 1
          status = fseek(f, read_pos, 'bof');
            if status ~= 0
                [msg, errno] = ferror(f);
                error('Error %d seeking: %s', errno, msg);
                fclose(f);
                return;
            end  
         [ig_data,r_len] = fread(f, field_len - 1);
          if r_len==field_len-1
              break;
          end
         end        
        %continue;
  end
 %% 数据处理
    if (code == 187) %hex2dec('bb')) Beamforming matrix -- output a record
        count = count + 1;
        ret{count} = read_bfee(bytes);
        
        perm = ret{count}.perm;
        Nrx = ret{count}.Nrx;
        if Nrx == 1 % No permuting needed for only 1 antenna
            continue;
        end
        if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
            if broken_perm == 0
                broken_perm = 1;
                fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', file_path, Nrx, int2str(perm));
            end
        else
            ret{count}.csi(:,perm(1:Nrx),:) = ret{count}.csi(:,1:Nrx,:);
        end
    end
     
end    
 
for i=1:1500:count-30000
 my_mad(ret(i:i+30000));
end

fclose(f);

end