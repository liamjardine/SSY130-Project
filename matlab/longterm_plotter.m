clear
load("all.mat")
close all; clf

limit = 1200;
figure(1)
plot(ave1(1:limit));hold on; plot(ave2(1:limit)),plot(ave3(1:limit));plot(ave4(1:limit))
title("Average BPM")
figure(2)
plot(std1(1:limit));hold on; plot(std2(1:limit)),plot(std3(1:limit));plot(std4(1:limit))
title("STD")