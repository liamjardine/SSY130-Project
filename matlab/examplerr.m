remove_outliers = true;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

NN = 8000; % Length of Data to analyze and plot
offset = 4000; %Offset into the dataset

fs = 128;

for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    x0 = data(offset+(1:NN),1);

    % Here is a lmfir_diff filter designed (needs to be completed)
    p=4;
    M=int32(fs/7);
    m0=M;

    x0_high = highpass(x0,3,fs);
    h1diff = lmfir_diff(@monofun,@monoderfun, p,M,m0);
    y1diff = filter(h1diff,1,x0_high);
    y1diff = y1diff/max(abs(y1diff));
    
    
    %y1diff = x0; % uncomment this if directly peak-find on ECG trace.
    clf
    figure(1)
    plot(y1diff, "DisplayName", "Derivative")
    hold on
    plot(0.1*x0,"DisplayName", "Trace")
    % You need to set MPH and MPD to some good values....

    MPH = .5;   %TODO: Normalise
    MPD = 50;
    [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
    plot(r_indices,p,'hr',"DisplayName", "RR samples")
    hold off
    xlabel("Samples")
    legend()
    
    % Calculate RR intervals
    rr = diff(r_indices);
    figure(2)
    bpm = (1./rr)*fs*60;
    time_axis = r_indices(1:end-1)/fs;
    plot(time_axis,bpm,"DisplayName", "IHR")
    ylabel("BPM")
    xlabel("Time [s]")

    if remove_outliers
    [time_axis, bpm] = outliers(time_axis,bpm,4);
    hold on
    plot(time_axis,bpm,"DisplayName", "IHR, filtered")
    hold off
    end


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
