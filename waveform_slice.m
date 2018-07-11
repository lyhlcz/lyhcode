function [ action_list, a_i] = waveform_slice(pca, T, flag)
%WAVEFORM_SLICE 波形切片
%   T 时间长度
    win_size = 120;
    t_cur = 1;
    statu = 0;
%     statu_last = 0;
%     statu_cur = 0;
    action_list(1, floor(T/win_size)) = 0;
    a_i = 0;
    
    while t_cur+win_size-1 <= T
%         statu_last = statu_cur;
%         statu_cur = judge_statu(pca(t_cur: t_cur+win_size-1));
        
%         if statu_last == statu_cur
%             a_i = a_i + 1;
%             action_list(a_i) = t_cur;
%         end
%             
%         t_cur = t_cur + win_size;
        if judge_statu(pca(t_cur: t_cur+win_size-1))
            if statu == 0
                t_sta = t_cur;
            end
            statu = statu + 1;
        else if statu > 0
                t_cur = t_cur + win_size;
                if t_cur+win_size-1 > T
                    break
                end
                if judge_statu(pca(t_cur: t_cur+win_size-1))
                    t_cur = t_cur + win_size;
                    if t_cur+win_size-1 > T
                        break
                    end            
                    if judge_statu(pca(t_cur: t_cur+win_size-1))
                        s = 2;
                    else
                        t_cur = t_cur + win_size;
                        if t_cur+win_size-1 > T
                            break
                        end            
                        if judge_statu(pca(t_cur: t_cur+win_size-1))
                            t_cur = t_cur + win_size;
                            if t_cur+win_size-1 > T
                                break
                            end                   
                            if judge_statu(pca(t_cur: t_cur+win_size-1))
                                s = 3;
                            else
                                s = 0;
                            end
                        else
                            s = 0;
                        end
                    end  
                else 
                    t_cur = t_cur + win_size;
                    if t_cur+win_size-1 > T
                        break
                    end           
                    if judge_statu(pca(t_cur: t_cur+win_size-1))
                        t_cur = t_cur + win_size;
                        if t_cur+win_size-1 > T
                            break
                        end                
                        if judge_statu(pca(t_cur: t_cur+win_size-1))
                            s = 2;
                        else
                            s = 0;
                        end
                    else
                        s = 0;
                    end
                end
            
                if s > 0
                    statu = statu + s;
                else
                    if statu >= 5
                        a_i = a_i + 1;
                        action_list(a_i) = t_sta;
                        a_i = a_i + 1;
                        action_list(a_i) = t_cur;
                    end
                    statu = 0;
                end
            end
        end
        t_cur = t_cur + win_size;
    end

    if flag
        figure(4)
        plot(pca(1:T), 'b')
        for i = 1 : a_i
            hold on
            if flag
                plot([action_list(i), action_list(i)], [-100, 100], 'r')
            else 
                plot([action_list(i), action_list(i)], [-100, 100], 'k')
            end
            flag = ~flag;
        end
    end
    
end

