%function

%[h,data_info] = GetCsiData(FILENAME,skip_f,skip_t)
%h bw�˲�������� skip_f ǰ�������İٷֱ� skip_t���������İٷֱ�

%pca = PCA(h,m)   
%hԭʼ���� m���صڼ���?

%[cA,cD] = GetDWT(data,limit,type)  
%data ԭʼ���� limit ������������Ĭ��10�� type �任���ͣ�����Ĭ��db4��

%r = GetDWT2(data,limit,up,low,type)
%data ԭʼ���� limit ������������Ĭ��10��up low ���صĲ�����Χ������Ĭ��3~6�㣩 type �任���ͣ�����Ĭ��db4��

function [r, pca, h, T] = data_exchange(filename, pca_l, dwt_up, dwt_low, draw_flag, test_flag)
    addpath ..\MATLAB

    %bw�˲�����
    if test_flag == false
        h = GetCsiData(filename);
    else
        load(filename);
        rssidata = rssidata(:,2:181);
        h = real(csi');
    end
    T = size(h, 2);
    
%     figure(1)
%     n = 3;
%     for i = 1 : n
%         subplot(n, 1, i);
%         plot(h(i, 1:T))
%     end
    
    %pca����
    pca = PCA(h, pca_l);

    %��ɢС���任����
    r = GetDWT2(pca, 10, dwt_up, dwt_low);
    
    if draw_flag == true
        %����bw������
        figure(1)
        n = 3;
        for i = 1 : n
            subplot(n, 1, i);
            plot(h(i, 1:T))
        end
        %����pca������
        figure(2)
        plot(pca(1:6000));
        xlabel('Time');
        ylabel('Amplitude');
%         %������ɢС��������
%         figure(3)
%         for i = dwt_up : dwt_low
%             subplot(dwt_low-dwt_up+1, 1, i-dwt_up+1);
%             s = (i-dwt_up)*T;
%             plot(r(s+1:s+T))
%         end
    end
end

