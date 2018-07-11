function f = judge_statu(x)
    threshold = 10;
%     std(x)
    if std(x) > threshold
        f = true;
    else f = false;
    end
end