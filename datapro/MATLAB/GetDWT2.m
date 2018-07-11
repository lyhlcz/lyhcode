function r = GetDWT2(data,limit,up,low,type)
%data 原始数据 limit 最大层数（不填默认10）up low 返回的层数范围（不填默认3~6层） type 变换类型（不填默认db4）
    if nargin < 5
        type='db4';
        if nargin < 4
            limit = 10;
            up = 3;
            low = 6;
        end
    end 
    [c,l] =wavedec(data,limit,type);
    r = [];
    for i = up:low
        temp = wrcoef('d',c,l,type,i); % column vector
        r = [r temp];
    end
   % r = r.^2;
end