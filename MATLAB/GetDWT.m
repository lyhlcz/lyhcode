function [cA,cD] = GetDWT(data,limit,type)  
%data ԭʼ���� limit ������������Ĭ��10�� type �任���ͣ�����Ĭ��db4��
    if nargin < 3
        type='db4';
        if nargin < 2
            limit = 10;
        end
    end 
    cAi=data;
    for i = 1:limit
        [cAi,cDi]=dwt(cAi,type);
        cA{i}=cAi;
        cD{i}=cDi;
    end
end