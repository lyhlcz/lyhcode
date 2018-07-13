function [ F ] = carm_feature( s )
%CARM_FEATURE Summary of this function goes here
%   Detailed explanation goes here
    % input : s - averaged column signal sequence
    % output: F - feature matrix (size: #feature * ceil(#sample/fragsize) )

    fragsize = 128;
    %F = waveletproc(s,fragsize).';
    F = waveletproc2(s,fragsize);
end

function [data]=waveletproc2(s,fragsize)

    wave = 'db4';

    % normalization
    s = (s-mean(s))/std(s);
    %eng = max(abs(s));
    %s = s/eng;
    
    % calculate recovered detail waveform
    [c,l] =wavedec(s,7,wave);
    r = [];
    for i = 3:7
        temp = wrcoef('d',c,l,wave,i).'; % column vector
        figure(2)
        plot(temp);
        r = [r temp];
    end
    r = r.^2;
    
    % feature extration
    data = [];
    for i = 1:fragsize:size(s,2)
        bg = i;
        ed = min([length(s) i+fragsize-1]);
        temp = mean(r(bg:ed,:))';
        if(i==1);last=zeros(size(temp));end
        if(size(s,2)-i<=fragsize/4);break;end
        temp2 = [temp;temp-last];
        data = [data temp2];
        last = temp;
    end
    data(6:10,1) = data(6:10,2);
    
    for i = 1:size(data,1)
        mu = mean(data(i,:));
        sigma = std(data(i,:));
        data(i,:) = (data(i,:)-mu )/sigma;
    end
end


function [data]=waveletproc(csi,fragsize)
%extract features from the data


    %parameters used for wavelet
    level=10;
    minlevel=2;
    wave='dmey';

    s1=csi;
    wavetemp={};
    %normalize the data
    s1=s1-mean(s1);
    eng=max(abs(s1));
    s1=s1/eng;
    %wavelet decompose data
    [c l] =wavedec(s1,level,wave);

    lstart=1;
    lend=l(1);
    coeff=c(lstart:lend);
    lmid=round(length(coeff)/2);
    el=ceil(length(s1)/(2^level)/2);
    wavetemp{1}=sqrt(coeff(lmid-el:lmid+el).^2/4^level);

    for k=level:-1:minlevel 
      lstart=sum(l(1:level-k+1)+1);
      lend=sum(l(1:level-k+2));
      coeff=c(lstart:lend);
      lmid=round(length(coeff)/2);
      el=ceil(length(s1)/(2^k)/2);
      wavetemp{level-k+2}=sqrt(coeff(lmid-el:lmid+el).^2/4^k);
    end

    id=1;
    for i=1:fragsize:length(s1)
        index=ceil((i+fragsize)/2^level);
        if index>length(wavetemp{1})
            index=length(wavetemp{1});
        end
        data(id,1)=mean(wavetemp{1}(floor(i/2^level)+1:index) );
        for k=level:-1:minlevel 
            index=ceil((i+fragsize)/2^k);
            if index>length(wavetemp{level-k+2})
                    index=length(wavetemp{level-k+2});
            end
            data(id,level-k+2)=mean(wavetemp{level-k+2}(floor(i/2^k)+1:index) );
        end
        data(id,level-minlevel+3)=sum(data(id,1:level-minlevel+2));

        if(id>1)
            data(id,level-minlevel+4:(level-minlevel+3)*2)=data(id,1:level-minlevel+3)-temp;
        else
            data(id,level-minlevel+4:(level-minlevel+3)*2)=0;
        end

        temp= data(id,1:level-minlevel+3);

        data(id,1:level-minlevel+2)=data(id,1:level-minlevel+2)/data(id,level-minlevel+3);
        data(id,level-minlevel+3)=data(id,level-minlevel+3)*eng;

        id=id+1;

    end
end

