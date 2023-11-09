function bpm = fbmp(trace, f_sample)
ndtft = length(trace);
w_sample = f_sample * 2*pi;
trace_ft = fftshift(fft(trace,ndtft));

w_axis = linspace(-w_sample/2, w_sample/2, ndtft);


bpm_axis = w_axis* 60/(2*pi);
bpm_axis = bpm_axis';


%plot(bpm_axis,abs(trace_ft))
hold on
trace_ft = trace_ft .* (abs(bpm_axis) > 35 & abs(bpm_axis) < 200);
%plot(bpm_axis,abs(trace_ft))

[~, ind] = max(trace_ft);
bpm = abs(bpm_axis(ind));
end