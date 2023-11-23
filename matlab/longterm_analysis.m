remove_outliers = true;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

fs = 128;
N_samples = fs*60;

for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    trace = data(:,1);
    std_arr = [];
    ave_arr = [];

    
    for minute=1:(floor(length(trace)/N_samples))-1
        x0 = trace((1:N_samples)+minute*N_samples);

        % Here is a lmfir_diff filter designed (needs to be completed)
        p=4;
        M=int32(fs/7);
        m0=M;
    
        x0_high = highpass(x0,3,fs);
        h1diff = lmfir_diff(@monofun,@monoderfun, p,M,m0);
        y1diff = filter(h1diff,1,x0_high);
        y1diff = y1diff/max(abs(y1diff));
        
    
        MPH = .5;
        MPD = 50;
        [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
        
        % Calculate RR intervals
        rr = diff(r_indices);
        bpm = (1./rr)*fs*60;
        time_axis = r_indices(1:end-1)/fs;
    
        if remove_outliers
        [time_axis, bpm] = outliers(time_axis,bpm,4);
        end
    
        std_arr = [std_arr std(bpm)];
        ave_arr = [ave_arr mean(bpm)];
    end
    plot(std_arr,"DisplayName", "STD")
    plot(ave_arr,"DisplayName", "Average")
    pause
end 

function f = monofun(i,m) 
    if i==0
        f = 1;
    elseif i==1
        f = m;
    elseif i>0
        f = m^i;
    else
        error('i must be a positive integer');
    end
end

function fd = monoderfun(i,m) 
    if i==0
        fd = 0;
    elseif i==1
        fd = 1;
    elseif i>1
        fd = i*(m^(i-1));
    else
        error('i must be a positive integer');
    end
end
