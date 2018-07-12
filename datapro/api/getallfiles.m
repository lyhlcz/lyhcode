function [ file ] = getallfiles( path )
%GETALLFILES Summary of this function goes here
%   Detailed explanation goes here
    % input : path - a directory ended with '/'
    % output: file - a cell containing all filenames in dir
    
    f = dir(fullfile(path));
    j = 0;
    for i = 1:length(f)
        if(f(i).isdir==false)
            j = j+1;
            f(j) = f(i);
        end
    end
    f = f(1:j);
    
    file = cell([length(f) 1]);
    for i = 1:length(f)
        file{i} = [path f(i).name];
    end
end

