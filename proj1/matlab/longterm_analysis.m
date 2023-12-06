remove_outliers = true;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

fs = 128;
N_samples = fs*60;






clc
for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    trace = data(:,1);

    % Here is a lmfir_diff filter designed (needs to be completed)
    p=4;
    M=int32(fs/7);
    m0=M;
    h1diff = lmfir_diff(@monofun,@monoderfun, p,M,m0);
    
    minutes = 1:(floor(length(trace)/N_samples))-1;

    std_arr = zeros(length(minutes),1);
    ave_arr = zeros(length(minutes),1);

    addpath('C:\code\Chalmers_Code\M1\AppliedSP\SSY130-Project\matlab\matlab-ParforProgress2-1.23.1')
    percentage_update = 0.1;
    do_debug = 1;
    run_javaaddpath = 1; 
    show_execution_time = 1;
    %ppm = ParforProgressStarter2('test', length(minutes), percentage_update, do_debug, run_javaaddpath, show_execution_time);
disp("doing:  " + ff)

    parfor minute=minutes
        x0 = trace((1:N_samples)+minute*N_samples);
    
        x0_high = highpass(x0,3,fs);
        y1diff = filter(h1diff,1,x0_high);
        y1diff = y1diff/max(abs(y1diff));
        
    
        MPH = .5;
        MPD = 50;
        [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
        
        % Calculate RR intervals
        rr = diff(r_indices);
        bpm = (1./rr)*fs*60;
        time_axis = r_indices(1:end-1)/fs;
        if isempty(bpm)
            std_arr(minute+1,ff) = 0;
            ave_arr(minute+1,ff) = 0;
            continue
        end

        if remove_outliers
        [time_axis, bpm] = outliers(time_axis,bpm,4);
        end
        
        std_arr(minute+1,ff) = std(bpm);
        ave_arr(minute+1,ff) = mean(bpm);

    end
    save("ansfile"+ff+".mat","std_arr", "ave_arr")
    delete(ppm)
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
