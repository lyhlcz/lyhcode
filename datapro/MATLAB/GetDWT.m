function [cA,cD] = GetDWT(data,limit,type)  
%data 原始数据 limit 最大层数（不填默认10） type 变换类型（不填默认db4）
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