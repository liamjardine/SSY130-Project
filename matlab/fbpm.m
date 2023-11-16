function bpm = fbpm(trace, f_sample)
ndtft = 150000; % for better accuracy;
w_sample = f_sample * 2*pi;
trace_ft = fftshift(fft(trace,ndtft));

w_axis = linspace(-w_sample/2, w_sample/2, ndtft+1);
w_axis(end) = [];


bpm_axis = w_axis* 60/(2*pi);
bpm_axis = bpm_axis';

trace_ft = trace_ft .* (abs(bpm_axis) > 35 & abs(bpm_axis) < 200);

[~, ind] = max(trace_ft);
bpm = abs(bpm_axis(ind));
end