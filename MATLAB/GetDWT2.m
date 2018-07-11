function r = GetDWT2(data,limit,up,low,type)
%data ԭʼ���� limit ������������Ĭ��10��up low ���صĲ�����Χ������Ĭ��3~6�㣩 type �任���ͣ�����Ĭ��db4��
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